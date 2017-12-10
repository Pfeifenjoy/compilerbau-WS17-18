module Compare where

type Type = String

data Class = Class(Type, [FieldDecl], [MethodDecl]) deriving(Eq, Show)
data FieldDecl = FieldDecl(Type, String) deriving(Eq, Show) 
data MethodDecl = MethodDecl(Type, String, [(Type, String)], Stmt) deriving(Eq, Show)
data Expr = This
    | Super
    | LocalOrFieldVar(String) 
    | InstVar(Expr, String) 
    | Unary(String, Expr) 
    | Binary(String, Expr, Expr) 
    | Integer(Integer) 
    | Bool(Bool) 
    | Char(Char) 
    | String(String) 
    | Jnull 
    | StmtExprExpr(StmtExpr) deriving(Eq, Show)

data Stmt = Block([Stmt])
    | Return( Expr ) 
    | While( Expr , Stmt ) 
    | LocalVarDecl( Type, String ) 
    | If( Expr, Stmt , Maybe Stmt ) 
    | StmtExprStmt(StmtExpr) deriving(Eq, Show)

data StmtExpr = Assign(Expr, Expr)
    | New(Type, [Expr])
    | MethodCall(Expr, String, [Expr]) deriving(Eq, Show)


main = print(Class("InstanzVariable", 
	[FieldDecl("int", "i"), 
	FieldDecl("boolean", "b"), 
	FieldDecl("char", "c")],
	[])) 

