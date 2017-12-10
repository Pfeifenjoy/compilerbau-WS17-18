module ABSTree where

import Data.Int

data Type
    = ComplexType { typeName :: String } --complex type (e.g. Class name)
    | ArrayType Type --Array
    -- primitive types
    | Boolean
    | Byte
    | Char
    | Integer
    | Long
    | Float
    | Double
    deriving(Eq, Show)

-- Statements
data Expr
    = This
    | Super
    -- variables
    | LocalOrFieldVar String
    | InstVar Expr String
    -- operators
    | Unary String Expr
    | Binary String Expr Expr
    | Ternary { ternCondition :: Expr, ternThen :: Expr, ternElse :: Expr }
    --literals
    | BooleanLiteral Bool
    | ByteLiteral Int8
    | CharLiteral Char
    | IntegerLiteral Int32
    | LongLiteral Int64
    | FloatLiteral Float
    | DoubleLiteral Double
    | StringLiteral String
    | JNull
    -- other
    | StmtExprExpr StmtExpr
    deriving(Eq, Show)

data StmtExpr = Assign Expr Expr
    | New { stmtExprType :: Type, arguments :: [Expr] }
    | MethodCall Expr String [Expr]
    deriving(Eq, Show)

data Stmt = Block [Stmt]
    -- Function Statments
    | Return Expr
    -- Loop Statements
    | While { condition:: Expr, statement :: Stmt }
    | DoWhile { condition:: Expr, statement :: Stmt }
    | For { start :: Stmt, condition :: Expr, next :: Stmt, statement :: Stmt }
    | Break
    | Continue
    -- Conditional Statements
    | If { condition :: Expr, thenStmt :: Stmt, elseStmt :: (Maybe Stmt) }
    -- other
    | LocalVarDecl { localVarType :: Type, localVarName :: String }
    | StmtExprStmt StmtExpr
    deriving(Eq, Show)

-- Classes
data FieldDecl = FieldDecl {
        fieldType :: Type,
        fieldName :: String
    }
    deriving(Eq, Show)

data ArgumentDecl = ArgumentDecl {
        argumentType :: Type,
        argumentName :: String
    }
    deriving(Eq, Show)

type ArgumentDecls = [ArgumentDecl]

data MethodDecl = MethodDecl {
        methodName :: String,
        methodReturnType :: Type,
        methodArguments :: ArgumentDecls,
        body :: Stmt
    }
    deriving(Eq, Show)

data Class = Class Type [FieldDecl] [MethodDecl]
    deriving(Eq, Show)

