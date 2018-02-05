class Faculty {
	int fac(int n) {
		return (n < 3) ? n : n * fac(n-1);
	}
}