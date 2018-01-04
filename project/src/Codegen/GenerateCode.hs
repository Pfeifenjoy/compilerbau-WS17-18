module Codegen.GenerateCode (
) where
import ABSTree
import Codegen.BinaryClass
import Codegen.Data.ClassFormat
import Codegen.GenerateConstantPool
import Codegen.GenerateFields
import Codegen.GenerateMethods
import Data.HashMap.Lazy (fromList)
import Control.Lens

generateClass :: Class -> ClassFile 
generateClass (Class typ fds mds) 
  = generateMethods mds . flip generateFields fds $ cl''' 
    where
      startCl = ClassFile { _magic           = Magic
                          -- TODO which version?
                          , _minver          = MinorVersion 0
                          , _maxver          = MajorVersion 0
                          , _countrCp        = 0
                          , _arrayCp         = fromList []
                          , _acfg            = AccessFlags []
                          , _this            = ThisClass 0 
                          , _super           = SuperClass 0 
                          , _countInterfaces = 0 
                          , _arrayInterfaces = [] 
                          , _countFields     = 0 
                          , _arrayFields     = [] 
                          , _countMethods    = 0 
                          , _arrayMethods    = [] 
                          , _countAttributes = 0 
                          , _arrayAttributes = [] 
                          }
      -- TODO get names
      (cl',thisIndex)  = generateUTF8 startCl "This" 
      (cl'',superIndex) = generateUTF8 cl' "Super"
      cl''' = set this (ThisClass thisIndex) 
              $ set super (SuperClass superIndex) cl''
