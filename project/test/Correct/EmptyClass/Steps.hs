module  Correct.EmptyClass.Steps where

import           ABSTree
import           Lexer.Token

emptyTokens = [Lexer.Token.CLASS,
              Lexer.Token.IDENTIFIER "Test",
              Lexer.Token.LEFT_BRACE,
              Lexer.Token.RIGHT_BRACE
              ]

emptyABS = [Class "Test" [] []]
emptyTypedABS = [Class "Test" [] []]

