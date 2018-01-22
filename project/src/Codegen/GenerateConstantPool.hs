{-|
This module contains functions which insert different constants in the
constant pool.  The functions give back the index of the inserted
constant in the constant pool.  If a constant is already in the constant
pool, they only give back the index, without inserting a new constant.
-}
module Codegen.GenerateConstantPool(
  genClass,
  genFieldRef,
  genFieldRefThis,
  genMethodRef,
  genInterfaceRef,
  genString,
  genInteger,
  genFloat,
  genLong,
  genDouble,
  genNameAndType,
  genUTF8
) where
import Codegen.Data.ClassFormat
import ABSTree
import Control.Lens
import Control.Monad.Trans.State.Lazy
import Control.Arrow
import Prelude hiding ((!))
import qualified Data.HashMap.Lazy as HM
import Data.HashMap.Lazy ((!))


-- | insert a class in the constant pool
genClass :: String -- ^ class to insert in constant pool
         -> State ClassFile -- ^ new constant pool
                  IndexConstantPool -- ^ location of field in constant pool
genClass name =
  do index <- genUTF8 name
     genInfo ClassInfo { _tagCp   = TagClass
                       , _indexCp = index
                       , _desc    = ""
                       }



-- | insert a field variable in the constant pool
genFieldRef :: String -- ^ field to insert in constant pool
            -> String -- ^ class in which this field is
            -> Type -- ^ type of this Field
            -> State ClassFile -- ^ new constant pool
                     IndexConstantPool -- ^ location of field in constant pool
genFieldRef name className typ =
  do indexClassName <- genClass className
     indexNameType <- genNameAndType name typ
     genInfo FieldRefInfo { _tagCp              = TagFieldRef
                          , _indexNameCp        = indexClassName
                          , _indexNameandtypeCp = indexNameType
                          , _desc               = ""
                          }

-- | insert a field variable of this class in the constant pool
genFieldRefThis :: String -- ^ field to insert in constant pool
                -> Type -- ^ type of this Field
                -> State ClassFile -- ^ new constant pool
                         -- | location of field in constant pool
                         IndexConstantPool
genFieldRefThis name typ =
  do indexClassName <- view (this . indexTh) <$> get
     indexNameType <- genNameAndType name typ
     genInfo FieldRefInfo { _tagCp              = TagFieldRef
                          , _indexNameCp        = indexClassName
                          , _indexNameandtypeCp = indexNameType
                          , _desc               = ""
                          }

-- | insert a method in the constant pool
genMethodRef :: String-- ^ name of method to insert in constant pool
             -> String -- ^ class in which this method is
             -> Type -- ^ type of this method
             -> State ClassFile -- ^ new constant pool
                      IndexConstantPool -- ^ location of field in constant pool
genMethodRef name className typ =
  do indexClassName <- genClass className
     indexNameType <- genNameAndType name typ
     genInfo MethodRefInfo { _tagCp              = TagMethodRef
                           , _indexNameCp        = indexClassName
                           , _indexNameandtypeCp = indexNameType
                           , _desc               = ""
                           }

-- | insert a interface in the constant pool
genInterfaceRef = undefined

-- | insert a string in the constant pool
genString = undefined

-- | inserts a integer in the constant pool
genInteger :: Int -- ^ Int to insert in the constant pool
           -> State ClassFile -- ^ new constant pool
                    IndexConstantPool -- ^ location of int in constant pool
genInteger int = genInfo IntegerInfo { _tagCp  = TagInteger
                                     , _numiCp = int
                                     , _desc   = ""
                                     }

-- | insert a float in the constant pool
genFloat :: Float -- ^ Float to insert in the constant pool
         -> State ClassFile -- ^ new constant pool
                  IndexConstantPool -- ^ location of int in constant pool
genFloat float = genInfo FloatInfo { _tagCp  = TagFloat
                                   , _numfCp = float
                                   , _desc   = ""
                                   }

-- | insert a long in the constant pool
genLong :: (Int,Int) -- ^ Long to insert in the constant pool
        -> State ClassFile -- ^ new constant pool
                 IndexConstantPool -- ^ location of int in constant pool
genLong (int1,int2) = genInfo LongInfo { _tagCp    = TagLong
                                       , _numiL1Cp = int1
                                       , _numiL2Cp = int2
                                       , _desc     = ""
                                       }

-- | insert a double in the constant pool
genDouble :: (Int,Int) -- ^ Double to insert in the constant pool
          -> State ClassFile -- ^ new constant pool
                   IndexConstantPool -- ^ location of int in constant pool
genDouble (int1,int2) = genInfo DoubleInfo { _tagCp    = TagDouble
                                           , _numiD1Cp = int1
                                           , _numiD2Cp = int2
                                           , _desc     = ""
                                           }

-- | insert name and type
genNameAndType :: String -- ^ name to insert in constant pool
               -> Type -- ^ type to insert in constant pool
               -> State ClassFile -- ^ new constant pool
                        IndexConstantPool -- ^ location of int in constant pool
genNameAndType name typ =
  do indexName <- genUTF8 name
     indexType <- genUTF8 typ
     genInfo NameAndTypeInfo { _tagCp       = TagNameAndType
                             , _indexNameCp = indexName
                             , _indexTypeCp = indexType
                             , _desc        = ""
                             }


-- | inserts a utf8 in the constant pool
genUTF8 :: String -- ^ string to insert in the constant pool
        -> State ClassFile -- ^ new constant pool
                 IndexConstantPool -- ^ location of String in constant pool
genUTF8 str = genInfo Utf8Info { _tagCp = TagUtf8
                               , _tamCp = length str
                               , _cadCp = str
                               , _desc  = ""
                               }

-- helper

-- | inserts a info into the constant pool
genInfo :: CPInfo
        -> State ClassFile -- ^ new constant pool
                 IndexConstantPool -- ^ location of info in the constant pool
genInfo cpInfo =
  do modify $
       \cf -> over arrayCp
                (\hm -> case HM.lookup cpInfo hm of
                         (Just _) -> hm
                         _        -> HM.insert cpInfo
                                               (cf^.countrCp+1) hm) cf
     cf <- get
     let loc = (cf^.arrayCp) ! cpInfo
         n   = if loc > cf^.countrCp then 1 else 0
     put $ countrCp +~ n $ cf
     return loc
