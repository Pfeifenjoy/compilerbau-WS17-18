class Fib {

	int getFib(int n) {
		if(n < 2) {
			return n;
		}
		else {
			return this.getFib(n-1) + this.getFib(n-2);
		}
	}
}

