module Codegen.GenerateClassFile (
  genClass
) where
import ABSTree(Class(..),MethodDecl(..))
import Codegen.Data.ClassFormat
import qualified Codegen.GenerateConstantPool as CP
import Codegen.GenerateFields(genFields)
import Codegen.GenerateMethods
import Data.HashMap.Lazy (fromList)
import Control.Monad.Trans.State.Lazy
import Control.Lens

genClass :: Class -> ClassFile
genClass (Class typ fds mds)
  = execState
      -- TODO get name Super
     (do thisIndex <- CP.genClass typ
         superIndex <- CP.genClass "object"
         modify $ set this (ThisClass thisIndex)
         modify $ set super (SuperClass superIndex)
         genFields (existsConstructor mds) fds
         genMethods fds mds)
      ClassFile { _magic           = Magic
                -- TODO which version?
                , _minver          = MinorVersion 0
                , _maxver          = MajorVersion 0
                , _countrCp        = 1
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

-- | checks if a constructor exists, that has no arguments
existsConstructor :: [MethodDecl] -> Bool
existsConstructor [] = False
existsConstructor (MethodDecl _ "" [] _ _ _:_) = True
existsConstructor (_:mds) = existsConstructor mds
