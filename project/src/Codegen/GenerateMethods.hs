module Codegen.GenerateMethods (
  generateMethods
) where
import ABSTree
import qualified Codegen.Data.MethodFormat as MF 
import Codegen.Data.MethodFormat hiding (Return)
import Codegen.Data.ClassFormat
import Codegen.GenerateConstantPool
import Control.Lens
import Control.Arrow
import Control.Monad
import Control.Monad.Trans.State.Lazy

generateMethods :: [MethodDecl] -> State ClassFile () 
generateMethods mds 
  = modify (set countMethods (length mds)) >> mapM_ generateMethod mds 

generateMethod ::  MethodDecl -> State ClassFile ()
generateMethod (MethodDecl name typ argDecls stmt vis static) = 
  do indexName <- generateUTF8 name 
     let getArgDesr (ArgumentDecl _ typ _) = typeToDescriptor typ
         descr = "(" ++ concatMap getArgDesr argDecls ++ ")"
                     ++ typeToDescriptor typ
     indexType <- generateUTF8 descr 
     indexCode <- generateUTF8 "Code" 
     code <- codeToInt <$> generateMethodsStmt stmt
     let accessFlags = visToFlag vis : [8 | static] 
         codeAttr = AttributeCode { _indexNameAttr = indexCode
                                  , _tamLenAttr = undefined
                                  , _lenStackAttr = undefined
                                  , _lenLocalAttr = undefined
                                  , _tamCodeAttr = undefined
                                  , _arrayCodeAttr = undefined
                                  , _tamExAttr = 0 
                                  , _arrayExAttr = [] 
                                  , _tamAtrrAttr = 0 
                                  , _arrayAttrAttr = [] 
                                  }
         methodInfo = MethodInfo { _afMi = AccessFlags accessFlags 
                                 , _indexNameMi = indexName 
                                 , _indexDescrMi = indexType 
                                 , _tamMi = 1 
                                 , _arrayAttrMi = [codeAttr] 
                                 }
     modify $ over arrayMethods (methodInfo:) 

generateMethodsStmt :: Stmt -> State ClassFile MF.Code
generateMethodsStmt (Block stmts) 
  = foldr ((-++-) . generateMethodsStmt) (return []) stmts
generateMethodsStmt (Return expr) = undefined
generateMethodsStmt (While cond stmt) = undefined
generateMethodsStmt (DoWhile cond stmt) = undefined
generateMethodsStmt (For stmt1 expr stmt2 stmt3) = undefined
generateMethodsStmt Break = undefined
generateMethodsStmt Continue = undefined
generateMethodsStmt (If cond stmt (Just elseStmt)) = undefined
generateMethodsStmt (If cond stmt Nothing) = undefined
generateMethodsStmt (Switch expr switchCases (Just stmts)) = undefined
generateMethodsStmt (Switch expr switchCases Nothing) = undefined
generateMethodsStmt (LocalVarDecls variableDecls) = undefined
generateMethodsStmt (StmtExprStmt stmtExpr) = undefined
generateMethodsStmt (TypedStmt stmt _) = generateMethodsStmt stmt 

generateMethodsExpr :: Expr -> State ClassFile MF.Code
generateMethodsExpr This = undefined
generateMethodsExpr (LocalOrFieldVar str) = undefined
generateMethodsExpr (InstVar expr str) = undefined
generateMethodsExpr (Unary str expr) = undefined
generateMethodsExpr (Binary "+" expr1 expr2)
  = generateMethodsExpr expr1
    -++- generateMethodsExpr expr2
    -++- return [Iadd]
generateMethodsExpr (Binary "-" expr1 expr2) = undefined
-- TODO add Isub to assembler
--  = msum [generateMethodsExpr expr1
--         ,generateMethodsExpr expr2
--         ,return [Isub]]
generateMethodsExpr (InstanceOf expr typ) = undefined
    -- TODO extra instanceOf
-- expr1 ? expr2 : expr3 cf = undefined
generateMethodsExpr (Ternary expr1 expr2 expr3) = undefined 
generateMethodsExpr (BooleanLiteral True) = return [Iconst1]
generateMethodsExpr (BooleanLiteral False) = return [Iconst0] 
generateMethodsExpr (CharLiteral char) = undefined
generateMethodsExpr (IntegerLiteral int) 
  = return [iconst $ fromIntegral int]
    --  LongLiteral Int64
    --  FloatLiteral Float
    --  DoubleLiteral Double
    --  StringLiteral String
generateMethodsExpr JNull = undefined
generateMethodsExpr (StmtExprExpr stmtExpr) = undefined
generateMethodsExpr (TypedExpr expr _) = generateMethodsExpr expr 


-- helper functions

visToFlag :: Visibility -> Int
visToFlag Public = 1
visToFlag Private = 2
-- visToFlag Protected = 4

typeToDescriptor :: String -> String
typeToDescriptor "boolean" = "Z"
typeToDescriptor "char" = "C"
typeToDescriptor "int" = "I"
typeToDescriptor "void" = "V"
typeToDescriptor object = "L" ++ object ++ ";"

iconst :: Int -> Assembler
iconst 0 = Iconst0
iconst 1 = Iconst1
iconst 2 = Iconst2

(-++-) :: Applicative m => m [a] -> m [a] -> m [a]
a -++- b = (++) <$> a <*> b 
