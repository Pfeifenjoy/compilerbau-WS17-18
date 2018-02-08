module Main where

import System.Console.ArgParser
import Control.Applicative

import Lexer
import Lexer.Token
import Parser
import TypeChecker
import ABSTree
import Codegen.GenerateClassFile
import Codegen.Data.ClassFormat
import Codegen.BinaryClass
import System.FilePath.Posix

import System.Directory
import Control.Monad
import System.Environment
import qualified Data.ByteString.Lazy as BS

-- 1. Monadic wrappers
lex :: String -> IO ([Token])
lex raw = return (Lexer.lex raw)

parse :: [Token] -> IO ([Class])
parse tokens = return (Parser.parse tokens)

checkTypes :: [Class] -> IO ([Class])
checkTypes ast = return (TypeChecker.checkTypes ast)

data Bytecode = Bytecode String ClassFile -- name, bytecode
    deriving (Show)

generateBytecode :: [Class] -> IO ([Bytecode])
generateBytecode ast = return (map generateBytecodeSingle ast)

generateBytecodeSingle :: Class -> Bytecode
generateBytecodeSingle ast = Bytecode name (Codegen.GenerateClassFile.genClass ast)
    where (Class name _ _) = ast

-- 2. Logging functions
times :: String -> Int -> String
times x 1 = x
times x b = x ++ (times x (b - 1))

spacer :: String -> String
spacer name = (times "#" 50)
    ++ "\n# " ++ name ++ (times " " (50 - (length name) - 3)) ++ "#\n"
    ++ (times "#" 50) ++ "\n"

generateLog :: String -> String -> [Token] -> [Class] -> [Class] -> [Bytecode] -> IO (String)
generateLog name src tokens ast typedAst classFiles = return (
    (spacer ("Class: " ++ name)) ++ "\n"
    ++ (spacer "Source") ++ src ++ "\n"
    ++ (spacer "Tokens") ++ (show tokens) ++ "\n"
    ++ "\n" ++ (spacer "Abstract Syntax") ++ (show ast) ++ "\n"
    ++ "\n" ++ (spacer "Typed Abstract Syntax") ++ (show typedAst) ++ "\n"
    ++ "\n" ++ (spacer "Class Files") ++ (show classFiles) ++ "\n")

-- Write text into log file
log :: String -> String -> IO ()
log "" _ = return ()
log path text = do
    appendFile path (text ++ "\n")

-- 3. Plumming commands

-- Save bytecode of classes
-- If file has multiple -> do not throw error, create subfiles
saveBytecode :: [Bytecode] -> IO ()
saveBytecode [] = return ()
saveBytecode ((Bytecode name code):xs) = do
    BS.writeFile (name ++ ".class") (encode code)
    saveBytecode xs

-- Compile single source file
compile :: String -> String -> Bool -> IO ()
compile srcpath logpath verbose = do
    src <- readFile srcpath
    tokens <- Main.lex src
    ast <- Main.parse tokens
    typedAst <- Main.checkTypes ast
    classFiles <- Main.generateBytecode typedAst
    logText <- generateLog className src tokens ast typedAst classFiles
    Main.log logpath logText
    when verbose (putStrLn logText)
    saveBytecode classFiles
    where className = takeBaseName srcpath

-- clear the intial log
clearLog (JC _ path _) = do
    exists <- doesFileExist path
    when exists (removeFile path)

-- iterate through all source files
compileAll :: JC -> IO ()
compileAll (JC [] _ _) = return ()
compileAll (JC (x : xs) logpath verbose) = do
    compile x logpath verbose
    compileAll (JC xs logpath verbose)

-- compile all sources
runAll :: JC -> IO ()
runAll jc = do
    clearLog jc
    compileAll jc

-- 4. TUI interface
-- Argument parser data structur
-- The program gets paths to the source files and can have a path to the log file.
data JC = JC [String] String Bool -- paths, log, verbose
    deriving (Show)

-- Argparser specifications
jcArgumentParser :: ParserSpec JC
jcArgumentParser = JC
    `parsedBy` posArgs "source-files" [] (\b -> \a -> b ++ [a]) 
        `Descr` "Path to the sources which are compiled."
    `andBy` optFlag "" "log"
        `Descr` "Specify log file."
    `andBy` boolFlag "verbose"
        `Descr` "Show extra information"

jcInterface :: IO (CmdLnInterface JC)
jcInterface = mkApp jcArgumentParser

main :: IO ()
main = do
    interface <- jcInterface
    runApp interface runAll

