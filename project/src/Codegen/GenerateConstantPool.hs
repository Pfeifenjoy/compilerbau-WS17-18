module Codegen.GenerateConstantPool where 
import Codegen.Data.ClassFormat
import ABSTree
import Data.Word
import Prelude hiding ((!))
import qualified Data.HashMap.Lazy as HM
import Data.HashMap.Lazy ((!))

{-
 
Use this module to insert a constant in the constant pool

-}

-- | inserts a string in the constant pool
generateUTF8 :: CPInfos -- ^ current constant pool
             -> String -- ^ string to insert in the constant pool
             -> Word8 -- ^ current highest index in constant pool
             -> (CPInfos -- ^ new constant pool
                ,Word8 -- ^ location of String in constant pool
                ,Word8) -- ^ new highest index in constant pool 
generateUTF8 hm str index = (newHM , newHM ! utf8info, newIndex)
  where
    utf8info = Utf8Info { tamCp = length str
                        , cadCp = str
                        , desc  = ""
                        }
    newHM = HM.insert utf8info (index+1) hm
    newIndex = max (newHM ! utf8info) index

-- | inserts a int in the constant pool
generateInt :: CPInfos -- ^ current constant pool
            -> Int -- ^ Int to insert in the constant pool
            -> Word8 -- ^ current highest index in constant pool
            -> (CPInfos -- ^ new constant pool
               ,Word8 -- ^ location of String in constant pool
               ,Word8) -- ^ new highest index in constant pool 
generateInt hm int index = (newHM , newHM ! intInfo, newIndex)
  where
    intInfo = IntegerInfo { numiCp = int 
                           , desc  = ""
                           }
    newHM = HM.insert intInfo (index+1) hm
    newIndex = max (newHM ! intInfo) index

-- | inserts all constants from a given Expression in the constant pool
generateExpr :: CPInfos -- ^ current constant pool
             -> Expr 
             -> Word8 -- ^ current highest index in constant pool
             -> (CPInfos -- ^ new constant pool
                ,Word8 -- ^ location of String in constant pool
                ,Word8) -- ^ new highest index in constant pool 
generateExpr hm This index = (newHM ,newHM ! clInfo, newIndex)
  where
    clInfo = ClassInfo { indexCp = indexName 
                       , desc = ""
                       }
    newHM = HM.insert clInfo (index+1) hm'
    (hm',indexName,maxIndex) = generateUTF8 hm "This" index
    newIndex = maximum [index, newHM ! clInfo, maxIndex]
                                           
-- generate Super 
-- variables
generateExpr hm (TypedExpr (LocalOrFieldVar name) typ) index 
  = (newHM
    , newHM ! nameTypeInfo
    , newIndex
    )
  where
    nameTypeInfo = NameAndTypeInfo { indexNameCp = indexName
                                   , indexTypeCp = indexType
                                   , desc        = ""
                                   } 
    newHM = HM.insert nameTypeInfo (newIndex+1) hm''
    (hm',indexName,maxIndex') = generateUTF8 hm name index
    (hm'',indexType,maxIndex'') 
        = generateUTF8 hm' typ $ index + 1
    newIndex = maximum [index, newHM ! nameTypeInfo 
                       , maxIndex', maxIndex''
                       ]

generateExpr hm (InstVar expr name) index = undefined 
generateExpr hm (InstanceOf expr typ) index = undefined 
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
generateExpt hm _ index = (hm,index)


generateStmt :: CPInfos -> Stmt -> Word8 -> (CPInfos,Word8)
generateStmt hm (LocalVarDecls variableDecls) index = undefined 
generateStmt hm (StmtExprStmt stmtExpr) index = undefined 
generateStmt hm (TypedStmt stmt typ) index = undefined 

generateStmtVariableDecl :: CPInfos -> VariableDecl -> Word8 -> (CPInfos,Word8)
generateStmtVariableDecl hm (VariableDecl name typ final (Just expr)) index = undefined 
generateStmtVariableDecl hm (VariableDecl name typ final Nothing    ) index = undefined 

generateStmtExpr :: CPInfos -> StmtExpr -> Word8 -> (CPInfos,Word8)
generateStmtExpr hm (Assign expr1 expr2) index = undefined 
generateStmtExpr hm (New typ argExprs) index = undefined 
generateStmtExpr hm (MethodCall expr str exprs) index = undefined 
generateStmtExpr hm (TypedStmtExpr stmtExpr typ) index = undefined 
