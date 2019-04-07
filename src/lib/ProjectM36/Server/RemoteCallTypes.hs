{-# LANGUAGE DeriveAnyClass, DeriveGeneric #-}
module ProjectM36.Server.RemoteCallTypes where
import ProjectM36.Base
import ProjectM36.IsomorphicSchema
import ProjectM36.TransactionGraph
import ProjectM36.DataFrame
import ProjectM36.TransGraphRelationalExpression
import ProjectM36.Session
import GHC.Generics
import Data.Binary
import Control.Distributed.Process (ProcessId)

{-# ANN module ("HLint: ignore Use newtype instead of data" :: String) #-}
-- | The initial login message. The argument should be the process id of the initiating client. This ProcessId will receive notification callbacks.
data Login = Login ProcessId
           deriving (Binary, Generic)
                    
data Logout = Logout
            deriving (Binary, Generic)
data ExecuteRelationalExpr = ExecuteRelationalExpr SessionId RelationalExpr 
                           deriving (Binary, Generic)
data ExecuteDataFrameExpr = ExecuteDataFrameExpr SessionId DataFrameExpr
                           deriving (Binary, Generic)
data ExecuteDatabaseContextExpr = ExecuteDatabaseContextExpr SessionId DatabaseContextExpr
                                deriving (Binary, Generic)
data ExecuteDatabaseContextIOExpr = ExecuteDatabaseContextIOExpr SessionId DatabaseContextIOExpr
                                deriving (Binary, Generic)                                         
data ExecuteGraphExpr = ExecuteGraphExpr SessionId TransactionGraphOperator 
                      deriving (Binary, Generic)
data ExecuteTransGraphRelationalExpr = ExecuteTransGraphRelationalExpr SessionId TransGraphRelationalExpr                               
                                     deriving (Binary, Generic)
data ExecuteHeadName = ExecuteHeadName SessionId
                     deriving (Binary, Generic)
data ExecuteTypeForRelationalExpr = ExecuteTypeForRelationalExpr SessionId RelationalExpr
                                  deriving (Binary, Generic)
data ExecuteSchemaExpr = ExecuteSchemaExpr SessionId SchemaExpr                                 
                         deriving (Binary, Generic)
data ExecuteSetCurrentSchema = ExecuteSetCurrentSchema SessionId SchemaName
                               deriving (Binary, Generic)
data RetrieveInclusionDependencies = RetrieveInclusionDependencies SessionId
                                   deriving (Binary, Generic)
data RetrievePlanForDatabaseContextExpr = RetrievePlanForDatabaseContextExpr SessionId DatabaseContextExpr
                                        deriving (Binary, Generic)
data RetrieveTransactionGraph = RetrieveTransactionGraph SessionId
                              deriving (Binary, Generic)
data RetrieveHeadTransactionId = RetrieveHeadTransactionId SessionId
                                 deriving (Binary, Generic)
data CreateSessionAtCommit = CreateSessionAtCommit TransactionId
                                    deriving (Binary, Generic)
data CreateSessionAtHead = CreateSessionAtHead HeadName
                                  deriving (Binary, Generic)
data CloseSession = CloseSession SessionId
                    deriving (Binary, Generic)
data RetrieveAtomTypesAsRelation = RetrieveAtomTypesAsRelation SessionId
                                   deriving (Binary, Generic)
data RetrieveRelationVariableSummary = RetrieveRelationVariableSummary SessionId
                                     deriving (Binary, Generic)
data RetrieveAtomFunctionSummary = RetrieveAtomFunctionSummary SessionId
                                   deriving (Binary, Generic)
data RetrieveDatabaseContextFunctionSummary = RetrieveDatabaseContextFunctionSummary SessionId
                                   deriving (Binary, Generic)
data RetrieveCurrentSchemaName = RetrieveCurrentSchemaName SessionId
                                 deriving (Binary, Generic)
data TestTimeout = TestTimeout SessionId                                          
                   deriving (Binary, Generic)
data RetrieveSessionIsDirty = RetrieveSessionIsDirty SessionId                            
                            deriving (Binary, Generic)
data ExecuteAutoMergeToHead = ExecuteAutoMergeToHead SessionId MergeStrategy HeadName
                              deriving (Binary, Generic)
data RetrieveTypeConstructorMapping = RetrieveTypeConstructorMapping SessionId 
                                      deriving (Binary, Generic)
