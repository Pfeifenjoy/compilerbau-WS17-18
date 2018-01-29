module Utils.ClassFileChecker where

import           ABSTree
import           Codegen.Data.ClassFormat

evalClassFile file expectedFile = do
                                  putStrLn ("CP-Counter: " ++ show ((_countrCp file) == (_countrCp expectedFile)))
                                  putStrLn (show (_arrayCp file))
                                  putStrLn (show (_arrayMethods file))





