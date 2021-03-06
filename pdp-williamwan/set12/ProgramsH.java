
import java.util.*;
import java.lang.*;

class ProgramsH {

	// GIVEN: an environment
	// EFFECT: Display's contents of environment in console
	public static void outputMap(Map<String,ExpVal> env) {
		if (debugOn()) {
			// output environment for debugging
			System.out.println("Environment Output :");
			for(Map.Entry<String,ExpVal> e : env.entrySet()) {
				if (e.getValue()!=null) {
					System.out.println("  " + e.getKey() + " => " + 
									   e.getValue().toString());
				} else {
					System.out.println("  " + e.getKey() + " => NULL");
				}
			}
			
			if (false) {
				try {
					System.in.read();
				} catch (Exception ex) {}
			}
		}
	}

	// RETURNS: true iff we should see debugging info
	private static boolean debugOn() {
		return false;
	}
}