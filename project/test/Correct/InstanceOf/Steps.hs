module  Correct.InstanceOf.Steps where

import           ABSTree
import           Lexer.Token


instanceOfTokens = [Lexer.Token.CLASS,
                    Lexer.Token.IDENTIFIER "A",
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.INTEGER,
                    Lexer.Token.IDENTIFIER "a",
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.RIGHT_BRACE,
                    Lexer.Token.CLASS,
                    Lexer.Token.IDENTIFIER "B",
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.VOID,
                    Lexer.Token.IDENTIFIER "doStuff",
                    Lexer.Token.LEFT_PARANTHESES,
                    Lexer.Token.RIGHT_PARANTHESES,
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.IDENTIFIER "A",
                    Lexer.Token.IDENTIFIER "a",
                    Lexer.Token.ASSIGN,
                    Lexer.Token.NEW,
                    Lexer.Token.IDENTIFIER "A",
                    Lexer.Token.LEFT_PARANTHESES,
                    Lexer.Token.RIGHT_PARANTHESES,
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.BOOLEAN,
                    Lexer.Token.IDENTIFIER "b",
                    Lexer.Token.ASSIGN,
                    Lexer.Token.IDENTIFIER "a",
                    Lexer.Token.INSTANCEOF,
                    Lexer.Token.IDENTIFIER "A",
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.RIGHT_BRACE,
                    Lexer.Token.RIGHT_BRACE
                   ]

instanceOfABS = [Class "A" [FieldDecl [VariableDecl "a" "int" False Nothing] Public False]
                 [],
                 Class "B" []
                     [MethodDecl "doStuff" "void" []
                         (Block [LocalVarDecls [VariableDecl "a" "A" False (Just (StmtExprExpr (New "A" [])))],
                                 LocalVarDecls [VariableDecl "b" "boolean" False (Just (InstanceOf (LocalOrFieldVar "a") "A"))]
                         ]) Public False
                    ]
                ]

instanceOfTypedABS = [Class "A" [FieldDecl [VariableDecl "a" "int" False Nothing] Public False]
                 [],
                 Class "B" []
                     [MethodDecl "doStuff" "void" []
                         (TypedStmt (Block [LocalVarDecls [VariableDecl "a" "A" False (Just (TypedExpr (StmtExprExpr (TypedStmtExpr (New "A" []) "A")) "A"))],
                                 LocalVarDecls [VariableDecl "b" "boolean" False (Just (TypedExpr (InstanceOf (TypedExpr (LocalOrFieldVar "a") "A") "A") "boolean"))]
                         ]) "void") Public False
                    ]
                ]
