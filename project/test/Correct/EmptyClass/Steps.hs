module  Correct.EmptyClass.Steps where

import           ABSTree
import           Codegen.Data.ClassFormat
import           Data.HashMap.Lazy        (fromList)
import           Lexer.Token

emptyTokens = [Lexer.Token.CLASS,
              Lexer.Token.IDENTIFIER "Test",
              Lexer.Token.LEFT_BRACE,
              Lexer.Token.RIGHT_BRACE
              ]

emptyABS = [Class "Test" [] []]
emptyTypedABS = [Class "Test" [] []]

emptyClassFile = ClassFile Magic (MinorVersion 0) (MajorVersion 0) 0 (fromList []) (AccessFlags []) (ThisClass 0) (SuperClass 0) 0 [] 0 [] 0 [] 0 []

