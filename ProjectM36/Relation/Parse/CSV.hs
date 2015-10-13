{-# LANGUAGE OverloadedStrings #-}
module ProjectM36.Relation.Parse.CSV where
--parse Relations from CSV
import Data.Csv.Parser
import qualified Data.Vector as V
import Data.Char (ord)
import qualified Data.ByteString.Lazy as BS
import ProjectM36.Base
import ProjectM36.Relation
import ProjectM36.Atom
import ProjectM36.Error
import Data.Text.Encoding (decodeUtf8)
import qualified ProjectM36.Attribute as A
import qualified Data.Set as S
import Data.HashMap.Lazy as HM
import qualified Data.List as L
import qualified Data.Text as T
import Data.Attoparsec.ByteString.Lazy
import Text.Read (readMaybe)
import Data.Typeable (typeRep, Proxy(Proxy))
import ProjectM36.ConcreteTypeRep
import Data.Either (either)

data CsvImportError = CsvParseError String |
                      AttributeMappingError RelationalError |
                      UnsupportedAtomTypeError AttributeName |
                      HeaderAttributeMismatchError (S.Set AttributeName)
                    deriving (Show)

csvDecodeOptions :: DecodeOptions
csvDecodeOptions = DecodeOptions {decDelimiter = fromIntegral (ord ',')}

makeAtom :: AttributeName -> AtomType -> T.Text -> Either CsvImportError Atom
makeAtom attrName (AtomType cTypeRep) strIn = if unCTR cTypeRep == typeRep (Proxy :: Proxy Int) then
                                                either (Left . AttributeMappingError . ParseError . T.pack) (Right . Atom) ((fromText strIn) :: Either String Int)
                                              else
                                                Left $ AttributeMappingError (ParseError strIn)
                                             {- where readAtomable :: (Atomable a) => Proxy a -> T.Text -> Either CsvImportError Atom
                                                    readAtomable _ strIn' = case fromText strIn of
                                                                              Right val -> Right $ Atom (val :: a)
                                                                              Left err -> Left $ AttributeMappingError (ParseError (T.pack err))-}
makeAtom attrName _ _ = Left $ UnsupportedAtomTypeError attrName


csvAsRelation :: BS.ByteString -> Attributes -> Either CsvImportError Relation
csvAsRelation inString attrs = case parse (csvWithHeader csvDecodeOptions) inString of
  Fail _ _ err -> Left (CsvParseError err)
  Done _ (headerRaw,vecMapsRaw) -> do
    let strHeader = V.map decodeUtf8 headerRaw
        strMapRecords = V.map convertMap vecMapsRaw
        convertMap hmap = HM.fromList $ L.map (\(k,v) -> (decodeUtf8 k, (T.unpack . decodeUtf8) v)) (HM.toList hmap)
        attrNames = V.map A.attributeName attrs
        attrNameSet = S.fromList (V.toList attrNames)
        headerSet = S.fromList (V.toList strHeader)
        makeTupleList :: HM.HashMap AttributeName String -> [Either CsvImportError Atom]
        makeTupleList tupMap = V.toList $ V.map (\attr -> makeAtom (A.attributeName attr) (A.atomType attr) (T.pack $ tupMap HM.! (A.attributeName attr))) attrs
    case attrNameSet == headerSet of
      False -> Left $ HeaderAttributeMismatchError (S.difference attrNameSet headerSet)
      True -> do
        tupleList <- mapM sequence $ V.toList (V.map makeTupleList strMapRecords)
        case mkRelationFromList attrs tupleList of
          Left err -> Left (AttributeMappingError err)
          Right rel -> Right rel

