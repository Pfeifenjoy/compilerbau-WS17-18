module GenerateConstantPool where 
import Codegen.Data.ClassFormat
import ABSTree
import Data.Word
import Prelude hiding ((!))
import qualified Data.HashMap.Lazy as HM
import Data.HashMap.Lazy ((!))

generateUTF8 :: CPInfos -> String -> Word8 -> (CPInfos,Word8)
generateUTF8 hm str index = (newHM , newHM ! utf8info)
  where
    utf8info = Utf8Info { tamCp = length str
                        , cadCp = str
                        , desc  = ""
                        }
    newHM = HM.insert utf8info (index+1) hm

generateExpr :: CPInfos -> Expr -> Word8 -> (CPInfos,Word8)
generateExpr hm This index = (newHM ,newHM ! clInfo)
  where
    clInfo = ClassInfo { indexCp = indexName 
                       , desc = ""
                       }
    newHM = HM.insert clInfo (index+1) hm
    (hm',indexName) = generateUTF8 hm "This" index
                                           
-- generate Super 
-- variables
generateExpr hm (TypedExpr (LocalOrFieldVar name) typ) index = undefined 
generateExpr hm (InstVar expr name) index = undefined 
    -- operators
generateExpr hm (Unary str expr) index = undefined 
generateExpr hm (Binary str expr1 expr2 ) index = undefined -- (&&, ||, ..., instanceOf)
generateExpr hm (InstanceOf expr typ) index = undefined 
    -- TODO extra instanceOf
generateExpr hm (Ternary expr1 expr2 expr3 ) index = undefined 
    --literals
generateExpr hm (BooleanLiteral bool) index = undefined 
    -- | ByteLiteral Int8
generateExpr hm (CharLiteral char) index = undefined 
generateExpr hm (IntegerLiteral int32) index = undefined 
    -- | LongLiteral Int64
    -- | FloatLiteral Float
    -- | DoubleLiteral Double
    -- | StringLiteral String
generateExpr hm JNull index = undefined 
    -- other
generateExpr hm (StmtExprExpr stmtExpr) index = undefined 
generateExpr hm (TypedExpr expr _ ) index = undefined 


generateStmt :: CPInfos -> Stmt -> Word8 -> (CPInfos,Word8)
-- Function Statments
generateStmt hm (Return expr) index = undefined 
-- Loop Statements
generateStmt hm (While condExpr stmt ) index = undefined
generateStmt hm (DoWhile condExpr stmt ) index = undefined
generateStmt hm (For startStmt iterateExpr endStmt stmt) index = undefined
-- | ForEach { iterable :: Expr, range :: Expr }
generateStmt hm Break index = undefined 
generateStmt hm Continue index = undefined 
-- Conditional Statements
generateStmt hm (If condExpr stmt (Just elseStmt) ) index = undefined 
generateStmt hm (If condExpr stmt Nothing ) index = undefined 
generateStmt hm (Switch varExprs [cases] (Just finalStmt) ) index = undefined 
generateStmt hm (Switch varExprs [cases] Nothing ) index = undefined 
-- other
generateStmt hm (LocalVarDecl variableDecl) index = undefined 
generateStmt hm (StmtExprStmt stmtExpr) index = undefined 
generateStmt hm (TypedStmt stmt typ) index = undefined 

generateStmtVariableDecl :: CPInfos -> VariableDecl -> Word8 -> (CPInfos,Word8)
generateStmtVariableDecl hm (VariableDecl name typ final) index = undefined 

generateStmtExpr :: CPInfos -> StmtExpr -> Word8 -> (CPInfos,Word8)
generateStmtExpr hm (Assign expr1 expr2) index = undefined 
generateStmtExpr hm (New typ argExprs) index = undefined 
generateStmtExpr hm (MethodCall expr str exprs) index = undefined 
generateStmtExpr hm (TypedStmtExpr stmtExpr typ) index = undefined 

generateStmtSwitchCase :: CPInfos -> SwitchCase -> Word8 -> (CPInfos,Word8)
generateStmtSwitchCase hm (Expr stmt) index = undefined 
