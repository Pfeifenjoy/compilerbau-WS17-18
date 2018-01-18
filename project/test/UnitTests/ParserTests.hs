module UnitTests.ParserTests (module UnitTests.ParserTests) where

import           Correct.BitWiseOperation.Steps
import           Correct.ClassAssign.Steps
import           Correct.ClassMethods.Steps
import           Correct.DoWhile.Steps
import           Correct.EmptyClass.Steps
import           Correct.ForLoop.Steps
import           Correct.InstanceOf.Steps
import           Correct.InstanzVariable.Steps
import           Correct.LocalVariable.Steps
import           Correct.LogicOperations.Steps
import           Correct.MethodCall.Steps
import           Correct.NewClass.Steps
import           Correct.ShortIf.Steps
import           Correct.SimpleIf.Steps
import           Correct.SwitchCase.Steps
import           Correct.WhileLoop.Steps
import           Correct.WhileLoopCondition.Steps
import           Utils.SUnit

parserTests :: [TestUnit]
parserTests = [ParserUnit "Correct/EmptyClass" emptyABS,
               ParserUnit "Correct/InstanzVariable" instanzVariableABS,
               ParserUnit "Correct/ClassAssign" classAssignABS,
               ParserUnit "Correct/ClassMethods" classMethodsABS,
               ParserUnit "Correct/ForLoop" forLoopABS,
               ParserUnit "Correct/LocalVariable" localVariableABS,
               ParserUnit "Correct/SimpleIf" simpleIfABS,
               ParserUnit "Correct/ShortIf" shortIfABS,
               ParserUnit "Correct/SwitchCase" switchCaseABS,
               ParserUnit "Correct/WhileLoop" whileLoopABS,
               ParserUnit "Correct/WhileLoopCondition" whileLoopConditionABS,
               ParserUnit "Correct/DoWhile" doWhileABS,
               ParserUnit "Correct/LogicOperations" logicOperationsABS,
               ParserUnit "Correct/BitWiseOperation" bitWiseOperationABS,
               ParserUnit "Correct/NewClass" newClassABS,
               ParserUnit "Correct/InstanceOf" instanceOfABS,
               ParserUnit "Correct/MethodCall" methodCallABS,
               ParserException "Wrong/Arithmetic" emptyABS
               ]
