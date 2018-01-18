module  Correct.DoWhile.Steps where

import           ABSTree
import           Lexer.Token

doWhileTokens = [Lexer.Token.CLASS,
                 Lexer.Token.IDENTIFIER "DoWhile",
                 Lexer.Token.LEFT_BRACE,
                 Lexer.Token.VOID,
                 Lexer.Token.IDENTIFIER "doStuff",
                 Lexer.Token.LEFT_PARANTHESES,
                 Lexer.Token.RIGHT_PARANTHESES,
                 Lexer.Token.LEFT_BRACE,
                 Lexer.Token.INTEGER,
                 Lexer.Token.IDENTIFIER "i",
                 Lexer.Token.ASSIGN,
                 Lexer.Token.INTEGER_LITERAL 0,
                 Lexer.Token.SEMICOLON,
                 Lexer.Token.DO,
                 Lexer.Token.LEFT_BRACE,
                 Lexer.Token.IDENTIFIER "i",
                 Lexer.Token.ASSIGN,
                 Lexer.Token.IDENTIFIER "i",
                 Lexer.Token.ADD,
                 Lexer.Token.INTEGER_LITERAL 1,
                 Lexer.Token.SEMICOLON,
                 Lexer.Token.RIGHT_BRACE,
                 Lexer.Token.WHILE,
                 Lexer.Token.LEFT_PARANTHESES,
                 Lexer.Token.IDENTIFIER "i",
                 Lexer.Token.LESSER,
                 Lexer.Token.INTEGER_LITERAL 3,
                 Lexer.Token.RIGHT_PARANTHESES,
                 Lexer.Token.SEMICOLON,
                 Lexer.Token.RIGHT_BRACE,
                 Lexer.Token.RIGHT_BRACE
                ]

doWhileABS = [Class "DoWhile" []
              [MethodDecl "doStuff" "void" []
                  (Block [LocalVarDecls [VariableDecl "i" "int" False (Just (IntegerLiteral 0))],
                          DoWhile (Binary "<" (LocalOrFieldVar "i") (IntegerLiteral 3)) (Block [StmtExprStmt (Assign (LocalOrFieldVar "i") (Binary "+" (LocalOrFieldVar "i") (IntegerLiteral 1)))])
                  , Block[]]) Public False
               ]
             ]
