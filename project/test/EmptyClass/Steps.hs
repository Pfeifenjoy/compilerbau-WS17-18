module EmptyClass.Steps where

import           Lexer.Token

emptyTokens = [Lexer.Token.CLASS,
              Lexer.Token.IDENTIFIER "Test",
              Lexer.Token.LEFT_BRACE,
              Lexer.Token.RIGHT_BRACE
              ]

