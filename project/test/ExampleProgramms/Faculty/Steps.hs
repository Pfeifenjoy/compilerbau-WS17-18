module ExampleProgramms.Faculty.Steps where

import           ABSTree
import           Lexer.Token

facultyTokens = [Lexer.Token.CLASS,
                 Lexer.Token.IDENTIFIER "Faculty",
                 Lexer.Token.LEFT_BRACE,
                 Lexer.Token.INTEGER,
                 Lexer.Token.IDENTIFIER "fac",
                 Lexer.Token.LEFT_PARANTHESES,
                 Lexer.Token.INTEGER,
                 Lexer.Token.IDENTIFIER "n",
                 Lexer.Token.RIGHT_PARANTHESES,
                 Lexer.Token.LEFT_BRACE,
                 Lexer.Token.RETURN,
                 Lexer.Token.LEFT_PARANTHESES,
                 Lexer.Token.IDENTIFIER "n",
                 Lexer.Token.LESSER,
                 Lexer.Token.INTEGER_LITERAL 3,
                 Lexer.Token.RIGHT_PARANTHESES,
                 Lexer.Token.QUESTIONMARK,
                 Lexer.Token.IDENTIFIER "n",
                 Lexer.Token.COLON,
                 Lexer.Token.IDENTIFIER "n",
                 Lexer.Token.MULTIPLY,
                 Lexer.Token.IDENTIFIER "fac",
                 Lexer.Token.LEFT_PARANTHESES,
                 Lexer.Token.IDENTIFIER "n",
                 Lexer.Token.SUBTRACT,
                 Lexer.Token.INTEGER_LITERAL 1,
                 Lexer.Token.RIGHT_PARANTHESES,
                 Lexer.Token.SEMICOLON,
                 Lexer.Token.RIGHT_BRACE,
                 Lexer.Token.RIGHT_BRACE
                ]

facultyABS = [Class "Faculty" [] 
              [MethodDecl "fac" "int" [ArgumentDecl "n" "int" False] 
                  (Block [Return 
                    (Ternary (Binary "<" (LocalOrFieldVar "n") (IntegerLiteral 3)) 
                      (LocalOrFieldVar "n") (Binary "*" (LocalOrFieldVar "n") 
                      (StmtExprExpr (MethodCall This "fac" [Binary "-" (LocalOrFieldVar "n") (IntegerLiteral 1)]))))
                   ]) 
                  Public False
               ]
              ]

facultyTypedABS = [Class "Faculty" [] 
                   [MethodDecl "fac" "int" [ArgumentDecl "n" "int" False] 
                     (TypedStmt (Block [TypedStmt (Return 
                        (TypedExpr (Ternary (TypedExpr (Binary "<" (TypedExpr (LocalOrFieldVar "n") "int") (TypedExpr (IntegerLiteral 3) "int")) "boolean") 
                             (TypedExpr (LocalOrFieldVar "n") "int") (TypedExpr (Binary "*" (TypedExpr (LocalOrFieldVar "n") "int") 
                                (TypedExpr (StmtExprExpr (TypedStmtExpr 
                                (MethodCall (TypedExpr This "Faculty") "fac" [TypedExpr (Binary "-" (TypedExpr (LocalOrFieldVar "n") "int") (TypedExpr (IntegerLiteral 1) "int")) "int"]) 
                        "int")) "int")) "int")) "int")) "int"
                     ]) "int") 
                     Public False
                    ]
                   ]













