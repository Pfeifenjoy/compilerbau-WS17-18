module WhileLoopCondition.Steps where

import           ABSTree
import           Lexer.Token

whileLoopConditionTokens = [Lexer.Token.CLASS,
                        Lexer.Token.IDENTIFIER "WhileLoopCondition",
                        Lexer.Token.LEFT_BRACE,
                        Lexer.Token.VOID,
                        Lexer.Token.IDENTIFIER "doLoop",
                        Lexer.Token.LEFT_PARANTHESES,
                        Lexer.Token.RIGHT_PARANTHESES,
                        Lexer.Token.LEFT_BRACE,
                        Lexer.Token.INTEGER,
                        Lexer.Token.IDENTIFIER "i",
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.IDENTIFIER "i",
                        Lexer.Token.ASSIGN,
                        Lexer.Token.INTEGER_LITERAL 5,
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.WHILE,
                        Lexer.Token.LEFT_PARANTHESES,
                        Lexer.Token.IDENTIFIER "i",
                        Lexer.Token.GREATER_EQUAL,
                        Lexer.Token.INTEGER_LITERAL 5,
                        Lexer.Token.RIGHT_PARANTHESES,
                        Lexer.Token.LEFT_BRACE,
                        Lexer.Token.IDENTIFIER "i",
                        Lexer.Token.ASSIGN,
                        Lexer.Token.IDENTIFIER "i",
                        Lexer.Token.SUBTRACT,
                        Lexer.Token.INTEGER_LITERAL 1,
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.RIGHT_BRACE,
                        Lexer.Token.RIGHT_BRACE,
                        Lexer.Token.RIGHT_BRACE
                       ]

whileLoopConditionABS = [Class "WhileLoopCondition" []
                         [MethodDecl "doLoop" "void" []
                             (Block [LocalVarDecls [VariableDecl "i" "int" False Nothing],
                                     StmtExprStmt (Assign (LocalOrFieldVar "i") (IntegerLiteral 5)),
                                     While (Binary ">=" (LocalOrFieldVar "i") (IntegerLiteral 5))
                                         (Block [StmtExprStmt (Assign (LocalOrFieldVar "i") (Binary "-" (LocalOrFieldVar "i") (IntegerLiteral 1)))])
                                    ]) Public False
                         ]
                        ]
