module  Correct.OperatorOverloading.Steps where

import           ABSTree
import           Lexer.Token

operatorOverloadingTokens = [Lexer.Token.CLASS,
                             Lexer.Token.IDENTIFIER "OperatorOverloading",
                             Lexer.Token.LEFT_BRACE,
                             Lexer.Token.INTEGER,
                             Lexer.Token.IDENTIFIER "calcIt",
                             Lexer.Token.LEFT_PARANTHESES,
                             Lexer.Token.INTEGER,
                             Lexer.Token.IDENTIFIER "i",
                             Lexer.Token.COMMA,
                             Lexer.Token.INTEGER,
                             Lexer.Token.IDENTIFIER "d",
                             Lexer.Token.RIGHT_PARANTHESES,
                             Lexer.Token.LEFT_BRACE,
                             Lexer.Token.RETURN,
                             Lexer.Token.IDENTIFIER "i",
                             Lexer.Token.MULTIPLY,
                             Lexer.Token.IDENTIFIER "d",
                             Lexer.Token.SEMICOLON,
                             Lexer.Token.RIGHT_BRACE,
                             Lexer.Token.INTEGER,
                             Lexer.Token.IDENTIFIER "calcIt",
                             Lexer.Token.LEFT_PARANTHESES,
                             Lexer.Token.INTEGER,
                             Lexer.Token.IDENTIFIER "i",
                             Lexer.Token.COMMA,
                             Lexer.Token.INTEGER,
                             Lexer.Token.IDENTIFIER "d",
                             Lexer.Token.COMMA,INTEGER,
                             Lexer.Token.IDENTIFIER "j",
                             Lexer.Token.RIGHT_PARANTHESES,
                             Lexer.Token.LEFT_BRACE,
                             Lexer.Token.RETURN,
                             Lexer.Token.IDENTIFIER "i",
                             Lexer.Token.MULTIPLY,
                             Lexer.Token.IDENTIFIER "d",
                             Lexer.Token.MULTIPLY,
                             Lexer.Token.IDENTIFIER "j",
                             Lexer.Token.SEMICOLON,
                             Lexer.Token.RIGHT_BRACE,
                             Lexer.Token.RIGHT_BRACE]


operatorOverloadingABS = [Class "OperatorOverloading" [] 
                         [MethodDecl "calcIt" "int" 
                             [ArgumentDecl "i" "int" False,
                             ArgumentDecl "d" "int" False] 
                             (Block [Return 
                                 (Binary "*" (LocalOrFieldVar "i") (LocalOrFieldVar "d"))
                             ]) 
                             Public False,
                         MethodDecl "calcIt" "int" 
                             [ArgumentDecl "i" "int" False,
                             ArgumentDecl "d" "int" False,
                             ArgumentDecl "j" "int" False] 
                             (Block [Return 
                                 (Binary "*" (Binary "*" (LocalOrFieldVar "i") (LocalOrFieldVar "d")) (LocalOrFieldVar "j"))
                             ]) 
                             Public False]
                         ]


operatorOverloadingTypedABS = [Class "OperatorOverloading" [] 
                              [MethodDecl "calcIt" "int" 
                                 [ArgumentDecl "i" "int" False,
                                 ArgumentDecl "d" "int" False] 
                                 (TypedStmt (Block [TypedStmt (Return 
                                     (TypedExpr (Binary "*" (TypedExpr (LocalOrFieldVar "i") "int") (TypedExpr (LocalOrFieldVar "d") "int")) "int")
                                 ) "int"]) "int")
                                 Public False,
                             MethodDecl "calcIt" "int" 
                                 [ArgumentDecl "i" "int" False,
                                 ArgumentDecl "d" "int" False,
                                 ArgumentDecl "j" "int" False] 
                                 (TypedStmt (Block [TypedStmt (Return 
                                     (TypedExpr (Binary "*" (TypedExpr (Binary "*" (TypedExpr (LocalOrFieldVar "i") "int") (TypedExpr (LocalOrFieldVar "d") "int")) "int") (TypedExpr (LocalOrFieldVar "j") "int")) "int")
                                 ) "int"]) "int")
                                 Public False]
                             ]









