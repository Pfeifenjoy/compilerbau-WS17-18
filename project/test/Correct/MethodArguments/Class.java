class A {
	int a;

	public A(int a) {
		this.a = a;
	}

	int multiply(int b, int c) {
		return(this.a * b * c);
	}
}

class B {
	int call() {
		A a = new A(5);

		return a.multiply(3,2);

	}
}e