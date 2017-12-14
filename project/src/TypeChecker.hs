module TypeChecker where

import ABSTree

-- local variable table
type LocVarTable = [(String, Type)] 

-- main typecheck function
checkTypes :: [Class] -> [Class]
checkTypes abs = undefined

-- typechecks expressions
checkExpr :: Expr -> LocVarTable -> [Class] -> Expr
checkExpr = undefined

-- typechecks statements
checkStmt :: Stmt -> LocVarTable -> Class -> Stmt
checkStmt = undefined 