module Utils.SUnit (module Utils.SUnit) where

import           ABSTree
import           Control.Exception
import           Control.Monad     ()
import           Data.List
import           Lexer
import           Lexer.Token
import           Parser
import           System.Directory  ()
import           System.IO.Unsafe

all_tokens :: [Token]
all_tokens = [ADD, SUBTRACT, MULTIPLY, DIVIDE, MODULO, INCREMENT, DECREMENT, NOT, AND, OR, EQUAL, NOT_EQUAL, LESSER, GREATER, LESSER_EQUAL, GREATER_EQUAL, BITWISE_AND, BITWISE_OR, BITWISE_XOR, SHIFTLEFT, SHIFTRIGHT, UNSIGNED_SHIFTRIGHT,
              LEFT_PARANTHESES, RIGHT_PARANTHESES, LEFT_BRACE, RIGHT_BRACE, DOT, COMMA, COLON, SEMICOLON, ASSIGN, ADD_ASSIGN, SUBTRACT_ASSIGN, MULTIPLY_ASSIGN, DIVIDE_ASSIGN, MODULO_ASSIGN, AND_ASSIGN, OR_ASSIGN, XOR_ASSIGN, SHIFTLEFT_ASSIGN,
              SHIFTRIGHT_ASSIGN, UNSIGNED_SHIFTRIGHT_ASSIGN, BOOLEAN, CHARACTER, INTEGER, VOID, FOR, WHILE, DO, BREAK, CONTINUE, IF, ELSE, SWITCH, CASE, QUESTIONMARK, CLASS, NEW, PRIVATE, PUBLIC, STATIC, THIS, RETURN, BOOLEAN_LITERAL True, CHARACTER_LITERAL 'a',
              INTEGER_LITERAL 1, IDENTIFIER "", JNULL, INSTANCEOF, FINAL]

data TestUnit = LexerUnit String [Token] -- TestName, TestTokens
              | ParserUnit String [Class] -- Testname, TestClasses, fromTokens
                deriving(Eq, Show)

data Color
    = Green
    | Purple
    | Blue
    | Red

color :: Color -> String -> String
color Green text  = "\x1b[32m" ++ text ++ "\x1b[0m"
color Purple text = "\x1b[35m" ++ text ++ "\x1b[0m"
color Blue text   = "\x1b[36m" ++ text ++ "\x1b[0m"
color Red text    = "\x1b[31m" ++ text ++ "\x1b[0m"

getLexerName :: TestUnit -> String
getLexerName (LexerUnit name testToken) = name

getLexerTestToken :: TestUnit -> [Token]
getLexerTestToken (LexerUnit name testToken) = testToken

getLexerRealToken :: TestUnit -> [Token]
getLexerRealToken (LexerUnit name testToken) = readTokens name

readTokens :: String -> [Token]
readTokens s = Lexer.lex (unsafePerformIO . readFile $ ("./test/" ++ s ++ "/Class.java"))

runTest :: TestUnit -> IO Bool
runTest (LexerUnit name expectedTokens) = do
                                              result <- try (evaluate (readTokens name)) :: IO (Either SomeException [Token])
                                              case result of
                                                Left ex -> return False
                                                Right val -> return (val == expectedTokens)

runTest (ParserUnit name expectedClass) = do
                                            result <- try (evaluate (Parser.parse (readTokens name))) :: IO (Either SomeException [Class])
                                            case result of
                                              Left ex   -> return False
                                              Right val -> return (val == expectedClass)


evalTest :: TestUnit -> IO String
evalTest (LexerUnit name expectedTokens) = do
                                               result <- try (evaluate (readTokens name)) :: IO (Either SomeException [Token])
                                               case result of
                                                Left ex ->  return (color Red ("Lexer: [" ++ name ++ "] failed with exception: ") ++ show ex)
                                                Right lexerToken -> if lexerToken == expectedTokens
                                                then
                                                  return (color Green ("Lexer: [" ++ name ++ "] passed"))
                                                else
                                                  return (color Purple ("Lexer: [" ++ name ++ "] failed" ++ "\n\t") ++
                                                          color Blue "expected:" ++ show expectedTokens ++ "\n\t" ++
                                                          color Blue "got:" ++ show lexerToken ++ "\n\t" ++
                                                          color Blue "difference:" ++ show (nub ((expectedTokens \\ lexerToken) ++ (lexerToken \\ expectedTokens))))



evalTest (ParserUnit name expectedClass) = do
                                               result <- try (evaluate (Parser.parse (readTokens name))) :: IO (Either SomeException [Class])
                                               case result of
                                                Left ex ->  return (color Red ("Parser: [" ++ name ++ "] failed with exception: ")  ++ show ex)
                                                Right parserClass -> if parserClass == expectedClass
                                                then
                                                  return (color Green ("Parser: [" ++ name ++ "] passed"))
                                                else
                                                  return (color Purple ("Parser: [" ++ name ++ "] failed" ++ "\n\t") ++
                                                          color Blue "expected:" ++ show expectedClass ++ "\n\t" ++
                                                          color Blue "got:" ++ show parserClass ++ "\n\t" ++
                                                          color Blue "difference:" ++ show (nub ((expectedClass \\ parserClass) ++ (parserClass \\ expectedClass))))


runTests :: [TestUnit] -> [IO Bool]
runTests = map runTest

evalTests :: [TestUnit] -> [IO String]
evalTests = map evalTest

numberOfSuccess :: [TestUnit] -> Int
numberOfSuccess a = sum (map ((\ a -> if a then 1 else 0) . unsafePerformIO) (runTests a))

-- used to replace multiple tokens with different parameters
skipParameter :: Token -> Token
skipParameter (IDENTIFIER s)        = IDENTIFIER ""
skipParameter (BOOLEAN_LITERAL c)   = BOOLEAN_LITERAL True
skipParameter (CHARACTER_LITERAL c) = CHARACTER_LITERAL 'a'
skipParameter (INTEGER_LITERAL c)   = INTEGER_LITERAL 0
skipParameter a                     = a

tokenCovering :: [TestUnit] -> Int
tokenCovering a = length (nub (map skipParameter (foldr ((++) . getLexerRealToken) [] a))) -- get unique tokens used
