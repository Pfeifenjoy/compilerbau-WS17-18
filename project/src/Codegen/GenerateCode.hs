module Codegen.GenerateCode (
) where
import ABSTree
import Codegen.BinaryClass
import Codegen.Data.ClassFormat
import Codegen.GenerateConstantPool
import Codegen.GenerateFields
import Codegen.GenerateMethods
import Data.HashMap.Lazy (fromList)
import Control.Monad.Trans.State.Lazy
import Control.Lens

genClass :: Class -> ClassFile
genClass (Class typ fds mds)
  = execState
      -- TODO get name Super
     (do thisIndex <- genUTF8 typ
         superIndex <- genUTF8 "Super"
         modify $ set this (ThisClass thisIndex)
         modify $ set super (SuperClass superIndex)
         genFields fds
         genMethods mds)
      ClassFile { _magic           = Magic
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
