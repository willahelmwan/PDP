// Returns the alternating sum of the first n squares, computed ITERS times.
//
// Result is
//
//     n*n - (n-1)*(n-1) + (n-2)*(n-2) - (n-3)*(n-3) + ...
//
// Usage:
//
//     java Sumsq N ITERS

class Sumsq2 {

    public static void main (String[] args) {
        long n = Long.parseLong (args[0]);
        long iters = Long.parseLong (args[1]);
        System.out.println (mainLoop (n, iters));
    }

    // Modify this method to use loop syntax instead of tail recursion.
	
	// Old mainLoop method //
	/* static long mainLoop (long n, long iters) {
        if (iters == 0)
            return 0-1;
        else if (iters == 1)
            return sumSquares (n);
        else {
            sumSquares (n);
            return mainLoop (n, iters - 1);
        }
    } */
	
	static long mainLoop (long n, long iters) {
        if (iters == 0)
            return 0-1;
        else{
			while (iters != 1) {
				sumSquares (n);
				iters = iters - 1;
			}
			return sumSquares (n);
		}
    }

    // Returns alternating sum of the first n squares.

    static long sumSquares (long n) {
        return sumSquaresLoop (n, 0);
    }

    // Modify the following methods to use loop syntax
    // instead of tail recursion.

    // Returns alternating sum of the first n+1 squares, plus sum.

	// Old sumSquareLoop method
    /* static long sumSquaresLoop (long n, long sum) {
        if (n < 2)
            return sum + n * n;
        else return sumSquaresLoop2 (n - 1, sum + n * n);
    } */
	
	static long sumSquaresLoop (long n, long sum) {
        while (n > 1) {
			sum = sum + n * n - (n-1) * (n-1);
			n = n - 2;
		}
		return sum;
    } 

    // Returns alternating sum of the first n+1 squares,
    // minus (n+1)^2, plus sum.

	// Old sumSquareLoop2 method
    /* static long sumSquaresLoop2 (long n, long sum) {
        if (n < 2)
            return sum - n * n;
        else return sumSquaresLoop (n - 1, sum - n * n);
    } */
	
	static long sumSquaresLoop2 (long n, long sum) {
        while (n > 1) {
			sum = sum - n * n + (n-1) * (n-1);
			n = n - 2;
		}
		return sum;
    } 
}
