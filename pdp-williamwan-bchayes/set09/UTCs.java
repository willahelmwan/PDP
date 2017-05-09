// UTCs Factory Class for managing UTC

public class UTCs {
	
	// GIVEN: the hour in [0,23] and the minute in [0,59]
	// RETURNS: a UTC with that hour and minute
	public static UTC make (int h, int m) {
		return new UTC1(h,m);
	}
	
	// Returns true iff the given UTC is equal to this UTC
	public static boolean isEqual(UTC u1, UTC u2) {
		if ((u1.hour()==u2.hour())&&(u1.minute()==u2.minute())) {
			return true;
		} else {
			return false;
		}
	}
	
	// Returns hashCode for a given UTC
	public static int hashCode (UTC t) {
		return 100 * t.hour() + t.minute();
	}	
	
	// Returns a string representation of the UTC
	public static String toString(UTC t) {
		return t.hour()+":"+t.minute();
	}
	
	// main class for running unit tests
	public static void main (String[] args) {
		UTCsTests.main(args);	
	}
}

// Unit Testing Class
class UTCsTests {
	
	public static void main (String[] args) {

        // We'll do these tests several times, to increase the
        // probability that objects of different classes will be created.

        int NTESTS = 5;    // how many times we'll run each test

        for (int i = 0; i < NTESTS; i = i + 1) {
            UTC t0000 = UTCs.make (0, 0);      // always test boundary cases
            UTC t0059 = UTCs.make (0, 59);
            UTC t2300 = UTCs.make (23, 0);
            UTC t2359 = UTCs.make (23, 59);
            UTC t1531 = UTCs.make (15, 31);    // and test typical cases

            assert t0000.hour() == 0    : "wrong hour for t0000";
            assert t0000.minute() == 0  : "wrong minute for t0000";
            assert t0059.hour() == 0    : "wrong hour for t0059";
            assert t0059.minute() == 59 : "wrong minute for t0059";
            assert t2300.hour() == 23   : "wrong hour for t2300";
            assert t2300.minute() == 0  : "wrong minute for t2300";
            assert t2359.hour() == 23   : "wrong hour for t2359";
            assert t2359.minute() == 59 : "wrong minute for t2359";
            assert t1531.hour() == 15   : "wrong hour for t1531";
            assert t1531.minute() == 31 : "wrong minute for t1531";

            assert t0000.isEqual(t0000) : "isEqual says t0000 != t0000";
            assert t0059.isEqual(t0059) : "isEqual says t0059 != t0059";
            assert t2300.isEqual(t2300) : "isEqual says t2300 != t2300";
            assert t2359.isEqual(t2359) : "isEqual says t2359 != t2359";
            assert t1531.isEqual(t1531) : "isEqual says t1531 != t1531";

            assert t0000.isEqual(UTCs.make(0, 0))   : "t0000 != t0000";
            assert t0059.isEqual(UTCs.make(0, 59))  : "t0059 != t0059";
            assert t2300.isEqual(UTCs.make(23, 0))  : "t2300 != t2300";
            assert t2359.isEqual(UTCs.make(23, 59)) : "t2359 != t2359";
            assert t1531.isEqual(UTCs.make(15, 31)) : "t1531 != t1531";

            assert ! (t0000.isEqual(t0059)) : "isEqual says t0000 = t0059";
            assert ! (t0059.isEqual(t2359)) : "isEqual says t0059 = t2359";
            assert ! (t2359.isEqual(t2300)) : "isEqual says t2359 = t2300";

            // tests of the usual triumvirate

            assert t0000.equals(t0000) : "equals says t0000 != t0000";
            assert t0059.equals(t0059) : "equals says t0059 != t0059";
            assert t2300.equals(t2300) : "equals says t2300 != t2300";
            assert t2359.equals(t2359) : "equals says t2359 != t2359";
            assert t1531.equals(t1531) : "equals says t1531 != t1531";

            assert t0000.equals(UTCs.make(0, 0))   : "t0000 != t0000";
            assert t0059.equals(UTCs.make(0, 59))  : "t0059 != t0059";
            assert t2300.equals(UTCs.make(23, 0))  : "t2300 != t2300";
            assert t2359.equals(UTCs.make(23, 59)) : "t2359 != t2359";
            assert t1531.equals(UTCs.make(15, 31)) : "t1531 != t1531";

            assert ! (t0000.equals(t0059)) : "equals says t0000 = t0059";
            assert ! (t0059.equals(t2359)) : "equals says t0059 = t2359";
            assert ! (t2359.equals(t2300)) : "equals says t2359 = t2300";

            assert ! (t0000.equals(null))  : "equals says t0000 = null";
            assert ! (t0059.equals("foo")) : "equals says t0059 = a string";

            assert t0000.hashCode() == (UTCs.make(0, 0).hashCode());
            assert t0059.hashCode() == (UTCs.make(0, 59).hashCode());
            assert t2300.hashCode() == (UTCs.make(23, 0).hashCode());
            assert t2359.hashCode() == (UTCs.make(23, 59).hashCode());
            assert t1531.hashCode() == (UTCs.make(15, 31).hashCode());

            assert t0000.toString().equals(UTCs.make(0, 0).toString());
            assert t0059.toString().equals(UTCs.make(0, 59).toString());
            assert t2300.toString().equals(UTCs.make(23, 0).toString());
            assert t2359.toString().equals(UTCs.make(23, 59).toString());
            assert t1531.toString().equals(UTCs.make(15, 31).toString());
        }

        System.out.println ("UTCs tests passed.");
    }
}