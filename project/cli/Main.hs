module Main where

import System.Console.ArgParser
import Control.Applicative

import Lexer
import Lexer.Token
import Parser
import TypeChecker
import ABSTree
--import Codegenerator

data JC = JC String String -- path, log
    deriving (Show)

jcArgumentParser :: ParserSpec JC
jcArgumentParser = JC
    `parsedBy` reqPos "source-files" `Descr` "Path to the sources which are compiled."
    `andBy` optPos "" "log-file-destination"

jcInterface :: IO (CmdLnInterface JC)
jcInterface = mkApp jcArgumentParser

lex :: String -> IO ([Token])
lex raw = return (Lexer.lex raw)

parse :: [Token] -> IO ([Class])
parse tokens = return (Parser.parse tokens)

checkTypes :: [Class] -> IO ([Class])
checkTypes ast = return (TypeChecker.checkTypes ast)

run :: JC -> IO ()
run (JC srcpath logpath) = do
    src <- readFile srcpath
    tokens <- Main.lex src
    ast <- Main.parse tokens
    typedAst <- Main.checkTypes ast
    print typedAst

main :: IO ()
main = do
    interface <- jcInterface
    runApp interface run

