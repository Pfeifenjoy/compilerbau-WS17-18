module Arithmetic.Steps where

import Lexer.Token

arithmeticTokens = [Lexer.Token.CLASS, 
                        Lexer.Token.IDENTIFIER "Arithmetic", 
                        Lexer.Token.LEFT_BRACE,
                        Lexer.Token.INTEGER,
                        Lexer.Token.IDENTIFIER "i",
                        Lexer.Token.ASSIGN,
                        Lexer.Token.INTEGER_LITERAL 5,
                        Lexer.Token.ADD,
                        Lexer.Token.INTEGER_LITERAL 3,
                        Lexer.Token.MULTIPLY,
                        Lexer.Token.INTEGER_LITERAL 2,
                        Lexer.Token.SUBTRACT,
                        Lexer.Token.INTEGER_LITERAL 1,
                        Lexer.Token.MODULO,
                        Lexer.Token.INTEGER_LITERAL 3,
                        Lexer.Token.DIVIDE,
                        Lexer.Token.INTEGER_LITERAL 1,
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.IDENTIFIER "i",
                        Lexer.Token.INCREMENT, 
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.IDENTIFIER "i",
                        Lexer.Token.DECREMENT,
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.RIGHT_BRACE
                       ]