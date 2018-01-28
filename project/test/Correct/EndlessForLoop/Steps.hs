module  Correct.EndlessForLoop.Steps where

import           ABSTree
import           Lexer.Token

endlessForLoopTokens = [Lexer.Token.CLASS,
                        Lexer.Token.IDENTIFIER "EndlessForLoop",
                        Lexer.Token.LEFT_BRACE,
                        Lexer.Token.VOID,
                        Lexer.Token.IDENTIFIER "doStuff",
                        Lexer.Token.LEFT_PARANTHESES,
                        Lexer.Token.RIGHT_PARANTHESES,
                        Lexer.Token.LEFT_BRACE,
                        Lexer.Token.FOR,
                        Lexer.Token.LEFT_PARANTHESES,
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.RIGHT_PARANTHESES,
                        Lexer.Token.LEFT_BRACE,
                        Lexer.Token.RIGHT_BRACE,
                        Lexer.Token.RIGHT_BRACE,
                        Lexer.Token.RIGHT_BRACE
                       ]

endlessForLoopABS = [Class "EndlessForLoop" []
                     [MethodDecl "doStuff" "void" []
                       (Block [While (BooleanLiteral True) (Block [])])
                       Public False]
                    ]

endlessForLoopTypedABS = [Class "EndlessForLoop" []
                          [MethodDecl "doStuff" "void" []
                            (TypedStmt (Block
                                [TypedStmt (While (TypedExpr (BooleanLiteral True) "boolean") (TypedStmt (Block []) "void")) "void"]
                            ) "void")
                            Public False]
                         ]
