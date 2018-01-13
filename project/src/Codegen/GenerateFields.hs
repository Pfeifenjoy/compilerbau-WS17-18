{-|
This module generates the fields. Additional it gens the init
method, which is used to assign non final values to the fields.
-}
module Codegen.GenerateFields (
  genFields,
  genCode
) where

import ABSTree hiding (Return)
import Codegen.Data.ClassFormat
import Codegen.Data.MethodFormat
import Codegen.GenerateConstantPool
import Data.Char(ord)
import Data.Bits
import Control.Lens
import Control.Monad.Trans.State.Lazy

genFields :: Bool -- ^ exists constructor with no arguments
          -> [FieldDecl] 
          -> State ClassFile ()
genFields constructor = mapM_ (genFD constructor)

genFD :: Bool -- ^ exists constructor with no arguments
      -> FieldDecl 
      -> State ClassFile ()
genFD constructor (FieldDecl vds vis static) 
  = mapM_ (genVD vis static) vds >> if constructor 
                                    then return ()
                                    else genInit vds

genVD :: Visibility
      -> Bool -- ^ is the field static?
      -> VariableDecl
      -> State ClassFile ()
genVD vis static (VariableDecl name typ final mayExpr) =
  do indexName <- genUTF8 name
     indexType <- genUTF8 $ typeToDescriptor typ
     attrFields <- genAttrFields mayExpr
     let accessFlags = visToFlag vis : [0x8 | static] ++ [0x10 | final]
         fieldInfo = FieldInfo { _afFi = AccessFlags accessFlags
                               , _indexNameFi = indexName
                               , _indexDescrFi = indexType
                               , _tamFi = length attrFields
                               , _arrayAttrFi = attrFields
                               }
     modify $ (countFields +~ 1) . over arrayFields (fieldInfo:)


genAttrFields :: Maybe Expr
                   -> State ClassFile AttributeInfos
genAttrFields Nothing  = return []
genAttrFields (Just expr) =
  do indexName <- genUTF8 "constant"
     indexValue <- exprToConstantPool expr
     return [AttributeConstantValue { _indexNameAttr = indexName
                                    , _tamAttr = 2
                                    , _indexValueAttr = indexValue
                                    }]

genInit :: [VariableDecl] -> State ClassFile ()
genInit vds =
  do indexType <- genUTF8 "()V"
     indexCode <- genUTF8 "Code"
     indexName <- view (this . indexTh) <$> get
     codeVars <- mapM genCode vds
     let code = codeToInt $ [Aload0,Invokespecial 0 1]
                            ++ concatMap snd codeVars
                            ++ [Return]
         lengthCode = 5 + sum (map fst codeVars)
         codeAttr = AttributeCode { _indexNameAttr = indexCode
                                  , _tamLenAttr = 14+lengthCode
                                  , _lenStackAttr = 1
                                  , _lenLocalAttr = 1
                                  , _tamCodeAttr = lengthCode
                                  , _arrayCodeAttr = code
                                  , _tamExAttr = 0
                                  , _arrayExAttr = []
                                  , _tamAtrrAttr = 0
                                  , _arrayAttrAttr = []
                                  }
         methodInfo = MethodInfo { _afMi = AccessFlags []
                                 , _indexNameMi = indexName
                                 , _indexDescrMi = indexType
                                 , _tamMi = 1
                                 , _arrayAttrMi = [codeAttr]
                                 }
     modify $ over arrayMethods (methodInfo:)

genCode :: VariableDecl -> State ClassFile (Int,Code)
genCode (VariableDecl _ _  _ Nothing) = return (0,[])
genCode (VariableDecl name "float" _ (Just expr)) = undefined
genCode (VariableDecl name _  _ (Just expr)) =
  do indexName <- genUTF8 name
     let val = evalInt expr
         (b1,b2) = split16Byte indexName
     return (if val > 5 then 6 else 5
            ,[Aload0,iconst val,Putfield b1 b2])
-- helper functions

evalInt ::  Expr -> Int
evalInt (BooleanLiteral True)  = 1
evalInt (BooleanLiteral False) = 0
evalInt (CharLiteral char)     = ord char
evalInt (IntegerLiteral int)   = fromIntegral int
evalInt (Binary "&&" expr1 expr2) = evalInt expr1 .&. evalInt expr2
evalInt (Binary "||" expr1 expr2) = evalInt expr1 .|. evalInt expr2
evalInt (Binary "+" expr1 expr2) = evalInt expr1 + evalInt expr2
evalInt (Binary "-" expr1 expr2) = evalInt expr1 - evalInt expr2
evalInt (Binary "*" expr1 expr2) = evalInt expr1 * evalInt expr2

exprToConstantPool ::  Expr -> State ClassFile Int
exprToConstantPool = genInteger . evalInt
