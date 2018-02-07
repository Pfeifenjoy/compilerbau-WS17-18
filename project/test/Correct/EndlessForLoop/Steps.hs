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
                       (Block [For (Block []) (BooleanLiteral True) (Block []) (Block [])]) 
                       Public False
                     ]
                    ]

endlessForLoopTypedABS = [Class "EndlessForLoop" []
                          [MethodDecl "doStuff" "void" []
                            (TypedStmt (Block
                                [TypedStmt (For (TypedStmt (Block []) "void") (TypedExpr (BooleanLiteral True) "boolean") (TypedStmt (Block []) "void") 
                                  (TypedStmt (Block []) "void")) "void"]) "void") 
                            Public False
                          ]
                         ]
