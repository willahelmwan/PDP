// Constructor template for UTC1
//   new UTC1 (h, m)
// Interpretation:
//   h is the hour (0 <= h < 24)
//   m is the minute (0 <= m < 60)

class UTC1 implements UTC {

	// UTC1 Fields
	
	int h;	// the hour, limited to [0,23]
	int m;  // the minute, limited to [0,59]
	
	// Constants
	
	// number of minutes in an hour
	private static final int MINUTESINHOUR = 60;
	
	// UTC1 Constructor
	
	UTC1 (int h, int m) {
		this.h = h;
		this.m = m;
	}

	// UTC1 Public Methods

	// returns the hour (0 <= hour < 24)
	public int hour() {
		return this.h;
	}

	// returns the minute (0 <= minute < 60)
	public int minute() {
		return this.m;
	}
	
	// Returns true iff isEqual is true
	public boolean equals (Object x) {
		if (x instanceof UTC) {
			UTC t2 = (UTC) x;
			return isEqual(t2);
		}
		else return false;
	}
	
    // Returns true iff the given UTC is equal to this UTC.
    public boolean isEqual (UTC t2) {
		return UTCs.isEqual(this, t2);
	}

	// Returns the hashCode for UTC
	public int hashCode () {
		return UTCs.hashCode (this);
	}

	// Returns string reprsentation of object
	public String toString() {
		return UTCs.toString(this);
	}
	
	// main function for calling tests
	public static void main (String[] args) {
		UTC1tests.main(args);
	}
}

// UTC1tests will be used to test the UTC1 implementation of UTC
class UTC1tests {
	
	public static void main (String[] args) {
		UTC t1 = new UTC1 (15, 31);
		UTC t2 = new UTC1 (14, 31);
		UTC t3 = new UTC1 (15, 32);
		UTC t4 = new UTC1 (15, 31);

		assert t1.hour() == 0 : "wrong hour for t1";
		assert t1.minute() == 31 : "wrong minute for t1";

		assert t1.isEqual (t1) : "isEqual says this doesn't equal this";
		assert t1.isEqual (t4) : "isEqual says this doesn't equal that";
		assert ! (t1.isEqual (t2)) : "isEqual true but hour different";
		assert ! (t1.isEqual (t3)) : "isEqual true but minute different";

		System.out.println ("All unit tests of UTC1 passed.");
	}
	
}