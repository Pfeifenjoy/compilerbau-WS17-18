module  Correct.ClassMethods.Steps where

import           ABSTree
import           Lexer.Token

classMethodTokens = [Lexer.Token.CLASS,
                    Lexer.Token.IDENTIFIER "ClassMethod",
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.INTEGER,
                    Lexer.Token.IDENTIFIER "i",
                    Lexer.Token.ASSIGN,
                    Lexer.Token.INTEGER_LITERAL 0,
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.INTEGER,
                    Lexer.Token.IDENTIFIER "getInt",
                    Lexer.Token.LEFT_PARANTHESES,
                    Lexer.Token.RIGHT_PARANTHESES,
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.RETURN,
                    Lexer.Token.INTEGER_LITERAL 1,
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.RIGHT_BRACE,
                    Lexer.Token.PUBLIC,
                    Lexer.Token.STATIC,
                    Lexer.Token.INTEGER,
                    Lexer.Token.IDENTIFIER "returnInt",
                    Lexer.Token.LEFT_PARANTHESES,
                    Lexer.Token.INTEGER,
                    Lexer.Token.IDENTIFIER "x",
                    Lexer.Token.RIGHT_PARANTHESES,
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.RETURN,
                    Lexer.Token.IDENTIFIER "x",
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.RIGHT_BRACE,
                    Lexer.Token.PRIVATE,
                    Lexer.Token.INTEGER,
                    Lexer.Token.IDENTIFIER "doStuff",
                    Lexer.Token.LEFT_PARANTHESES,
                    Lexer.Token.RIGHT_PARANTHESES,
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.RETURN,
                    Lexer.Token.THIS,
                    Lexer.Token.DOT,
                    Lexer.Token.IDENTIFIER "i",
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.RIGHT_BRACE,
                    Lexer.Token.RIGHT_BRACE
                   ]


classMethodsABS = [Class "ClassMethod"
                   [FieldDecl [VariableDecl "i" "int" False (Just (IntegerLiteral 0))] Public False]
                   [MethodDecl "getInt" "int" []
                       (Block [Return (IntegerLiteral 1)]) Public False,
                    MethodDecl "returnInt" "int" [ArgumentDecl "x" "int" False]
                        (Block [Return (LocalOrFieldVar "x")]) Public True,
                    MethodDecl "doStuff" "int" []
                        (Block [Return (InstVar This "i")]) Private False
                   ]
                  ]

classMethodsTypedABS = [Class "ClassMethod"
                   [FieldDecl [VariableDecl "i" "int" False (Just (TypedExpr (IntegerLiteral 0) "int"))] Public False]
                   [MethodDecl "getInt" "int" []
                       (TypedStmt (Block [TypedStmt (Return (TypedExpr (IntegerLiteral 1) "int")) "int"]) "int") Public False,
                    MethodDecl "returnInt" "int" [ArgumentDecl "x" "int" False]
                        (TypedStmt (Block [TypedStmt (Return (TypedExpr (LocalOrFieldVar "x") "int")) "int"]) "int") Public True,
                    MethodDecl "doStuff" "int" []
                        (TypedStmt (Block [TypedStmt (Return (TypedExpr (InstVar (TypedExpr This "ClassMethod") "i") "int")) "int"]) "int") Private False
                   ]
                  ]
