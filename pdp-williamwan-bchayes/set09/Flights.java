// Flights Factory Class for managing Flight

public class Flights {

	// GIVEN: the name of a flight, the name of the airport from
	//     which the flight departs, the name of the airport at
	//     which the flight arrives, the time of departure in UTC,
	//     and the time of arrival in UTC
	// RETURNS: a flight value that encapsulates the given information
	public static Flight make (String s, String ap1, String ap2,
							   UTC t1, UTC t2) {
		return new Flight1 (s,ap1,ap2,t1,t2);
	}

	// GIVEN: the name of a flight, the name of the airport from
	//     which the flight departs, the name of the airport at
	//     which the flight arrives, the time of departure in hours/minutes,
	//     and the time of arrival in hours/minutes
	// RETURNS: a flight value that encapsulates the given information	
	public static Flight make (String s, String ap1, String ap2,
							   int t1hour, int t1minute, 
							   int t2hour, int t2minute) {
		return new Flight1 (s,ap1,ap2,
							UTCs.make(t1hour,t1minute),
							UTCs.make(t2hour,t2minute));
	}
	
	// RETURNS: true iff this flight and the given flight
    //          have the same name
    //          depart from the same airport
    //          arrive at the same airport
    //          depart at the same time
    //          and arrive at the same time
	public static boolean isEqual (Flight f1, Flight f2) {
		if ((f1.name()==f2.name()) &&
			(f1.departs()==f2.departs()) &&
			(f1.arrives()==f2.arrives()) &&
			(f1.departsAt().isEqual(f2.departsAt())) &&
			(f1.arrivesAt().isEqual(f2.arrivesAt()))) {
			return true;
		} else {
			return false;
		}
	}
	
	// RETURNS: a string representation of the Flight
	public static String toString(Flight f) {
		
		String flightString = "[" + f.name() + " ";
		flightString += f.departs() + "-" + f.arrives() + " ";
		flightString += "D:" + f.departsAt().toString() + " ";
		flightString += "A:" + f.arrivesAt().toString() + "]";
			
		return  flightString;
	}

	// RETURNS: hashCode for a given Flight
	public static int hashCode (Flight f) {
		return f.toString().hashCode();
	}

	// main class for running unit tests
	public static void main (String[] args) {
		FlightsTests.main(args);	
	}	
}

class FlightsTests {
	
	public static void main (String[] args) {
	
        // We'll do these tests several times, to increase the
        // probability that objects of different classes will be created.

        int NTESTS = 5;    // how many times we'll run each test

        for (int i = 0; i < NTESTS; i = i + 1) {
			
			Flight LGAMSP = Flights.make( "Delta 1234","LGA","MSP", 
											UTCs.make(11,0),UTCs.make(14,9));
			Flight MSPDEN = Flights.make( "Delta 1235","MSP","DEN", 
											UTCs.make(20,35),UTCs.make(22,52));
			Flight DENLAX = Flights.make( "Delta 1236","DEN","LAX", 
											UTCs.make(14,4),UTCs.make(17,15));
			Flight LAXPDX = Flights.make( "Delta 1237","LAX","PDX", 
											UTCs.make(17,35),UTCs.make(20,9));
			Flight MSPPDX = Flights.make( "Delta 1238","MSP","PDX", 
											UTCs.make(15,0),UTCs.make(19,2));
			
			Flight MIDNIGHT = Flights.make( "Delta 0000","BOS","NYC", 
											UTCs.make(0,0), UTCs.make(23,59));
			Flight NOON = Flights.make("Delta 9999","NYC","BOS", 
											UTCs.make(23,59), UTCs.make(0,0));
			
			assert LGAMSP.name() == "Delta 1234" 
								: "LGAMSP.name() should return 'Delta 1234'";
			assert LGAMSP.departs().equals("LGA") 
								: "LGAMSP.departs() should return 'LGA'";
			
			
			assert MIDNIGHT.departsAt().equals(UTCs.make(0,0)) 
								: "MIDNIGHT.departsAt() should be UTC(0,0)";
			assert MIDNIGHT.arrivesAt().equals(UTCs.make(23,59)) 
								: "MIDNIGHT.arrivesAt() should be UTC(23,59)";
			assert NOON.departsAt().equals(UTCs.make(23,59)) 
								: "NOON.departsAt() should be UTC(23,59)";
			assert NOON.arrivesAt().equals(UTCs.make(0,0)) 
								: "NOON.arrivesAt() should be UTC(0,0)";
			
		}
		
		System.out.println ("UTCs tests passed.");
	}
}