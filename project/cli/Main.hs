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
import System.FilePath.Posix

import System.Directory
import Control.Monad
import System.Environment

-- 1. Monadic wrappers
lex :: String -> IO ([Token])
lex raw = return (Lexer.lex raw)

parse :: [Token] -> IO ([Class])
parse tokens = return (Parser.parse tokens)

checkTypes :: [Class] -> IO ([Class])
checkTypes ast = return (TypeChecker.checkTypes ast)

generateBytecode :: [Class] -> IO ([ClassFile])
generateBytecode ast = return (map Codegen.GenerateClassFile.genClass ast)

-- 2. Logging functions
times :: String -> Int -> String
times x 1 = x
times x b = x ++ (times x (b - 1))

spacer :: String -> String
spacer name = (times "#" 50)
    ++ "\n# " ++ name ++ (times " " (50 - (length name) - 3)) ++ "#\n"
    ++ (times "#" 50) ++ "\n"

generateLog :: String -> String -> [Token] -> [Class] -> [Class] -> [ClassFile] -> IO (String)
generateLog name src tokens ast typedAst classFiles = return (
    (spacer ("Class: " ++ name)) ++ "\n"
    ++ (spacer "Source") ++ src ++ "\n"
    ++ (spacer "Tokens") ++ (show tokens) ++ "\n"
    ++ (spacer "Abstract Syntax") ++ (show ast) ++ "\n"
    ++ (spacer "Typed Abstract Syntax") ++ (show typedAst) ++ "\n"
    ++ (spacer "Class Files") ++ (show classFiles) ++ "\n")

-- Write text into log file
log :: String -> String -> IO ()
log "" _ = return ()
log path text = do
    appendFile path (text ++ "\n")

-- 3. Plumming commands

saveBytecodeImpl :: Int -> String -> [ClassFile] -> IO ()
saveBytecodeImpl pos name [] = return ()
saveBytecodeImpl pos name (x : xs) = do
    writeFile (name ++ "-" ++ (show pos) ++ ".class") (show x)
    saveBytecodeImpl (pos + 1) name xs

-- Save bytecode of classes
-- If file has multiple -> do not throw error, create subfiles
saveBytecode :: String -> [ClassFile] -> IO ()
saveBytecode name classes = do
    saveBytecodeImpl 0 name classes

-- Compile single source file
compile :: String -> String -> IO ()
compile srcpath logpath = do
    src <- readFile srcpath
    tokens <- Main.lex src
    ast <- Main.parse tokens
    typedAst <- Main.checkTypes ast
    classFiles <- Main.generateBytecode typedAst
    logText <- generateLog className src tokens ast typedAst classFiles
    Main.log logpath logText
    saveBytecode className classFiles
    where className = takeBaseName srcpath

-- clear the intial log
clearLog (JC _ path) = do
    exists <- doesFileExist path
    when exists (removeFile path)

-- iterate through all source files
compileAll :: JC -> IO ()
compileAll (JC [] _) = return ()
compileAll (JC (x : xs) logpath) = do
    compile x logpath
    compileAll (JC xs logpath)

-- compile all sources
runAll :: JC -> IO ()
runAll jc = do
    clearLog jc
    compileAll jc

-- 4. TUI interface
-- Argument parser data structur
-- The program gets paths to the source files and can have a path to the log file.
data JC = JC [String] String -- paths, log
    deriving (Show)

-- Argparser specifications
jcArgumentParser :: ParserSpec JC
jcArgumentParser = JC
    `parsedBy` posArgs "source-files" [] (\b -> \a -> b ++ [a]) 
        `Descr` "Path to the sources which are compiled."
    `andBy` optFlag "" "log"
        `Descr` "Specify log file."

jcInterface :: IO (CmdLnInterface JC)
jcInterface = mkApp jcArgumentParser

main :: IO ()
main = do
    interface <- jcInterface
    runApp interface runAll

