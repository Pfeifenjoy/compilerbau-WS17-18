module ExampleProgramms.Fibonacci.Steps where

import           ABSTree
import           Lexer.Token

fibonacciTokens = [Lexer.Token.CLASS,
                   Lexer.Token.IDENTIFIER "Fibonacci",
                   Lexer.Token.LEFT_BRACE,
                   Lexer.Token.INTEGER,
                   Lexer.Token.IDENTIFIER "getFib",
                   Lexer.Token.LEFT_PARANTHESES,
                   Lexer.Token.INTEGER,
                   Lexer.Token.IDENTIFIER "n",
                   Lexer.Token.RIGHT_PARANTHESES,
                   Lexer.Token.LEFT_BRACE,
                   Lexer.Token.RETURN,
                   Lexer.Token.LEFT_PARANTHESES,
                   Lexer.Token.IDENTIFIER "n",
                   Lexer.Token.LESSER,
                   Lexer.Token.INTEGER_LITERAL 2,
                   Lexer.Token.RIGHT_PARANTHESES,
                   Lexer.Token.QUESTIONMARK,
                   Lexer.Token.IDENTIFIER "n",
                   Lexer.Token.COLON,
                   Lexer.Token.IDENTIFIER "getFib",
                   Lexer.Token.LEFT_PARANTHESES,
                   Lexer.Token.IDENTIFIER "n",
                   Lexer.Token.SUBTRACT,
                   Lexer.Token.INTEGER_LITERAL 1,
                   Lexer.Token.RIGHT_PARANTHESES,
                   Lexer.Token.ADD,
                   Lexer.Token.IDENTIFIER "getFib",
                   Lexer.Token.LEFT_PARANTHESES,
                   Lexer.Token.IDENTIFIER "n",
                   Lexer.Token.SUBTRACT,
                   Lexer.Token.INTEGER_LITERAL 2,
                   Lexer.Token.RIGHT_PARANTHESES,
                   Lexer.Token.SEMICOLON,
                   Lexer.Token.RIGHT_BRACE,
                   Lexer.Token.RIGHT_BRACE
                  ]

fibonacciABS = [Class "Fibonacci" [] 
                [MethodDecl "getFib" "int" [ArgumentDecl "n" "int" False] 
                     (Block [Return 
                       (Ternary (Binary "<" (LocalOrFieldVar "n") (IntegerLiteral 2)) 
                         (LocalOrFieldVar "n") 
                         (Binary "+" (StmtExprExpr (MethodCall This "getFib" [Binary "-" (LocalOrFieldVar "n") (IntegerLiteral 1)])) 
                             (StmtExprExpr (MethodCall This "getFib" [Binary "-" (LocalOrFieldVar "n") (IntegerLiteral 2)]))
                        ))
                     ]) 
                     Public False
                ]
               ]
               
fibonacciTypedABS = [Class "Fibonacci" [] 
                     [MethodDecl "getFib" "int" [ArgumentDecl "n" "int" False] 
                    (TypedStmt (Block [TypedStmt (Return 
                    	(TypedExpr (Ternary (TypedExpr (Binary "<" (TypedExpr (LocalOrFieldVar "n") "int") (TypedExpr (IntegerLiteral 2) "int")) "boolean") 
                    		(TypedExpr (LocalOrFieldVar "n") "int") 
                    		(TypedExpr (Binary "+" 
                    			(TypedExpr (StmtExprExpr (TypedStmtExpr (MethodCall (TypedExpr This "Fibonacci") "getFib" 
                    				[TypedExpr (Binary "-" (TypedExpr (LocalOrFieldVar "n") "int") (TypedExpr (IntegerLiteral 1) "int")) "int"]
                    			) "int")) "int") 
                    			(TypedExpr (StmtExprExpr (TypedStmtExpr (MethodCall (TypedExpr This "Fibonacci") "getFib" 
                    				[TypedExpr (Binary "-" (TypedExpr (LocalOrFieldVar "n") "int") (TypedExpr (IntegerLiteral 2) "int")) "int"]) 
                    			"int")) "int")) "int")) "int")) "int"]) "int") 
                     Public False
                     ]
                    ]









