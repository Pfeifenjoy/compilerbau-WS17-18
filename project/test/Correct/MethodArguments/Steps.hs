module  Correct.MethodArguments.Steps where

import           ABSTree
import           Lexer.Token

methodArgumentsTokens = [Lexer.Token.CLASS,
                         Lexer.Token.IDENTIFIER "A",
                         Lexer.Token.LEFT_BRACE,
                         Lexer.Token.INTEGER,
                         Lexer.Token.IDENTIFIER "a",
                         Lexer.Token.SEMICOLON,
                         Lexer.Token.PUBLIC,
                         Lexer.Token.IDENTIFIER "A",
                         Lexer.Token.LEFT_PARANTHESES,
                         Lexer.Token.INTEGER,
                         Lexer.Token.IDENTIFIER "a",
                         Lexer.Token.RIGHT_PARANTHESES,
                         Lexer.Token.LEFT_BRACE,
                         Lexer.Token.THIS,
                         Lexer.Token.DOT,
                         Lexer.Token.IDENTIFIER "a",
                         Lexer.Token.ASSIGN,
                         Lexer.Token.IDENTIFIER "a",
                         Lexer.Token.SEMICOLON,
                         Lexer.Token.RIGHT_BRACE,
                         Lexer.Token.INTEGER,
                         Lexer.Token.IDENTIFIER "multiply",
                         Lexer.Token.LEFT_PARANTHESES,
                         Lexer.Token.INTEGER,
                         Lexer.Token.IDENTIFIER "b",
                         Lexer.Token.COMMA,
                         Lexer.Token.INTEGER,
                         Lexer.Token.IDENTIFIER "c",
                         Lexer.Token.RIGHT_PARANTHESES,
                         Lexer.Token.LEFT_BRACE,
                         Lexer.Token.RETURN,
                         Lexer.Token.LEFT_PARANTHESES,
                         Lexer.Token.THIS,
                         Lexer.Token.DOT,
                         Lexer.Token.IDENTIFIER "a",
                         Lexer.Token.MULTIPLY,
                         Lexer.Token.IDENTIFIER "b",
                         Lexer.Token.MULTIPLY,
                         Lexer.Token.IDENTIFIER "c",
                         Lexer.Token.RIGHT_PARANTHESES,
                         Lexer.Token.SEMICOLON,
                         Lexer.Token.RIGHT_BRACE,
                         Lexer.Token.RIGHT_BRACE,
                         Lexer.Token.CLASS,
                         Lexer.Token.IDENTIFIER "B",
                         Lexer.Token.LEFT_BRACE,
                         Lexer.Token.INTEGER,
                         Lexer.Token.IDENTIFIER "call",
                         Lexer.Token.LEFT_PARANTHESES,
                         Lexer.Token.RIGHT_PARANTHESES,
                         Lexer.Token.LEFT_BRACE,
                         Lexer.Token.IDENTIFIER "A",
                         Lexer.Token.IDENTIFIER "a",
                         Lexer.Token.ASSIGN,
                         Lexer.Token.NEW,
                         Lexer.Token.IDENTIFIER "A",
                         Lexer.Token.LEFT_PARANTHESES,
                         Lexer.Token.INTEGER_LITERAL 5,
                         Lexer.Token.RIGHT_PARANTHESES,
                         Lexer.Token.SEMICOLON,
                         Lexer.Token.RETURN,
                         Lexer.Token.IDENTIFIER "a",
                         Lexer.Token.DOT,
                         Lexer.Token.IDENTIFIER "multiply",
                         Lexer.Token.LEFT_PARANTHESES,
                         Lexer.Token.INTEGER_LITERAL 3,
                         Lexer.Token.COMMA,
                         Lexer.Token.INTEGER_LITERAL 2,
                         Lexer.Token.RIGHT_PARANTHESES,
                         Lexer.Token.SEMICOLON,
                         Lexer.Token.RIGHT_BRACE,
                         Lexer.Token.RIGHT_BRACE
                       ]

methodArgumentsABS = [Class "A" [FieldDecl [VariableDecl "a" "int" False Nothing] Public False] 
                     [MethodDecl "multiply" "int" 
                         [ArgumentDecl "b" "int" False,
                         ArgumentDecl "c" "int" False] 
                         (Block [Return 
                         	        (Binary "*" 
                         	        	(Binary "*" (InstVar This "a") (LocalOrFieldVar "b")) 
                         	        (LocalOrFieldVar "c"))
                         	    ]
                         ) Public False,
                      MethodDecl "A" "A" [
                          ArgumentDecl "a" "int" False
                          ] 
                          (Block [StmtExprStmt 
                          	        (Assign (InstVar This "a") (LocalOrFieldVar "a"))
                          	     ]
                          ) Public True
                          ],
                       Class "B" [] 
                       [MethodDecl "call" "int" [] 
                           (Block 
                           	[LocalVarDecls 
                           	   [VariableDecl "a" "A" False 
                           	   (Just (StmtExprExpr (New "A" [IntegerLiteral 5])))],
                           	Return (StmtExprExpr 
                           		(MethodCall (LocalOrFieldVar "a") "multiply" [IntegerLiteral 3,IntegerLiteral 2]))
                           	]) 
                           Public False]
                       ]







