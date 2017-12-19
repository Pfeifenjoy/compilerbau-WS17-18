module SimpleIf.Steps where

import           ABSTree
import           Lexer.Token

simpleIfTokens = [Lexer.Token.CLASS,
                        Lexer.Token.IDENTIFIER "SimpleIf",
                        Lexer.Token.LEFT_BRACE,
                        Lexer.Token.INTEGER,
                        Lexer.Token.IDENTIFIER "i",
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.VOID,
                        Lexer.Token.IDENTIFIER "doIf",
                        Lexer.Token.LEFT_PARANTHESES,
                        Lexer.Token.RIGHT_PARANTHESES,
                        Lexer.Token.LEFT_BRACE,
                        Lexer.Token.INTEGER,
                        Lexer.Token.IDENTIFIER "a",
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.IDENTIFIER "a",
                        Lexer.Token.ASSIGN,
                        Lexer.Token.INTEGER_LITERAL 5,
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.IDENTIFIER "i",
                        Lexer.Token.ASSIGN,
                        Lexer.Token.INTEGER_LITERAL 0,
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.IF,
                        Lexer.Token.LEFT_PARANTHESES,
                        Lexer.Token.IDENTIFIER "a",
                        Lexer.Token.LESSER,
                        Lexer.Token.INTEGER_LITERAL 5,
                        Lexer.Token.RIGHT_PARANTHESES,
                        Lexer.Token.LEFT_BRACE,
                        Lexer.Token.IDENTIFIER "i",
                        Lexer.Token.ASSIGN,
                        Lexer.Token.IDENTIFIER "a",
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.RIGHT_BRACE,
                        Lexer.Token.ELSE,
                        Lexer.Token.LEFT_BRACE,
                        Lexer.Token.IDENTIFIER "i",
                        Lexer.Token.ASSIGN,
                        Lexer.Token.INTEGER_LITERAL 2,
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.RIGHT_BRACE,
                        Lexer.Token.RIGHT_BRACE,
                        Lexer.Token.RIGHT_BRACE
                       ]

simpleIfABS = [Class "SimpleIf" [FieldDecl [VariableDecl "i" "int" False Nothing] Public False]
               [MethodDecl "doIf" "void" []
                   (Block [LocalVarDecls [VariableDecl "a" "int" False Nothing],
                           StmtExprStmt (Assign (LocalOrFieldVar "a") (IntegerLiteral 5)),
                           StmtExprStmt (Assign (LocalOrFieldVar "i") (IntegerLiteral 0)),
                           If (Binary "<" (LocalOrFieldVar "a") (IntegerLiteral 5))
                               (Block [StmtExprStmt (Assign (LocalOrFieldVar "i") (LocalOrFieldVar "a"))]
                                )
                               (Just (Block [StmtExprStmt (Assign (LocalOrFieldVar "i") (IntegerLiteral 2))]))]
                  ) Public False
                ]
              ]






