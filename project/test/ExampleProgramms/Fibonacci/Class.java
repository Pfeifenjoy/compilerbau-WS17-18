class Fibonacci {
	int getFib(int n) {
		return (n < 2) ? n : getFib(n-1) + getFib(n-2);
	}
}