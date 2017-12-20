module SwitchCase.Steps where

import           ABSTree
import           Lexer.Token

switchCaseTokens = [Lexer.Token.CLASS,
                    Lexer.Token.IDENTIFIER "SwitchCase",
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.VOID,
                    Lexer.Token.IDENTIFIER "doStuff",
                    Lexer.Token.LEFT_PARANTHESES,
                    Lexer.Token.RIGHT_PARANTHESES,
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.INTEGER,
                    Lexer.Token.IDENTIFIER "i",
                    Lexer.Token.ASSIGN,
                    Lexer.Token.INTEGER_LITERAL 5,
                    Lexer.Token.COMMA,
                    Lexer.Token.IDENTIFIER "a",
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.SWITCH,
                    Lexer.Token.LEFT_PARANTHESES,
                    Lexer.Token.IDENTIFIER "i",
                    Lexer.Token.RIGHT_PARANTHESES,
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.CASE,
                    Lexer.Token.INTEGER_LITERAL 1,
                    Lexer.Token.COLON,
                    Lexer.Token.IDENTIFIER "a",
                    Lexer.Token.ASSIGN,
                    Lexer.Token.INTEGER_LITERAL 3,
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.BREAK,
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.CASE,
                    Lexer.Token.INTEGER_LITERAL 2,
                    Lexer.Token.COLON,
                    Lexer.Token.IDENTIFIER "a",
                    Lexer.Token.ASSIGN,
                    Lexer.Token.INTEGER_LITERAL 2,
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.BREAK,
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.RIGHT_BRACE,
                    Lexer.Token.RIGHT_BRACE,
                    Lexer.Token.RIGHT_BRACE
                   ]

switchCaseABS = [Class "SwitchCase" []
                 [MethodDecl "doStuff" "void" []
                     (Block [LocalVarDecls [VariableDecl "i" "int" False (Just (IntegerLiteral 5)), VariableDecl "a" "int" False Nothing],
                             Switch (LocalOrFieldVar "i") [SwitchCase (IntegerLiteral 1) [StmtExprStmt (Assign (LocalOrFieldVar "a") (IntegerLiteral 3)), Break],
                                                            SwitchCase (IntegerLiteral 2) [StmtExprStmt (Assign (LocalOrFieldVar "a") (IntegerLiteral 2)), Break]] Nothing
                     ]) Public False
                 ]
                ]

