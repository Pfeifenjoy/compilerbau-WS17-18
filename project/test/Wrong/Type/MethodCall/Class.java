class A {
	int i = 3;

	int getI() {
		return i;
	}
}

class B {

	char doStuff() {
		A a = new A();

		return a.getI();
	}
}