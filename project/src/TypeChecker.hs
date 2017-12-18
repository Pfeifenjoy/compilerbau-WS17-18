module TypeChecker where

import ABSTree

-- local variable table
type LocVarTable = [(String, Type)] 

-- MAIN TYPECHECK FUNCTION
checkTypes :: [Class] -> [Class]
checkTypes abs = []

-- TYPECHECK EXPRESSIONS:
-------------------------
typeCheckExpr :: Expr -> LocVarTable -> [Class] -> Expr
-- handling literals 
typeCheckExpr expr@(BooleanLiteral _) _ _ = TypedExpr expr "boolean"
typeCheckExpr expr@(CharLiteral _)    _ _ = TypedExpr expr "char"
typeCheckExpr expr@(IntegerLiteral _) _ _ = TypedExpr expr "integer"
-- handling unary operators
typeCheckExpr (Unary operator operandExpr) tbl cls = 
    let typedOperandExpr = typeCheckExpr operandExpr tbl cls
        operandType = getTypeFromTypedExpr typedOperandExpr
        typedUnaryExpr = Unary operator typedOperandExpr
    in case operandType of
        "integer" -> if operator `elem` ["+", "-", "++", "--"]
                     then TypedExpr typedUnaryExpr "integer"
                     else error "Operand type not compatible"
        "boolean" -> if operator == "!"
                     then TypedExpr typedUnaryExpr "boolean"
                     else error "Operand type not compatible"
        other     -> error "Unknown unary operator"
-- handling binary operators
typeCheckExpr (Binary operator operandExprA operandExprB) tbl cls =
    let typedOperandExprA = typeCheckExpr operandExprA tbl cls
        typedOperandExprB = typeCheckExpr operandExprB tbl cls
        operandTypeA = getTypeFromTypedExpr typedOperandExprA
        operandTypeB = getTypeFromTypedExpr typedOperandExprB
        typedBinaryExpr = Binary operator typedOperandExprA typedOperandExprB
    in case (operandTypeA, operandTypeB) of
        ("integer", "integer") -> if operator `elem` ["+", "-", "*", "/", "%"]
                                  then TypedExpr typedBinaryExpr "integer"
                                  -- TODO: null handling: (bla == null)?
                                  else if operator `elem` [">", "<", ">=", "<=", "=="]
                                       then TypedExpr typedBinaryExpr "boolean"
                                       else error "Operand types not compatible"
        ("boolean", "boolean") -> if operator `elem` ["&&", "||"]
                                  then TypedExpr typedBinaryExpr "boolean"
                                  else error "Operand types not compatible"
        _                      -> error "Unknown binary operator"
-- handling ternary operator
typeCheckExpr (Ternary operandExprA operandExprB operandExprC) tbl cls =
    let typedOperandExprA = typeCheckExpr operandExprA tbl cls
        typedOperandExprB = typeCheckExpr operandExprB tbl cls
        typedOperandExprC = typeCheckExpr operandExprC tbl cls
        operandTypeA = getTypeFromTypedExpr typedOperandExprA
        operandTypeB = getTypeFromTypedExpr typedOperandExprB
        operandTypeC = getTypeFromTypedExpr typedOperandExprC
    in if operandTypeA == "boolean"
       -- TODO: type/class hierarchy ? 
       then if operandTypeB == operandTypeC
            then TypedExpr (Ternary typedOperandExprA 
                                    typedOperandExprB
                                    typedOperandExprC)
                           operandTypeB
            else error "..."
       else error "..."
-- handling this
typeCheckExpr This tbl cls =
    -- TODO: correct handling of this ?
    let maybeTypeOfThis = lookup "this" tbl
    in case maybeTypeOfThis of
        Just typeOfThis -> TypedExpr This typeOfThis
        Nothing         -> error "'this' can not be referrenced"
-- handling local/field variables
typeCheckExpr expr@(LocalOrFieldVar varName) tbl cls = 
    let maybeVarType = lookup varName tbl
    in case maybeVarType of
        Just varType -> TypedExpr expr varType
        Nothing      -> error "..."   
-- handling instance variables
typeCheckExpr (InstVar instanceExpr varName) tbl cls =
    let typedInstanceExpr = typeCheckExpr instanceExpr tbl cls
        instanceType      = getTypeFromTypedExpr typedInstanceExpr
    in case classLookup instanceType cls of
        Nothing            -> error "..."
        Just instanceClass -> 
            case classFieldTypeLookup varName instanceClass of
                Nothing          -> error "..."
                Just instVarType ->
                    TypedExpr (InstVar typedInstanceExpr varName) instVarType
-- handling statement expressions
typeCheckExpr (StmtExprExpr stmtExpr) tbl cls = 
    let typedStmtExpr = typeCheckStmtExpr stmtExpr tbl cls
        stmtExprType = getTypeFromTypedStmtExpr typedStmtExpr
    in TypedExpr (StmtExprExpr typedStmtExpr) stmtExprType                   
-- handling null
typeCheckExpr JNull _ _ = TypedExpr JNull "void"
-- handling already type expressions
typeCheckExpr (TypedExpr _ _) _ _ =
    error "Trying to typecheck an already typechecked expression"

-- TYPECHECKER EXPRESSION STATEMENTS
typeCheckStmtExpr :: StmtExpr -> LocVarTable -> [Class] -> StmtExpr
typeCheckStmtExpr = undefined

-- TYPECHECK STATEMENTS
checkStmt :: Stmt -> LocVarTable -> [Class] -> Stmt
checkStmt = undefined

-- HELPER FUNCTIONS:
-- lookup a certain type in a list of classes
classLookup :: Type -> [Class] -> Maybe Class
classLookup _         []     = Nothing
classLookup t (cl@(Class s _ _):cls) | t == s = Just cl
                                     | otherwise = classLookup t cls

-- lookup the type of a fieldname in a class
classFieldTypeLookup :: String -> Class -> Maybe Type
classFieldTypeLookup varName (Class _ fieldDecList _) =
    let publicFieldDecList = filter (\(FieldDecl _ vis _) -> vis == Public) 
                                    fieldDecList
    in fieldDecListLookup $ publicFieldDecList
    where
        -- TODO: Multiple entries possible (???)
        fieldDecListLookup [] = Nothing
        fieldDecListLookup ((FieldDecl varDecList _ _):xs) =
            case filter (\(VariableDecl fieldName _ _ _) -> fieldName == varName)
                        varDecList
            of
                [(VariableDecl _ fieldType _ _)] -> Just fieldType 
                _                                -> Nothing 

-- extract type from typed expression
getTypeFromTypedExpr :: Expr -> Type
getTypeFromTypedExpr (TypedExpr _ exprType) = exprType

-- extract type from type statement expression
getTypeFromTypedStmtExpr :: StmtExpr -> Type
getTypeFromTypedStmtExpr (TypedStmtExpr _ stmtExprType) = stmtExprType