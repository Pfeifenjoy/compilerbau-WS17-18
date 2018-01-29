module  Correct.NewClass.Steps where

import           ABSTree
import           Lexer.Token

newClassTokens = [Lexer.Token.CLASS,
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
                  Lexer.Token.INTEGER,
                  Lexer.Token.IDENTIFIER "b",
                  Lexer.Token.ASSIGN,
                  Lexer.Token.IDENTIFIER "a",
                  Lexer.Token.DOT,
                  Lexer.Token.IDENTIFIER "a",
                  Lexer.Token.SEMICOLON,
                  Lexer.Token.IDENTIFIER "A",
                  Lexer.Token.IDENTIFIER "c",
                  Lexer.Token.ASSIGN,
                  Lexer.Token.JNULL,
                  Lexer.Token.SEMICOLON,
                  Lexer.Token.RIGHT_BRACE,
                  Lexer.Token.RIGHT_BRACE
                 ]

newClassABS = [Class "A" [FieldDecl [VariableDecl "a" "int" False Nothing] Public False] [],
               Class "B" [] [MethodDecl "doStuff" "void" []
                                 (Block [LocalVarDecls [VariableDecl "a" "A" False (Just (StmtExprExpr (New "A" [])))],
                                         LocalVarDecls [VariableDecl "b" "int" False (Just (InstVar (LocalOrFieldVar "a") "a"))],
                                         LocalVarDecls [VariableDecl "c" "A" False (Just JNull)]
                                 ]) Public False
                            ]
              ]


newClassTypedABS = [Class "A" [FieldDecl [VariableDecl "a" "int" False Nothing] Public False] [],
               Class "B" [] [MethodDecl "doStuff" "void" []
                                 (TypedStmt (Block [TypedStmt (LocalVarDecls [VariableDecl "a" "A" False (Just (TypedExpr (StmtExprExpr (TypedStmtExpr (New "A" []) "A")) "A"))]) "void",
                                         TypedStmt (LocalVarDecls [VariableDecl "b" "int" False (Just (TypedExpr (InstVar (TypedExpr (LocalOrFieldVar "a") "A") "a") "int"))]) "void",
                                         TypedStmt (LocalVarDecls [VariableDecl "c" "A" False (Just (TypedExpr JNull "void"))]) "void"
                                 ]) "void") Public False
                            ]
              ]



