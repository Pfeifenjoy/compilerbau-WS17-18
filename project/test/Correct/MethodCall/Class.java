class B {
	int getInt() {
		return 1;
	}
}

class MethodCall {
	int getInt() {
		B b = new B();

		return b.getInt();
	}
}