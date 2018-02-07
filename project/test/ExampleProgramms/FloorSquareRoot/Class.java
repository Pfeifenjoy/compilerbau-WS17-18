class FloorSquareRoot {

	int getFloorSquareRoot(int n) {
		int p = 1;

		while((p+1) * (p+1) <= n) {
			p++;
		}

		return p;
	}
}