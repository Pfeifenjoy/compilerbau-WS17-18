module  Correct.MethodCall.Steps where

import           ABSTree
import           Lexer.Token

methodCallTokens :: [Token]
methodCallTokens = [Lexer.Token.CLASS,
                    Lexer.Token.IDENTIFIER "B",
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.INTEGER,
                    Lexer.Token.IDENTIFIER "getInt",
                    Lexer.Token.LEFT_PARANTHESES,
                    Lexer.Token.RIGHT_PARANTHESES,
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.RETURN,
                    Lexer.Token.INTEGER_LITERAL 1,
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.RIGHT_BRACE,
                    Lexer.Token.RIGHT_BRACE,
                    Lexer.Token.CLASS,
                    Lexer.Token.IDENTIFIER "MethodCall",
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.INTEGER,
                    Lexer.Token.IDENTIFIER "getInt",
                    Lexer.Token.LEFT_PARANTHESES,
                    Lexer.Token.RIGHT_PARANTHESES,
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.IDENTIFIER "B",
                    Lexer.Token.IDENTIFIER "b",
                    Lexer.Token.ASSIGN,
                    Lexer.Token.NEW,
                    Lexer.Token.IDENTIFIER "B",
                    Lexer.Token.LEFT_PARANTHESES,
                    Lexer.Token.RIGHT_PARANTHESES,
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.RETURN,
                    Lexer.Token.IDENTIFIER "b",
                    Lexer.Token.DOT,
                    Lexer.Token.IDENTIFIER "getInt",
                    Lexer.Token.LEFT_PARANTHESES,
                    Lexer.Token.RIGHT_PARANTHESES,
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.RIGHT_BRACE,
                    Lexer.Token.RIGHT_BRACE
                   ]

methodCallABS :: [Class]
methodCallABS = [Class "B" []
                 [MethodDecl "getInt" "int" []
                     (Block [Return (IntegerLiteral 1)
                    ]) Public False
                 ],
                  Class "MethodCall" []
                   [MethodDecl "getInt" "int" []
                     (Block [LocalVarDecls [VariableDecl "b" "B" False (Just (StmtExprExpr (New "B" [])))],
                             Return (StmtExprExpr (MethodCall (LocalOrFieldVar "b") "getInt" []))
                    ]) Public False
                    ]
                ]

methodCallTypedABS :: [Class]
methodCallTypedABS = [Class "B" []
                 [MethodDecl "getInt" "int" []
                     (TypedStmt (Block [TypedStmt (Return (TypedExpr (IntegerLiteral 1) "int")) "int"
                    ]) "int") Public False
                 ],
                  Class "MethodCall" []
                   [MethodDecl "getInt" "int" []
                     (TypedStmt (Block [TypedStmt (LocalVarDecls [VariableDecl "b" "B" False (Just (TypedExpr (StmtExprExpr (TypedStmtExpr (New "B" []) "B")) "B"))]) "void",
                             TypedStmt (Return (TypedExpr (StmtExprExpr (TypedStmtExpr (MethodCall (TypedExpr (LocalOrFieldVar "b") "B") "getInt" []) "int")) "int")) "int"
                    ]) "int") Public False
                    ]
                ]




