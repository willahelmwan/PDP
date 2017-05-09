import java.lang.*;
import java.util.*;
import java.util.function.Consumer;

class bchayes {
	public static void main(String[] args) {

		String output = "";
		RacketList<Flight> deltaFlights = FlightExamples.deltaFlights;
		RacketList<Flight> deltaCycle = FlightExamples.deltaCycle;
		
		RacketList<Flight> set08Flights = RacketLists.empty();
		set08Flights = set08Flights.cons ( 
							Flights.make( "Delta 1234","LGA","MSP", 
											UTCs.make(11,0),UTCs.make(14,9)));
		set08Flights = set08Flights.cons ( 
							Flights.make( "Delta 1235","MSP","DEN", 
											UTCs.make(20,35),UTCs.make(22,52)));
		set08Flights = set08Flights.cons ( 
							Flights.make( "Delta 1236","DEN","LAX", 
											UTCs.make(14,4),UTCs.make(17,15)));
		set08Flights = set08Flights.cons ( 
							Flights.make( "Delta 1237","LAX","PDX", 
											UTCs.make(17,35),UTCs.make(20,9)));
		set08Flights = set08Flights.cons ( 
							Flights.make( "Delta 1238","MSP","PDX", 
											UTCs.make(15,0),UTCs.make(19,2)));

		RacketList<Flight> trip = RacketLists.empty();
		trip = trip.cons ( Flights.make( "Delta 1234","LGA","MSP", 
											UTCs.make(11,0),UTCs.make(16,9)));
		trip = trip.cons ( Flights.make( "Delta 1238","MSP","PDX", 
											UTCs.make(15,0),UTCs.make(19,2)));

		
		RacketList<Flight> fi = Schedules.fastestItinerary("LGA", "PDX", 
											set08Flights);
		System.out.println(fi);
		System.out.println(Schedules.travelTime("LGA","PDX", set08Flights));
	}

}