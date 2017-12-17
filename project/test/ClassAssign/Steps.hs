module ClassAssign.Steps where

import           ABSTree
import           Lexer.Token

classAssignTokens = [Lexer.Token.CLASS,
                    Lexer.Token.IDENTIFIER "ClassAssign",
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.INTEGER,
                    Lexer.Token.IDENTIFIER "a",
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.INTEGER,
                    Lexer.Token.IDENTIFIER "doStuff",
                    Lexer.Token.LEFT_PARANTHESES,
                    Lexer.Token.INTEGER,
                    Lexer.Token.IDENTIFIER "b",
                    Lexer.Token.RIGHT_PARANTHESES,
                    Lexer.Token.LEFT_BRACE,
                    Lexer.Token.INTEGER,
                    Lexer.Token.IDENTIFIER "c",
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.IDENTIFIER "c",
                    Lexer.Token.ASSIGN,
                    Lexer.Token.IDENTIFIER "b",
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.RETURN,
                    Lexer.Token.IDENTIFIER "b",
                    Lexer.Token.SEMICOLON,
                    Lexer.Token.RIGHT_BRACE,
                    Lexer.Token.RIGHT_BRACE]

classAssignABS = [Class "ClassAssign"
                  [FieldDecl [VariableDecl "a" "int" False Nothing] Public False]
                  [MethodDecl "doStuff" "int" [ArgumentDecl "b" "int" False]
                              (Block [LocalVarDecls [VariableDecl "c" "int" False Nothing],
                                   StmtExprStmt (Assign (LocalOrFieldVar "c") (LocalOrFieldVar "b")),
                                   Return (LocalOrFieldVar "b")]) Public False]
                 ]


