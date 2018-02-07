module Utils.SUnit (module Utils.SUnit) where

import           ABSTree
import           Codegen.Data.ClassFormat
import           Codegen.GenerateClassFile
import           Codegen.BinaryClass
import           Control.Exception
import           Control.Monad             ()
import           Data.List
import           Lexer
import           Lexer.Token
import           Parser
import           System.Directory          ()
import qualified Data.ByteString.Lazy as BS
import           Data.Binary (encode)
import           System.IO.Unsafe
import           TypeChecker
import           Control.Arrow

all_tokens :: [Token]
all_tokens = [ADD, SUBTRACT, MULTIPLY, DIVIDE, MODULO, INCREMENT, DECREMENT, NOT, AND, OR, EQUAL, NOT_EQUAL, LESSER, GREATER, LESSER_EQUAL, GREATER_EQUAL, BITWISE_AND, BITWISE_OR, BITWISE_XOR, SHIFTLEFT, SHIFTRIGHT, UNSIGNED_SHIFTRIGHT,
              LEFT_PARANTHESES, RIGHT_PARANTHESES, LEFT_BRACE, RIGHT_BRACE, DOT, COMMA, COLON, SEMICOLON, ASSIGN, ADD_ASSIGN, SUBTRACT_ASSIGN, MULTIPLY_ASSIGN, DIVIDE_ASSIGN, MODULO_ASSIGN, AND_ASSIGN, OR_ASSIGN, XOR_ASSIGN, SHIFTLEFT_ASSIGN,
              SHIFTRIGHT_ASSIGN, UNSIGNED_SHIFTRIGHT_ASSIGN, BOOLEAN, CHARACTER, INTEGER, VOID, FOR, WHILE, DO, BREAK, CONTINUE, IF, ELSE, SWITCH, CASE, DEFAULT, QUESTIONMARK, CLASS, NEW, PRIVATE, PUBLIC, STATIC, THIS, RETURN, BOOLEAN_LITERAL True, CHARACTER_LITERAL 'a',
              INTEGER_LITERAL 1, IDENTIFIER "", JNULL, INSTANCEOF, FINAL]

data TestUnit = LexerUnit String [Token]  -- TestName,  Expected Tokens
              | ParserUnit String [Class] -- Testname, TestClasses
              | ParserException String [Class] -- Testname, TestClasses, expects exception
              | TypeUnit String [Class] -- Testname, Expected class

                deriving(Eq, Show)

-- Some colors for pretty output
data Color
    = Green
    | Purple
    | Blue
    | Red


-- Take a color and a string to get the string in the given color
color :: Color -> String -> String
color Green text  = "\x1b[32m" ++ text ++ "\x1b[0m"
color Purple text = "\x1b[35m" ++ text ++ "\x1b[0m"
color Blue text   = "\x1b[36m" ++ text ++ "\x1b[0m"
color Red text    = "\x1b[31m" ++ text ++ "\x1b[0m"

getLexerRealToken :: TestUnit -> [Token]
getLexerRealToken (LexerUnit name _) = readTokens name
getLexerRealToken _                  = []

readTokens :: String -> [Token]
readTokens s = Lexer.lex (unsafePerformIO . readFile $ ("./test/" ++ s ++ "/Class.java"))

typeABS :: String -> [Class]
typeABS s = TypeChecker.checkTypes (Parser.parse (readTokens s))

genClassFiles :: [Class] -> [ClassFile]
genClassFiles = map Codegen.GenerateClassFile.genClass

writeClassFiles :: [Class] -> IO ()
writeClassFiles = mapM_ ((\(n,cf) -> BS.writeFile ("./" ++ n ++ ".class") (encode cf))
                          . ((\(Class name _ _) -> name)
                            &&& Codegen.GenerateClassFile.genClass))

runTest :: TestUnit -> IO Bool
runTest (LexerUnit name expectedTokens) = do
                                              result <- try (evaluate (readTokens name)) :: IO (Either SomeException [Token])
                                              case result of
                                                Left _ -> return False
                                                Right val -> return (val == expectedTokens)

runTest (ParserUnit name expectedClass) = do
                                            result <- try (evaluate (Parser.parse (readTokens name))) :: IO (Either SomeException [Class])
                                            case result of
                                              Left _   -> return False
                                              Right val -> return (val == expectedClass)

runTest (TypeUnit name expectedClass) = do
                                            result <- try (evaluate (TypeChecker.checkTypes (Parser.parse (readTokens name)))) :: IO (Either SomeException [Class])
                                            case result of
                                              Left _   -> return False
                                              Right val -> return (val == expectedClass)

runTest (ParserException name _) = do
                                                  result <- try (evaluate (Parser.parse (readTokens name))) :: IO (Either SomeException [Class])
                                                  case result of
                                                    Left _  -> return True
                                                    Right _ -> return False



testOutput :: (Eq a, Show a) => String -> String -> a -> a -> String
testOutput step name expected got = let stepName = step ++ ": [" ++ name ++ "] "
                                    in
                                    if expected == got
                                    then color Green (stepName ++  "passed")
                                    else color Purple (stepName ++ "failed \n\t") ++
                                    color Blue ("expected: " ++ show expected ++ "\n\t") ++
                                    color Blue ("got: " ++ show got ++ " \n\t")


evalTest :: TestUnit -> IO String
evalTest (LexerUnit name expectedTokens) = do
                                               result <- try (evaluate (readTokens name)) :: IO (Either SomeException [Token])
                                               case result of
                                                Left ex ->  return (color Red ("Lexer: [" ++ name ++ "] failed with exception: ") ++ show ex)
                                                Right lexerToken -> return (testOutput "Lexer" name expectedTokens lexerToken)

evalTest (ParserUnit name expectedClass) = do
                                               result <- try (evaluate (Parser.parse (readTokens name))) :: IO (Either SomeException [Class])
                                               case result of
                                                Left ex ->  return (color Red ("Parser: [" ++ name ++ "] failed with exception: ")  ++ show ex)
                                                Right parserClass -> return (testOutput "Parser" name expectedClass parserClass)

evalTest (ParserException name _) = do
                                        result <- try (evaluate (Parser.parse (readTokens name))) :: IO (Either SomeException [Class])
                                        case result of
                                          Left _ -> return (color Blue ("Parser: [" ++ name ++ "] passed with expected exception"))
                                          Right _ -> return (color Red ("Parser [" ++ name ++ "] passed without exception, exception expected"))


evalTest (TypeUnit name expectedClass) = do
                                               result <- try (evaluate (typeABS name)) :: IO (Either SomeException [Class])
                                               case result of
                                                Left ex ->  return (color Red ("TypeChecker: [" ++ name ++ "] failed with exception: ")  ++ show ex)
                                                Right typedClass -> return (testOutput "TypeChecker" name expectedClass typedClass)


runTests :: [TestUnit] -> [IO Bool]
runTests = map runTest

evalTests :: [TestUnit] -> [IO String]
evalTests = map evalTest

numberOfSuccess :: [TestUnit] -> Int
numberOfSuccess a = sum (map ((\b -> if b then 1 else 0) . unsafePerformIO) (runTests a))

-- used to replace multiple tokens with different parameters
skipParameter :: Token -> Token
skipParameter (IDENTIFIER _)        = IDENTIFIER ""
skipParameter (BOOLEAN_LITERAL _)   = BOOLEAN_LITERAL True
skipParameter (CHARACTER_LITERAL _) = CHARACTER_LITERAL 'a'
skipParameter (INTEGER_LITERAL _)   = INTEGER_LITERAL 1
skipParameter a                     = a

tokenCovering :: [TestUnit] -> Int
tokenCovering a = length (nub (map skipParameter (foldr ((++) . getLexerRealToken) [] a))) -- get unique tokens used

-- define int by int division resulting in float
intDivisionPercentage :: Int -> Int -> Int
intDivisionPercentage a b = ceiling((fromIntegral a / fromIntegral b) * 100)

-- return missing tokens from testset, when allTokens are all possible tokens
missingTokens :: [Token] -> [TestUnit] -> [Token]
missingTokens allTokens a = let unique_tokens = nub (map skipParameter (foldr ((++) . getLexerRealToken) [] a))
                            in
                              allTokens \\ unique_tokens







