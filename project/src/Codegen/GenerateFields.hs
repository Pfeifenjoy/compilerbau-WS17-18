{-|
This module generates the fields. Additional it gens the init
method, which is used to assign non final values to the fields.
-}
{-# OPTIONS -Wall #-}
module Codegen.GenerateFields (
  genFields,
  genCode
) where

import ABSTree hiding (Return)
import Codegen.Data.ClassFormat
import Codegen.EvalCode
import Codegen.Data.Assembler
import Codegen.GenerateConstantPool
import Control.Lens
import Control.Monad.Trans.State.Lazy

genFields :: Bool -- ^ exists constructor with no arguments
          -> [FieldDecl]
          -> State ClassFile ()
genFields False [] = genInit []
genFields constructor fds
  = do mapM_ genFD fds
       if constructor
       then return ()
       else genInit (concatMap (\(FieldDecl vds _ _) -> vds) fds)

genFD :: FieldDecl
      -> State ClassFile ()
genFD (FieldDecl vds vis static)
  = mapM_ (genVD vis static) vds

genVD :: Visibility
      -> Bool -- ^ is the field static?
      -> VariableDecl
      -> State ClassFile ()
genVD vis static (VariableDecl name typ final mayExpr) =
  do indexName <- genUTF8 name
     indexType <- genUTF8 $ typeToDescriptor typ
     attrFields <- if final then genAttrFields mayExpr else return []
     let accessFlags = visToFlag vis : [0x8 | static] ++ [0x10 | final]
         fieldInfo = FieldInfo { _afFi = AccessFlags accessFlags
                               , _indexNameFi = indexName
                               , _indexDescrFi = indexType
                               , _tamFi = length attrFields
                               , _arrayAttrFi = attrFields
                               }
     modify $ over arrayFields (fieldInfo:)


genAttrFields :: Maybe Expr
                   -> State ClassFile AttributeInfos
genAttrFields Nothing  = return []
genAttrFields (Just expr) =
  do indexName <- genUTF8 "ConstantValue"
     indexValue <- exprToConstantPool expr
     return [AttributeConstantValue { _indexNameAttr = indexName
                                    , _tamAttr = 2
                                    , _indexValueAttr = indexValue
                                    }]

genInit :: [VariableDecl] -> State ClassFile ()
genInit vds =
  do indexType <- genUTF8 "()V"
     indexCode <- genUTF8 "Code"
     indexThis <- genMethodRefSuper "<init>" "()V"
     indexName <- genUTF8 "<init>"
     codeVars <- mapM genCode vds
     let (b1,b2) = split16Byte indexThis
         code =  [Aload0,Invokespecial b1 b2]
                    ++ concatMap snd codeVars
                    ++ [Return]
         lengthCode = 5 + sum (map fst codeVars)
         codeAttr = AttributeCode { _indexNameAttr = indexCode
                                  , _tamLenAttr = 12+lengthCode
                                  , _lenStackAttr = if lengthCode > 5
                                                    then 2 else 1
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
genCode (VariableDecl _ "float" _ (Just _)) = undefined
genCode (VariableDecl name typ  _ (Just expr)) =
  do idx <- genFieldRefSuper name $ typeToDescriptor typ
     let val = evalInt expr
         (b1,b2) = split16Byte idx
     return (if val > 5 then 6 else 5
            ,[Aload0,iconst val,Putfield b1 b2])

-- helper functions

exprToConstantPool ::  Expr -> State ClassFile Int
exprToConstantPool = genInteger . evalInt
