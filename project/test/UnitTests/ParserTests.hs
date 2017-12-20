module UnitTests.ParserTests (module UnitTests.ParserTests) where

import           BitWiseOperation.Steps
import           ClassAssign.Steps
import           ClassMethods.Steps
import           DoWhile.Steps
import           EmptyClass.Steps
import           ForLoop.Steps
import           InstanzVariable.Steps
import           LocalVariable.Steps
import           LogicOperations.Steps
import           NewClass.Steps
import           ShortIf.Steps
import           SimpleIf.Steps
import           SwitchCase.Steps
import           Utils.SUnit
import           WhileLoop.Steps
import           WhileLoopCondition.Steps

parserTests :: [TestUnit]
parserTests = [ParserUnit "EmptyClass" emptyABS,
               ParserUnit "InstanzVariable" instanzVariableABS,
               ParserUnit "ClassAssign" classAssignABS,
               ParserUnit "ClassMethods" classMethodsABS,
               ParserUnit "ForLoop" forLoopABS,
               ParserUnit "LocalVariable" localVariableABS,
               ParserUnit "SimpleIf" simpleIfABS,
               ParserUnit "ShortIf" shortIfABS,
               ParserUnit "SwitchCase" switchCaseABS,
               ParserUnit "WhileLoop" whileLoopABS,
               ParserUnit "WhileLoopCondition" whileLoopConditionABS,
               ParserUnit "DoWhile" doWhileABS,
               ParserUnit "Arithmetic" emptyABS,
               ParserUnit "LogicOperations" logicOperationsABS,
               ParserUnit "BitWiseOperation" bitWiseOperationABS,
               ParserUnit "NewClass" newClassABS
               ]
