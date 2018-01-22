module  Correct.LogicOperations2.Steps where

import           ABSTree
import           Lexer.Token

logicOperations2Tokens = [Lexer.Token.CLASS,
                          Lexer.Token.IDENTIFIER "LogicOperations2",
                          Lexer.Token.LEFT_BRACE,
                          Lexer.Token.VOID,
                          Lexer.Token.IDENTIFIER "doStuff",
                          Lexer.Token.LEFT_PARANTHESES,
                          Lexer.Token.RIGHT_PARANTHESES,
                          Lexer.Token.LEFT_BRACE,
                          Lexer.Token.BOOLEAN,
                          Lexer.Token.IDENTIFIER "i",
                          Lexer.Token.ASSIGN,
                          Lexer.Token.LEFT_PARANTHESES,
                          Lexer.Token.INTEGER_LITERAL 1,
                          Lexer.Token.LESSER_EQUAL,
                          Lexer.Token.INTEGER_LITERAL 3,
                          Lexer.Token.RIGHT_PARANTHESES,
                          Lexer.Token.AND,
                          Lexer.Token.LEFT_PARANTHESES,
                          Lexer.Token.INTEGER_LITERAL 3,
                          Lexer.Token.GREATER_EQUAL,
                          Lexer.Token.INTEGER_LITERAL 2,
                          Lexer.Token.RIGHT_PARANTHESES,
                          Lexer.Token.OR,
                          Lexer.Token.LEFT_PARANTHESES,
                          Lexer.Token.INTEGER_LITERAL 3,
                          Lexer.Token.GREATER,
                          Lexer.Token.INTEGER_LITERAL 1,
                          Lexer.Token.RIGHT_PARANTHESES,
                          Lexer.Token.SEMICOLON,
                          Lexer.Token.RIGHT_BRACE,
                          Lexer.Token.RIGHT_BRACE
                         ]
