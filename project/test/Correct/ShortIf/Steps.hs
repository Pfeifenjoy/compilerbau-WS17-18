module  Correct.ShortIf.Steps where

import           ABSTree
import           Lexer.Token

shortIfTokens = [Lexer.Token.CLASS,
                 Lexer.Token.IDENTIFIER "ShortIf",
                 Lexer.Token.LEFT_BRACE,
                 Lexer.Token.VOID,
                 Lexer.Token.IDENTIFIER "doStuff",
                 Lexer.Token.LEFT_PARANTHESES,
                 Lexer.Token.RIGHT_PARANTHESES,
                 Lexer.Token.LEFT_BRACE,
                 Lexer.Token.INTEGER,
                 Lexer.Token.IDENTIFIER "a",
                 Lexer.Token.ASSIGN,
                 Lexer.Token.LEFT_PARANTHESES,
                 Lexer.Token.BOOLEAN_LITERAL True,
                 Lexer.Token.RIGHT_PARANTHESES,
                 Lexer.Token.QUESTIONMARK,
                 Lexer.Token.INTEGER_LITERAL 1,
                 Lexer.Token.COLON,
                 Lexer.Token.INTEGER_LITERAL 0,
                 Lexer.Token.SEMICOLON,
                 Lexer.Token.RIGHT_BRACE,
                 Lexer.Token.RIGHT_BRACE
                ]

shortIfABS = [Class "ShortIf" []
              [MethodDecl "doStuff" "void" []
                  (Block [LocalVarDecls [VariableDecl "a" "int" False (Just (Ternary (BooleanLiteral True) (IntegerLiteral 1) (IntegerLiteral 0)))]

                  ]) Public False
              ]
             ]

shortIfTypedABS = [Class "ShortIf" []
              [MethodDecl "doStuff" "void" []
                  (TypedStmt (Block [TypedStmt (LocalVarDecls [VariableDecl "a" "int" False (Just (TypedExpr (Ternary (TypedExpr (BooleanLiteral True) "boolean") (TypedExpr (IntegerLiteral 1) "int") (TypedExpr (IntegerLiteral 0) "int")) "int"))]) "void"

                  ]) "void") Public False
              ]
             ]
