module WhileLoop.Steps where

import Lexer.Token

whileLoopTokens = [Lexer.Token.CLASS, 
                        Lexer.Token.IDENTIFIER "WhileLoop", 
                        Lexer.Token.LEFT_BRACE,
                        Lexer.Token.VOID,
                        Lexer.Token.IDENTIFIER "doLoop",
                        Lexer.Token.LEFT_PARANTHESES,
                        Lexer.Token.RIGHT_PARANTHESES,
                        Lexer.Token.LEFT_BRACE,
                        Lexer.Token.INTEGER,
                        Lexer.Token.IDENTIFIER "i",
                        Lexer.Token.ASSIGN,
                        Lexer.Token.INTEGER_LITERAL 0,
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.WHILE,
                        Lexer.Token.LEFT_PARANTHESES,
                        Lexer.Token.BOOLEAN_LITERAL True,
                        Lexer.Token.RIGHT_PARANTHESES,
                        Lexer.Token.LEFT_BRACE,
                        Lexer.Token.IDENTIFIER "i",
                        Lexer.Token.ASSIGN, 
                        Lexer.Token.IDENTIFIER "i",
                        Lexer.Token.ADD,
                        Lexer.Token.INTEGER_LITERAL 1,
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.RIGHT_BRACE,
                        Lexer.Token.RIGHT_BRACE,
                        Lexer.Token.RIGHT_BRACE
                       ]