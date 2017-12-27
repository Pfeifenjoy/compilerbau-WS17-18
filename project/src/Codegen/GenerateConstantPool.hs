module Codegen.GenerateConstantPool where 
import Codegen.Data.ClassFormat
import ABSTree
import Data.Word
import Control.Lens
import Prelude hiding ((!))
import qualified Data.HashMap.Lazy as HM
import Data.HashMap.Lazy ((!))

{-
 
Use this module to insert a constant in the constant pool

-}

-- | insert a class in the constant pool
generateClass cl str = undefined


-- | insert a field variable in the constant pool
generateFieldRef :: ClassFile -- ^ Class with current constant pool
                 -> Expr -- ^ field to insert in constant pool
                 -> (ClassFile -- ^ new constant pool
                    ,Word8) -- ^ location of field in constant pool
generateFieldRef cl (TypedExpr (LocalOrFieldVar name) typ)
  = (countrCp +~ n $ newCl, loc)
    where
      loc = (newCl^.arrayCp) ! fieldRefInfo
      n = if loc > newCl^.countrCp then 1 else 0
      fieldRefInfo = FieldRefInfo { _indexNameCp        = indexName
                                  , _indexNameandtypeCp = indexNameType
                                  , _desc               = ""
                                  } 
      (newCl, indexName, indexNameType) 
         = generateVarMethod cl name typ fieldRefInfo

-- | insert a method in the constant pool
generateMethodRef :: ClassFile -- ^ current constant pool
                  -> StmtExpr -- ^ method to insert in constant pool
                  -> (ClassFile -- ^ new constant pool
                     ,Word8) -- ^ location of field in constant pool
generateMethodRef cl (TypedStmtExpr (MethodCall _ name _) typ)
  = (countrCp +~ n $ newCl, loc)
  where
    loc = (newCl^.arrayCp) ! methodRefInfo
    n = if loc > newCl^.countrCp then 1 else 0
    methodRefInfo = MethodRefInfo { _indexNameCp        = indexName
                                  , _indexNameandtypeCp = indexNameType
                                  , _desc               = ""
                                  } 
    (newCl, indexName, indexNameType) 
       = generateVarMethod cl name typ methodRefInfo

-- | insert a interface in the constant pool
generateInterfaceRef = undefined

-- | insert a string in the constant pool
generateString = undefined

-- | inserts a integer in the constant pool
generateInteger :: ClassFile -- ^ current constant pool
                -> Int -- ^ Int to insert in the constant pool
                -> Word8 -- ^ current highest index in constant pool
                -> (ClassFile -- ^ new constant pool
                   ,Word8) -- ^ location of int in constant pool
generateInteger cl int index
  = (countrCp +~ n $ newCl, loc)
  where
    loc = (newCl^.arrayCp) ! intInfo
    n = if loc > newCl^.countrCp then 1 else 0
    intInfo = IntegerInfo { _numiCp = int 
                          , _desc   = ""
                          }
    newCl = over arrayCp (HM.insert intInfo (cl^.countrCp+1)) cl 

-- | insert a float in the constant pool
generateFloat :: ClassFile -- ^ current constant pool
              -> Float -- ^ Float to insert in the constant pool
              -> (ClassFile -- ^ new constant pool
                 ,Word8) -- ^ location of int in constant pool
generateFloat cl float 
  = (countrCp +~ n $ newCl, loc)
  where
    loc = (newCl^.arrayCp) ! floatInfo
    n = if loc > newCl^.countrCp then 1 else 0
    floatInfo = FloatInfo { _numfCp = float 
                          , _desc   = ""
                          }
    newCl = over arrayCp (HM.insert floatInfo (cl^.countrCp+1)) cl 

-- | insert a long in the constant pool
generateLong :: ClassFile -- ^ current constant pool
              -> (Int,Int) -- ^ Long to insert in the constant pool
              -> (ClassFile -- ^ new constant pool
                 ,Word8) -- ^ location of int in constant pool
generateLong cl (int1,int2)
  = (countrCp +~ n $ newCl, loc)
  where
    loc = (newCl^.arrayCp) ! longInfo
    n = if loc > newCl^.countrCp then 1 else 0
    longInfo = LongInfo { _numiL1Cp = int1 
                        , _numiL2Cp = int2 
                        , _desc     = ""
                        }
    newCl = over arrayCp (HM.insert longInfo (cl^.countrCp+1)) cl 

-- | insert a double in the constant pool
generateDouble :: ClassFile -- ^ current constant pool
              -> (Int,Int) -- ^ Double to insert in the constant pool
              -> (ClassFile -- ^ new constant pool
                 ,Word8) -- ^ location of int in constant pool
generateDouble cl (int1,int2)
  = (countrCp +~ n $ newCl, loc)
  where
    loc = (newCl^.arrayCp) ! doubleInfo
    n = if loc > newCl^.countrCp then 1 else 0
    doubleInfo = DoubleInfo { _numiD1Cp = int1 
                            , _numiD2Cp = int2 
                            , _desc     = ""
                            }
    newCl = over arrayCp (HM.insert doubleInfo (cl^.countrCp+1)) cl 

-- | insert name and type
generateNameAndType :: ClassFile -- ^ current constant pool
                    -> String -- ^ name to insert in constant pool 
                    -> Type -- ^ type to insert in constant pool 
                    -> (ClassFile -- ^ new constant pool
                       ,Word8) -- ^ location of int in constant pool
generateNameAndType cl name typ = (countrCp +~ n $ newCl, loc)
  where
    loc = (newCl^.arrayCp) ! nameTypeInfo
    n = if loc > newCl^.countrCp then 1 else 0
    nameTypeInfo = NameAndTypeInfo { _indexNameCp = indexName
                                   , _indexTypeCp = indexType
                                   , _desc        = ""
                                   } 
    newCl = over arrayCp (HM.insert nameTypeInfo (cl''^.countrCp+1)) cl''
    (cl',indexName) = generateUTF8 cl name
    (cl'',indexType) = generateUTF8 cl' typ 

-- | inserts a utf8 in the constant pool
generateUTF8 :: ClassFile -- ^ current constant pool
             -> String -- ^ string to insert in the constant pool
             -> (ClassFile -- ^ new constant pool
                ,Word8) -- ^ location of String in constant pool
generateUTF8 cl str = (countrCp +~ n $ newCl, loc)
  where
    loc = (newCl^.arrayCp) ! utf8info 
    n = if loc > newCl^.countrCp then 1 else 0
    utf8info = Utf8Info { _tamCp = length str
                        , _cadCp = str
                        , _desc  = ""
                        }
    newCl = over arrayCp (HM.insert utf8info (cl^.countrCp+1)) cl 

-- helper functions

generateVarMethod cl name typ refInfo = (newCl, indexName, indexNameType)
  where
    newCl = over arrayCp (HM.insert refInfo (cl''^.countrCp+1)) cl'' 
    -- Use "This" here because there is no information about the class
    (cl',indexName) = generateClass cl "This"
    (cl'',indexNameType) = generateNameAndType cl name typ 
