module TypeChecker where

import ABSTree
import Data.Maybe 
import qualified Data.Map as Map

-- local variable table
type VarName = String
type MethodName = String
type FieldName = String
type Operator = String
type VisibleClassList = [Class]
type LocVarTable = Map.Map VarName Type
type FieldDecs = [FieldDecl]
type VarDecs = [VariableDecl]
type MethodDecs = [MethodDecl]


-- main typecheck function
checkTypes :: Program -> Program
checkTypes classList = 
    map (\currentClass -> checkClass currentClass classList) classList


-- typecheck a single class
checkClass :: Class -> VisibleClassList -> Class
checkClass (Class classType fieldDecs methodDecs) visibleClassList =
    let (typedFieldDecs, locVarTable) =
            typeCheckFieldDecs fieldDecs classType visibleClassList
        typedMethodDecs = 
            typeCheckMethodDecs methodDecs locVarTable visibleClassList        
    in (Class classType typedFieldDecs typedMethodDecs)


-- typecheck field declarations and create LocVarTable in the process
typeCheckFieldDecs :: FieldDecs 
                      -> Type 
                      -> VisibleClassList 
                      -> (FieldDecs, LocVarTable)
typeCheckFieldDecs fieldDecs thisType visibleClassList =
    foldl foldFieldDec ([], (Map.singleton "this" thisType)) fieldDecs
        where
            foldFieldDec (currentTypedFieldDecs, currentLocVarTable)
                         (FieldDecl varDecs visibility isStatic) =
                let (typedVarDecs, updatedLocVarTable) =
                        foldl foldVarDec ([], currentLocVarTable) varDecs
                    nextTypedFieldDec = 
                        (FieldDecl typedVarDecs visibility isStatic)
                    updatedTypedFieldDecs = 
                        currentTypedFieldDecs ++ [nextTypedFieldDec]
                in (updatedTypedFieldDecs, updatedLocVarTable)
            
            foldVarDec (currentTypedVarDecs, currentLocVarTable)
                       (VariableDecl varName varType isFinal maybeInitExpr) =
                let updatedLocVarTable = 
                        Map.insert varName varType currentLocVarTable
                    typedMaybeInitExpr =
                        fmap (\initValExpr -> typeCheckExpr initValExpr
                                                            currentLocVarTable
                                                            visibleClassList)
                             maybeInitExpr
                    nextTypedVarDec = VariableDecl varName 
                                                   varType 
                                                   isFinal 
                                                   typedMaybeInitExpr
                    updatedTypedVarDecs =
                        currentTypedVarDecs ++ [nextTypedVarDec]
                in case typedMaybeInitExpr of
                            Nothing -> 
                                (updatedTypedVarDecs, updatedLocVarTable)
                            Just (TypedExpr _ initExprType) ->
                                if initExprType == varType
                                then (updatedTypedVarDecs, updatedLocVarTable)
                                else error $ "Initialization of "
                                           ++ varType ++ " variable "
                                           ++ varName ++ " with type "
                                           ++ initExprType
                     
-- typecheck class method declarations
typeCheckMethodDecs :: MethodDecs 
                       -> LocVarTable 
                       -> VisibleClassList
                       -> MethodDecs
typeCheckMethodDecs methodDecs locVarTable visibleClassList =
    map (\method -> typeCheckMethod method locVarTable visibleClassList)
        methodDecs

-- typecheck a single class method
typeCheckMethod :: MethodDecl -> LocVarTable -> VisibleClassList -> MethodDecl
typeCheckMethod (MethodDecl name returnType argDecs body visibility isStatic)
                locVarTable
                visibleClassList =
    let argVarTable = 
            foldl (\currentArgVarTable -> 
                       \(ArgumentDecl argName argType _) ->
                           Map.insert argName argType currentArgVarTable)
                  Map.empty
                  argDecs
        shadowedLocVarTable =
            Map.union argVarTable locVarTable
        typedBody@(TypedStmt _ bodyType) =
            typeCheckStmt body shadowedLocVarTable visibleClassList
    in if bodyType == returnType
       then MethodDecl name returnType argDecs typedBody visibility isStatic
       else error $ "Bodytype " ++ bodyType ++ " and returnType "
                  ++ returnType ++ " of Function " ++ name 
                  ++ " do not match"
            

-- typecheck expressions
typeCheckExpr :: Expr -> LocVarTable -> [Class] -> Expr
typeCheckExpr This locVarTable visibleClassList =
    TypedExpr This (fromJust $ Map.lookup "this" locVarTable)
typeCheckExpr expr@(LocalOrFieldVar varName) locVarTable visibleClassList = 
    let maybeVarType = Map.lookup varName locVarTable
    in case maybeVarType of
        Just varType -> TypedExpr expr varType
        Nothing      -> error $ "Unknown variable " ++ varName
                                ++ " encountered"
typeCheckExpr (InstVar instExpr instVarName) locVarTable visibleClassList =
    let typedInstExpr@(TypedExpr _ instExprType) =
            typeCheckExpr instExpr locVarTable visibleClassList
    in case classLookup instExprType visibleClassList of
           Nothing -> error $ "Class " ++ instExprType ++ " not found"
           Just instClass ->
               case classFieldLookup instVarName instClass of
                   Nothing -> error $ "Class " ++ instExprType
                                      ++ " has no (visible) field "
                                      ++ instVarName
                   Just fieldType ->
                       TypedExpr (InstVar typedInstExpr instVarName)
                                 fieldType
typeCheckExpr (Unary operator operandExpr) locVarTable visibleClassList =
    let typedOperandExpr@(TypedExpr _ operandExprType) =
            typeCheckExpr operandExpr locVarTable visibleClassList
        possibleCombinations = [("!","boolean"),("+","int"),("-","int")
                               ,("++","int"),("--","int")]
    in if (operator, operandExprType) `elem` possibleCombinations
       then TypedExpr (Unary operator typedOperandExpr) operandExprType
       else error $ "Unary operator " ++ operator ++ " is not compatible with "
                    ++ "type " ++ operandExprType 
typeCheckExpr (Binary operator operandExprA operandExprB)
              locVarTable
              visibleClassList =
    let typedOperandExprA@(TypedExpr _ operandExprAType) =
            typeCheckExpr operandExprA locVarTable visibleClassList
        typedOperandExprB@(TypedExpr _ operandExprBType) =
            typeCheckExpr operandExprB locVarTable visibleClassList
        operandError = error $ "Operator " ++ operator ++ " can not be "
                               ++ "applied to types " ++ operandExprAType
                               ++ " and " ++ operandExprBType                               
        resultType = 
            case (operator, operandExprAType, operandExprBType) of
                     (op, "int", "int")
                         | op `elem` ["+","-","*","/","%"
                                     ,"&","|","^","<<",">>",">>>"] -> "int"
                         | op `elem` ["<=",">=","<",">"] -> "boolean"
                         | otherwise -> operandError 
                     (op, "boolean", "boolean")
                         | op `elem` ["||","&&"] -> "boolean"
                         | otherwise -> operandError
                     (op, operA, operB) 
                         | op `elem` ["==","!="] && operA == operB -> operA
                         | otherwise -> operandError
    in TypedExpr (Binary operator
                         typedOperandExprA
                         typedOperandExprB)
                 resultType                         
typeCheckExpr (InstanceOf instExpr proposedType)
              locVarTable
              visibleClassList =
    let typedInstExpr = 
            typeCheckExpr instExpr locVarTable visibleClassList
    in TypedExpr (InstanceOf typedInstExpr proposedType) "boolean"
typeCheckExpr (Ternary operandExprA operandExprB operandExprC)
              locVarTable
              visibleClassList =
    let typedOperandExprA@(TypedExpr _ operandExprAType) =
            typeCheckExpr operandExprA locVarTable visibleClassList
        typedOperandExprB@(TypedExpr _ operandExprBType) =
            typeCheckExpr operandExprB locVarTable visibleClassList
        typedOperandExprC@(TypedExpr _ operandExprCType) =
            typeCheckExpr operandExprC locVarTable visibleClassList
    in if operandExprAType == "boolean"
       then TypedExpr (Ternary typedOperandExprA
                               typedOperandExprB
                               typedOperandExprC)
                      (propagateSuperType operandExprAType
                                          operandExprBType)
       else error "First expression of ternary operator must be a boolean"
typeCheckExpr expr@(BooleanLiteral _) _ _ = TypedExpr expr "boolean"
typeCheckExpr expr@(CharLiteral _)    _ _ = TypedExpr expr "char"
typeCheckExpr expr@(IntegerLiteral _) _ _ = TypedExpr expr "int"
typeCheckExpr JNull _ _ = TypedExpr JNull "void"
typeCheckExpr (StmtExprExpr stmtExpr) locVarTable visibleClassList = 
    let typedStmtExpr@(TypedStmtExpr _ stmtExprType) =
            typeCheckStmtExpr stmtExpr locVarTable visibleClassList
    in TypedExpr (StmtExprExpr typedStmtExpr) stmtExprType
typeCheckExpr (TypedExpr _ _) _ _ =
    error "Trying to typecheck an already typechecked expression"

    
-- typecheck expression statements
typeCheckStmtExpr :: StmtExpr -> LocVarTable -> VisibleClassList -> StmtExpr
typeCheckStmtExpr (Assign leftValExpr rightValExpr) 
                  locVarTable 
                  visibleClassList =
    let typedLeftValExpr@(TypedExpr _ leftValExprType) =
            typeCheckExpr leftValExpr locVarTable visibleClassList
        typedRightValExpr@(TypedExpr _ rightValExprType) =
            typeCheckExpr rightValExpr locVarTable visibleClassList
    in TypedStmtExpr (Assign typedLeftValExpr
                             typedRightValExpr)
                     (propagateSuperType leftValExprType
                                         rightValExprType)
typeCheckStmtExpr (New newClassName argExprs) locVarTable visibleClassList =
    let typedArgExprs = 
            map (\argExpr -> typeCheckExpr argExpr
                                           locVarTable
                                           visibleClassList)
                argExprs
        argExprsTypes =
            map (\(TypedExpr _ argExprType) -> argExprType) typedArgExprs
    in case classLookup newClassName visibleClassList of
                Just newClass ->
                    case methodLookup newClassName newClass of
                             Just (MethodDecl _ retType argDecs _ Public _) ->
                                 if (==) argExprsTypes
                                         (map (\(ArgumentDecl _ argType _) ->
                                                   argType)
                                              argDecs)
                                 then TypedStmtExpr (New newClassName
                                                         typedArgExprs)
                                                    newClassName
                                 else error $ "Constructor arguments not "
                                            ++ " matching"
                             Nothing -> error "Constructor not found"
                Nothing -> error $ "Specified Class "
                                 ++ newClassName ++ " not found"                
typeCheckStmtExpr (MethodCall instExpr methodName argExprs)
                  locVarTable
                  visibleClassList =
    let typedInstExpr@(TypedExpr _ instExprType) =
            typeCheckExpr instExpr locVarTable visibleClassList
        typedArgExprs =
            map (\argExpr -> 
                     typeCheckExpr argExpr locVarTable visibleClassList)
                argExprs
        argExprsTypes =
            map (\(TypedExpr _ argExprType) -> argExprType) typedArgExprs
    in case classLookup instExprType visibleClassList of
                Just instClass -> 
                    case methodLookup methodName instClass of
                             Just (MethodDecl _ retType argDecs _ Public _) ->
                                 if (==) argExprsTypes
                                         (map (\(ArgumentDecl _ argType _) ->
                                                   argType)
                                              argDecs)
                                 then TypedStmtExpr (MethodCall typedInstExpr
                                                                methodName
                                                                typedArgExprs)
                                                    retType
                                 else error "Function arguments don't match" 
                                             
                             _ -> error $ "Method " ++ methodName
                                        ++ " not found or not visible"
                Nothing -> error $ "Class " ++ instExprType
                                 ++ " could not be found"
typeCheckStmtExpr (LazyAssign leftValExpr rightValExpr)
                  locVarTable
                  visibleClassList =
    let TypedStmtExpr (Assign typedLeftValExpr typedRightValExpr) assignType =
            typeCheckStmtExpr (Assign leftValExpr rightValExpr)
                              locVarTable
                              visibleClassList
    in TypedStmtExpr (LazyAssign typedLeftValExpr typedRightValExpr) assignType
typeCheckStmtExpr (TypedStmtExpr _ _) _ _ =
    error "Trying to typecheck an already typechecked statement expression"

    
-- typecheck statements (blocks)
typeCheckStmt :: Stmt -> LocVarTable -> VisibleClassList -> Stmt
typeCheckStmt (Block blockStmts) locVarTable visibleClassList =
    TypedStmt (Block typedBlockStmts) blockType
        where
            (typedBlockStmts, _, blockType) =
                foldl foldBlockSegment ([], locVarTable, "void") blockStmts
            
            foldBlockSegment (currentTypedBlockStmts
                             ,currentLocVarTable
                             ,currentBlockType)
                             nextBlockStmt =
                let (typedNextBlockStmt@(TypedStmt _ nextBlockType)
                     ,updatedLocVarTable) = 
                        typeCheckStmtLocVarTransform nextBlockStmt 
                                                     currentLocVarTable
                                                     visibleClassList
                    updatedTypedBlockStmts =
                        currentTypedBlockStmts ++ [typedNextBlockStmt]
                    updatedBlockType =
                        propagateSuperType nextBlockType currentBlockType
                in (updatedTypedBlockStmts
                   ,updatedLocVarTable
                   ,updatedBlockType)
typeCheckStmt (Return returnExpr) locVarTable visibleClassList =
   let typedReturnExpr@(TypedExpr _ returnExprType) =
           typeCheckExpr returnExpr locVarTable visibleClassList
   in TypedStmt (Return typedReturnExpr) returnExprType
typeCheckStmt (While condExpr whileStmt) locVarTable visibleClassList =
   let typedCondExpr@(TypedExpr _ condExprType) =
           typeCheckExpr condExpr locVarTable visibleClassList
       typedWhileStmt@(TypedStmt _ whileStmtType) =
           typeCheckStmt whileStmt locVarTable visibleClassList
   in if (condExprType == "boolean")
      then TypedStmt (While typedCondExpr typedWhileStmt) whileStmtType
      else error "Conditional expression must be a boolean"
typeCheckStmt (DoWhile condExpr doWhileExpr) locVarTable visibleClassList =
   let (TypedStmt (While typedCondExpr typedDoWhileExpr) doWhileExprType) =
           typeCheckStmt (While condExpr doWhileExpr)
                         locVarTable
                         visibleClassList
   in TypedStmt (DoWhile condExpr doWhileExpr) doWhileExprType
typeCheckStmt (For initStmt condExpr iterStmt bodyStmt)
              locVarTable
              visibleClassList =
    let (typedInitStmt, updatedLocVarTable) =
            typeCheckStmtLocVarTransform initStmt
                                         locVarTable
                                         visibleClassList
        typedCondExpr@(TypedExpr _ condExprType) =
            typeCheckExpr condExpr updatedLocVarTable visibleClassList
        (typedIterStmt, updatedUpdatedLocVarTable) =
            typeCheckStmtLocVarTransform iterStmt
                                         locVarTable
                                         visibleClassList
        typedBodyStmt@(TypedStmt _ bodyStmtType) =
            typeCheckStmt bodyStmt updatedUpdatedLocVarTable visibleClassList
    in if condExprType == "boolean"
       then TypedStmt (For typedInitStmt 
                           typedCondExpr 
                           typedIterStmt
                           typedBodyStmt)
                      bodyStmtType
       else error "Conditional expression in for loop must have boolean type"
typeCheckStmt Break _ _ = TypedStmt Break "void"
typeCheckStmt Continue _ _ = TypedStmt Continue "void"
typeCheckStmt (If condExpr thenStmt maybeElseStmt)
              locVarTable 
              visibleClassList =
    let typedCondExpr@(TypedExpr _ condExprType) =
            typeCheckExpr condExpr locVarTable visibleClassList
        typedThenStmt@(TypedStmt _ thenStmtType) =
            typeCheckStmt thenStmt locVarTable visibleClassList
        typedMaybeElseStmt =
            fmap (\elseStmt -> 
                      typeCheckStmt elseStmt locVarTable visibleClassList)
                 maybeElseStmt
    in if condExprType == "boolean"
       then TypedStmt (If typedCondExpr typedThenStmt typedMaybeElseStmt)
                      (case typedMaybeElseStmt of
                           Just (TypedStmt _ elseStmtType) ->
                               propagateSuperType thenStmtType elseStmtType
                           Nothing -> thenStmtType)
       else error "Conditional expression in if clause must have boolean type"
typeCheckStmt (Switch switchExpr switchCases maybeDefaultCaseStmts)
              locVarTable
              visibleClassList =
    let typedSwitchExpr@(TypedExpr _ switchExprType) =
            typeCheckExpr switchExpr locVarTable visibleClassList
        (typedSwitchCases, switchCasesType) =
            typeCheckSwitchCases switchExprType
                                 switchCases
                                 locVarTable
                                 visibleClassList
    in undefined
typeCheckStmt (StmtExprStmt stmtExpr) locVarTable visibleClassList =
    let typedStmtExpr@(TypedStmtExpr _ stmtExprType) =
            typeCheckStmtExpr stmtExpr locVarTable visibleClassList
    in TypedStmt (StmtExprStmt typedStmtExpr) "void"
typeCheckStmt (TypedStmt _ _) _ _ =
    error "Trying to typecheck an already typechecked statement"

              
-- typecheck statements and transform LocVarTable in the process
typeCheckStmtLocVarTransform :: Stmt
                                -> LocVarTable 
                                -> VisibleClassList 
                                -> (Stmt, LocVarTable)
typeCheckStmtLocVarTransform (LocalVarDecls varDecs)
                             locVarTable
                             visibleClassList =
    let (typedVarDecs, updatedLocVarTable) =
            typeCheckVarDecs varDecs locVarTable visibleClassList
    in (TypedStmt (LocalVarDecls typedVarDecs) "void", updatedLocVarTable)
typeCheckStmtLocVarTransform stmt locVarTable visibleClassList =
    (typeCheckStmt stmt locVarTable visibleClassList, locVarTable) 

-- HELPER FUNCTIONS:
-- typeCheck variable declarations and update LocVarTable in the process
typeCheckVarDecs :: VarDecs 
                    -> LocVarTable 
                    -> VisibleClassList 
                    -> (VarDecs, LocVarTable)
typeCheckVarDecs varDecs locVarTable visibleClassList =
    foldl foldVarDec ([], locVarTable) varDecs
        where 
            foldVarDec (currentTypedVarDecs, currentLocVarTable)
                       (VariableDecl varName varType isFinal maybeInitExpr) =
                let updatedLocVarTable =
                        if Map.member varName currentLocVarTable 
                        then error $ "Variable " ++ varName ++ " already"
                                   ++ " exists in scope"
                        else Map.insert varName varType currentLocVarTable
                    typedMaybeInitExpr =
                        fmap (\initValExpr -> typeCheckExpr initValExpr
                                                            currentLocVarTable
                                                            visibleClassList)
                             maybeInitExpr
                    nextTypedVarDec = VariableDecl varName 
                                                   varType 
                                                   isFinal 
                                                   typedMaybeInitExpr
                    updatedTypedVarDecs =
                        currentTypedVarDecs ++ [nextTypedVarDec]
                    
                in (updatedTypedVarDecs, updatedLocVarTable)
typeCheckSwitchCases = undefined

-- looks up a filed in a class
classFieldLookup :: FieldName -> Class -> Maybe Type
classFieldLookup searchedfieldName (Class _ fieldDecs _) =
   fieldDecsLookup fieldDecs
       where
           fieldDecsLookup [] = Nothing
           fieldDecsLookup ((FieldDecl varDecs Public _):fs) =
               case varDecsLookup varDecs of
                        Nothing -> fieldDecsLookup fs
                        res -> res
           fieldDecsLookup (f:fs) = fieldDecsLookup fs
           
           varDecsLookup [] = Nothing
           varDecsLookup ((VariableDecl varName varType _ _):vs)
               | varName == searchedfieldName = Just varType
               | otherwise = varDecsLookup vs               

-- looks up a class in a currently visible class list
classLookup :: Type -> VisibleClassList -> Maybe Class
classLookup _         []     = Nothing
classLookup t (cl@(Class s _ _):cls) | t == s = Just cl
                                     | otherwise = classLookup t cls
                                     
-- looks up a method in a class
methodLookup :: MethodName -> Class -> Maybe MethodDecl
methodLookup searchedMethodName (Class classType _ methodDecs) =
    methodDecLookup methodDecs
    where
        methodDecLookup (m@(MethodDecl methodName _ _ _ _ _): ms)
            | searchedMethodName == methodName = Just m
            | otherwise = methodDecLookup ms
        methodDecLookup [] = Nothing

-- propagates the supertype of two types
propagateSuperType :: Type -> Type -> Type
propagateSuperType "void" typeB = typeB
propagateSuperType typeA "void" = typeA
propagateSuperType typeA typeB
    | typeA == typeB = typeA
    | otherwise = error $ "Types " ++ typeA ++ " and " ++ typeB
                        ++ " are not compatible"