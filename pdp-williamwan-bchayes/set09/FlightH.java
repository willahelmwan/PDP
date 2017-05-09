// Helper class for Flight

public class FlightH {
	
	// RETURNS: returns duration of flight in minutes
	public static int flightTime(Flight f) {
		return UTCH.duration(f.departsAt(), f.arrivesAt());
	}
	
	// RETURNS: returns layover time between flights
	public static int layoverTime(Flight arrival, Flight departing) {
		return UTCH.duration(arrival.arrivesAt(), departing.departsAt());
	}
	
	// GIVEN: a list of flgihts
	// RETURNS: a list of all unique airport names 
	public static RacketList<String> uniqueAirportNames(
											RacketList<Flight> flights) {
												
		RacketList<String> uniqueAirports = RacketLists.empty();
		
		RacketList<Flight> iterator = flights;
		
		// dearture airports
		while(!iterator.isEmpty()) {
			uniqueAirports = RacketListH.listCons(iterator.first().departs(), 
																uniqueAirports);
			iterator = iterator.rest();
		}
		
		// dearture airports
		while(!iterator.isEmpty()) {
			uniqueAirports = RacketListH.listCons(iterator.first().arrives(), 
																uniqueAirports);
			iterator = iterator.rest();
		}
		
		return uniqueAirports;
	}
}