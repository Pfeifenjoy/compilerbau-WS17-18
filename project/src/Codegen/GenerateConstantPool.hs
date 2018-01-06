module Codegen.GenerateConstantPool where 
import Codegen.Data.ClassFormat
import ABSTree
import Control.Lens
import Control.Monad.Trans.State.Lazy
import Control.Arrow
import Prelude hiding ((!))
import qualified Data.HashMap.Lazy as HM
import Data.HashMap.Lazy ((!))

{-
 
Use this module to insert a constant in the constant pool

-}

generateInfo :: CPInfo -> State ClassFile Int
generateInfo cpInfo =
  do modify $
       \cf -> over arrayCp (HM.insert cpInfo (cf^.countrCp+1)) cf
     cf <- get
     let loc = (cf^.arrayCp) ! cpInfo 
         n   = if loc > cf^.countrCp then 1 else 0
     put $ countrCp +~ n $ cf
     return loc

-- | insert a class in the constant pool
generateClass :: String -- ^ class to insert in constant pool
              -> State ClassFile -- ^ new constant pool
                       Int -- ^ location of field in constant pool
generateClass name = 
  do index <- generateUTF8 name 
     generateInfo ClassInfo { _tagCp   = TagClass
                            , _indexCp = index
                            , _desc    = ""
                            } 
     


-- | insert a field variable in the constant pool
generateFieldRef :: Expr -- ^ field to insert in constant pool
                 -> State ClassFile -- ^ new constant pool
                          Int -- ^ location of field in constant pool
generateFieldRef (TypedExpr (LocalOrFieldVar name) typ) =
  -- TODO get class name and field name
  do indexName <- generateUTF8 name 
     indexNameType <- generateNameAndType name typ 
     generateInfo FieldRefInfo { _tagCp              = TagFieldRef
                               , _indexNameCp        = indexName
                               , _indexNameandtypeCp = indexNameType
                               , _desc               = ""
                               } 

-- | insert a method in the constant pool
generateMethodRef :: StmtExpr -- ^ method to insert in constant pool
                  -> State ClassFile -- ^ new constant pool
                           Int -- ^ location of field in constant pool
generateMethodRef (TypedStmtExpr (MethodCall _ name _) typ) =
  -- TODO get class name and field name
  do indexName <- generateUTF8 name 
     indexNameType <- generateNameAndType name typ 
     generateInfo MethodRefInfo { _tagCp              = TagMethodRef
                                , _indexNameCp        = indexName
                                , _indexNameandtypeCp = indexNameType
                                , _desc               = ""
                                } 

-- | insert a interface in the constant pool
generateInterfaceRef = undefined

-- | insert a string in the constant pool
generateString = undefined

-- | inserts a integer in the constant pool
generateInteger :: Int -- ^ Int to insert in the constant pool
                -> State ClassFile -- ^ new constant pool
                         Int -- ^ location of int in constant pool
generateInteger int 
  = generateInfo IntegerInfo { _tagCp  = TagInteger
                             , _numiCp = int 
                             , _desc   = ""
                             }

-- | insert a float in the constant pool
generateFloat :: Float -- ^ Float to insert in the constant pool
              -> State ClassFile -- ^ new constant pool
                       Int -- ^ location of int in constant pool
generateFloat float 
    = generateInfo FloatInfo { _tagCp  = TagFloat
                             , _numfCp = float 
                             , _desc   = ""
                             }

-- | insert a long in the constant pool
generateLong :: (Int,Int) -- ^ Long to insert in the constant pool
              -> State ClassFile -- ^ new constant pool
                       Int -- ^ location of int in constant pool
generateLong (int1,int2)
    = generateInfo LongInfo { _tagCp    = TagLong
                            , _numiL1Cp = int1 
                            , _numiL2Cp = int2 
                            , _desc     = ""
                            }

-- | insert a double in the constant pool
generateDouble :: (Int,Int) -- ^ Double to insert in the constant pool
               -> State ClassFile -- ^ new constant pool
                        Int -- ^ location of int in constant pool
generateDouble (int1,int2)
    = generateInfo DoubleInfo { _tagCp    = TagDouble
                              , _numiD1Cp = int1 
                              , _numiD2Cp = int2 
                              , _desc     = ""
                              }

-- | insert name and type
generateNameAndType :: String -- ^ name to insert in constant pool 
                    -> Type -- ^ type to insert in constant pool 
                    -> State ClassFile -- ^ new constant pool
                             Int -- ^ location of int in constant pool
generateNameAndType name typ = 
  do indexName <- generateUTF8 name
     indexType <- generateUTF8 typ
     generateInfo NameAndTypeInfo { _tagCp       = TagNameAndType
                                  , _indexNameCp = indexName
                                  , _indexTypeCp = indexType
                                  , _desc        = ""
                                  } 


-- | inserts a utf8 in the constant pool
generateUTF8 :: String -- ^ string to insert in the constant pool
             -> State ClassFile -- ^ new constant pool
                      Int -- ^ location of String in constant pool
generateUTF8 str = generateInfo Utf8Info { _tagCp = TagUtf8
                                         , _tamCp = length str
                                         , _cadCp = str
                                         , _desc  = ""
                                         }
