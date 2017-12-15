module ClassMethods.Steps where

import Lexer.Token

classMethodTokens = [Lexer.Token.CLASS, 
                    Lexer.Token.IDENTIFIER "ClassMethod",
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.INTEGER,
                    Lexer.Token.IDENTIFIER "i",
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.INTEGER,
                    Lexer.Token.IDENTIFIER "getInt",
                    Lexer.Token.LEFT_PARANTHESES,
                    Lexer.Token.RIGHT_PARANTHESES,
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.RETURN,
                    Lexer.Token.INTEGER_LITERAL 1,
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.RIGHT_BRACE,
                    Lexer.Token.INTEGER,
                    Lexer.Token.IDENTIFIER "returnInt",
                    Lexer.Token.LEFT_PARANTHESES,
                    Lexer.Token.INTEGER,
                    Lexer.Token.IDENTIFIER "x",
                    Lexer.Token.RIGHT_PARANTHESES,
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.RETURN,
                    Lexer.Token.IDENTIFIER "x",
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.RIGHT_BRACE,
                    Lexer.Token.INTEGER,
                    Lexer.Token.IDENTIFIER "doStuff",
                    Lexer.Token.LEFT_PARANTHESES,
                    Lexer.Token.RIGHT_PARANTHESES,
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.RETURN,
                    Lexer.Token.IDENTIFIER "i",
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.RIGHT_BRACE,
                    Lexer.Token.RIGHT_BRACE
                   ]


