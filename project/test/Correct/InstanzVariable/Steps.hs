module  Correct.InstanzVariable.Steps where

import           ABSTree
import           Lexer.Token

instanzVariableTokens = [Lexer.Token.CLASS,
                        Lexer.Token.IDENTIFIER "InstanzVariable",
                        Lexer.Token.LEFT_BRACE,
                        Lexer.Token.INTEGER,
                        Lexer.Token.IDENTIFIER "i",
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.BOOLEAN,
                        Lexer.Token.IDENTIFIER "b",
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.FINAL,
                        Lexer.Token.CHARACTER,
                        Lexer.Token.IDENTIFIER "c",
                        Lexer.Token.ASSIGN,
                        Lexer.Token.CHARACTER_LITERAL 'a',
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.RIGHT_BRACE]

instanzVariableABS :: [Class]
instanzVariableABS = [Class "InstanzVariable"
                      [FieldDecl [VariableDecl "i" "int" False Nothing] Public False,
                       FieldDecl [VariableDecl "b" "boolean" False Nothing] Public False,
                       FieldDecl [VariableDecl "c" "char" True (Just (CharLiteral 'a'))] Public False
                      ]
                      []]

instanzVariableTypedABS = [Class "InstanzVariable"
                      [FieldDecl [VariableDecl "i" "int" False Nothing] Public False,
                       FieldDecl [VariableDecl "b" "boolean" False Nothing] Public False,
                       FieldDecl [VariableDecl "c" "char" True (Just (TypedExpr (CharLiteral 'a') "char"))] Public False
                      ]
                      []]
