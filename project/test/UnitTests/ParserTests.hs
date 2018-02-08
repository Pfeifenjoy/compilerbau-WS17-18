module UnitTests.ParserTests (module UnitTests.ParserTests) where

import           Correct.BitWiseOperation.Steps
import           Correct.ClassAssign.Steps
import           Correct.ClassMethods.Steps
import           Correct.DoWhile.Steps
import           Correct.EmptyClass.Steps
import           Correct.EndlessForLoop.Steps
import           Correct.ForLoop.Steps
import           Correct.InstanceOf.Steps
import           Correct.InstanzVariable.Steps
import           Correct.LocalVariable.Steps
import           Correct.LogicOperations.Steps
import           Correct.LogicOperations2.Steps
import           Correct.MethodCall.Steps
import           Correct.NewClass.Steps
import           Correct.ShortIf.Steps
import           Correct.SimpleIf.Steps
import           Correct.SwitchCase.Steps
import           Correct.WhileLoop.Steps
import           Correct.WhileLoopCondition.Steps
import           Utils.SUnit
import           Correct.OperatorOverloading.Steps
import           Correct.MethodArguments.Steps
import ExampleProgramms.Faculty.Steps
import ExampleProgramms.Fibonacci.Steps

parserTests :: [TestUnit]
parserTests = [ParserUnit "Correct/EmptyClass" emptyABS,
               ParserUnit "Correct/InstanzVariable" instanzVariableABS,
               ParserUnit "Correct/ClassAssign" classAssignABS,
               ParserUnit "Correct/ClassMethods" classMethodsABS,
               ParserUnit "Correct/OperatorOverloading" operatorOverloadingABS,
               ParserUnit "Correct/MethodArguments" methodArgumentsABS,
               ParserUnit "Correct/ForLoop" forLoopABS,
               ParserUnit "Correct/EndlessForLoop" endlessForLoopABS,
               ParserUnit "Correct/LocalVariable" localVariableABS,
               ParserUnit "Correct/SimpleIf" simpleIfABS,
               ParserUnit "Correct/ShortIf" shortIfABS,
               ParserUnit "Correct/SwitchCase" switchCaseABS,
               ParserUnit "Correct/WhileLoop" whileLoopABS,
               ParserUnit "Correct/WhileLoopCondition" whileLoopConditionABS,
               ParserUnit "Correct/DoWhile" doWhileABS,
               ParserUnit "Correct/LogicOperations" logicOperationsABS,
               ParserUnit "Correct/LogicOperations2" logicOperations2ABS,
               ParserUnit "Correct/BitWiseOperation" bitWiseOperationABS,
               ParserUnit "Correct/NewClass" newClassABS,
               ParserUnit "Correct/InstanceOf" instanceOfABS,
               ParserUnit "Correct/MethodCall" methodCallABS,
               ParserException "Wrong/Syntax/Arithmetic" emptyABS,
               ParserException "Wrong/Syntax/BraceError" emptyABS,
               ParserException "Wrong/Syntax/SemicolonMissing" emptyABS,
               ParserException "Wrong/Syntax/TypeMissing" emptyABS,
               ParserException "Wrong/Syntax/ReturnTypeMissing" emptyABS,
               ParserUnit "ExampleProgramms/Faculty" facultyABS,
               ParserUnit "ExampleProgramms/Fibonacci" fibonacciABS
               ]
