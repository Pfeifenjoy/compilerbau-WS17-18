Class("ClassMethod", 
	[FieldDecl("int", "i")], 
	[MethodDecl("int", "getInt", [], Return(Integer(1))),
	 MethodDecl("int", "returnInt", [("int", "x")], Return(LocalOrFieldVar("x"))),
	 MethodDecl("void", "doStuff", [], Return(LocalOrFieldVar("i")))
	])