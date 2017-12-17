module InstanzVariable.Steps where

import           ABSTree
import           Lexer.Token

instanzVariableTokens = [Lexer.Token.CLASS,
                        Lexer.Token.IDENTIFIER "InstanzVariable",
                        Lexer.Token.LEFT_BRACE,
                        Lexer.Token.INTEGER,
                        Lexer.Token.IDENTIFIER "i",
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.BOOLEAN,
                        Lexer.Token.IDENTIFIER "b",
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.CHARACTER,
                        Lexer.Token.IDENTIFIER "c",
                        Lexer.Token.SEMICOLON,
                        Lexer.Token.RIGHT_BRACE]

instanzVariableABS = [Class "InstanzVariable"
                      [FieldDecl (VariableDecl "int" "i" False) Public False,
                       FieldDecl (VariableDecl "bool" "b" False) Public False,
                       FieldDecl (VariableDecl "char" "c" False) Public False
                     ] []]
