module  Correct.WhileLoop.Steps where

import           ABSTree
import           Lexer.Token

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

whileLoopABS = [Class "WhileLoop" []
                [MethodDecl "doLoop" "void" []
                    (Block [LocalVarDecls [VariableDecl "i" "int" False (Just (IntegerLiteral 0))],
                            While (BooleanLiteral True)
                                (Block [StmtExprStmt (Assign (LocalOrFieldVar "i") (Binary "+" (LocalOrFieldVar "i") (IntegerLiteral 1)))])
                            ]
                     ) Public False]
               ]

