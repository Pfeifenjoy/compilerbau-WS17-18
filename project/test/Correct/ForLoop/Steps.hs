module  Correct.ForLoop.Steps where

import           ABSTree
import           Lexer.Token

forLoopTokens :: [Token]
forLoopTokens = [Lexer.Token.CLASS,
                    Lexer.Token.IDENTIFIER "ForLoop",
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.VOID,
                    Lexer.Token.IDENTIFIER "doLoop",
                    Lexer.Token.LEFT_PARANTHESES,
                    Lexer.Token.RIGHT_PARANTHESES,
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.INTEGER,
                    Lexer.Token.IDENTIFIER "a",
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.IDENTIFIER "a",
                    Lexer.Token.ASSIGN,
                    Lexer.Token.INTEGER_LITERAL 0,
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.FOR,
                    Lexer.Token.LEFT_PARANTHESES,
                    Lexer.Token.INTEGER,
                    Lexer.Token.IDENTIFIER "i",
                    Lexer.Token.ASSIGN,
                    Lexer.Token.INTEGER_LITERAL 0,
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.IDENTIFIER "i",
                    Lexer.Token.LESSER,
                    Lexer.Token.INTEGER_LITERAL 3,
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.IDENTIFIER "i",
                    Lexer.Token.INCREMENT,
                    Lexer.Token.RIGHT_PARANTHESES,
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.IDENTIFIER "a",
                    Lexer.Token.ASSIGN,
                    Lexer.Token.IDENTIFIER "a",
                    Lexer.Token.ADD,
                    Lexer.Token.IDENTIFIER "i",
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.CONTINUE,
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.RIGHT_BRACE,
                    Lexer.Token.RIGHT_BRACE,
                    Lexer.Token.RIGHT_BRACE
                   ]

forLoopABS :: [Class]
forLoopABS = [Class "ForLoop"
              []
              [MethodDecl "doLoop" "void" []
                  (Block [LocalVarDecls [VariableDecl "a" "int" False Nothing],
                          StmtExprStmt (Assign (LocalOrFieldVar "a") (IntegerLiteral 0)),
                          For (LocalVarDecls [VariableDecl "i" "int" False (Just (IntegerLiteral 0))]) (Binary "<" (LocalOrFieldVar "i") (IntegerLiteral 3)) (StmtExprStmt (LazyAssign (LocalOrFieldVar "i") (Binary "+" (LocalOrFieldVar "i") (IntegerLiteral 1))))
                              (Block [StmtExprStmt (Assign (LocalOrFieldVar "a") (Binary "+" (LocalOrFieldVar "a") (LocalOrFieldVar "i"))),
                                      Continue
                              ])
                          ]) Public False]
             ]

forLoopTypedABS = [Class "ForLoop"
              []
              [MethodDecl "doLoop" "void" []
                  (TypedStmt (Block [TypedStmt (LocalVarDecls [VariableDecl "a" "int" False Nothing]) "void",
                          TypedStmt (StmtExprStmt (TypedStmtExpr (Assign (TypedExpr (LocalOrFieldVar "a") "int") (TypedExpr (IntegerLiteral 0) "int")) "int")) "void",
                          TypedStmt (For (TypedStmt (LocalVarDecls [VariableDecl "i" "int" False (Just (TypedExpr (IntegerLiteral 0) "int"))]) "void")
                                      (TypedExpr (Binary "<" (TypedExpr (LocalOrFieldVar "i") "int") (TypedExpr (IntegerLiteral 3) "int")) "boolean")
                                      (TypedStmt (StmtExprStmt (TypedStmtExpr (LazyAssign (TypedExpr (LocalOrFieldVar "i") "int")
                                        (TypedExpr (Binary "+" (TypedExpr (LocalOrFieldVar "i") "int") (TypedExpr (IntegerLiteral 1) "int")) "int")) "int")) "void")
                              (TypedStmt (Block [
                                              TypedStmt (StmtExprStmt (TypedStmtExpr
                                                        (Assign (TypedExpr (LocalOrFieldVar "a") "int")
                                                          (TypedExpr (Binary "+" (TypedExpr (LocalOrFieldVar "a") "int")
                                                            (TypedExpr (LocalOrFieldVar "i") "int")) "int")) "int")) "void",
                                      (TypedStmt Continue "void")
                              ]) "void")) "void"
                          ]) "void") Public False]
             ]






