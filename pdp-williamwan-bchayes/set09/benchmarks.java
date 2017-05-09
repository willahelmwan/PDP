import java.util.*;

public class benchmarks {
	
	public static void main(String[] args) {
		
		String reportText = "";
		long start,end;
		
		// Set local varaibles for flight lists
		RacketList<Flight> panAmFlights = FlightExamples.panAmFlights;
		
		RacketList<Flight> deltaFlights = FlightExamples.deltaFlights;

		RacketList<Flight> deltaCycle = FlightExamples.deltaCycle;
		
		// quick test of canGetThere
		System.out.println("canGetThere Testing");
		System.out.println("LGA to PDX using deltaFlights -> " + 
							Schedules.canGetThere("LGA","PDX",deltaFlights));
		System.out.println("LGA to NNN using deltaFlights -> " + 
							Schedules.canGetThere("LGA","NNN",deltaFlights));
		System.out.println("LGA to LGA using panAmFlights -> " + 
							Schedules.canGetThere("LGA","LGA",panAmFlights));
		System.out.println("LGA to PDX using panAmFlights -> " + 
							Schedules.canGetThere("LGA","PDX",panAmFlights));
		
		// canGetThere Benchmark
		System.out.println("Delta Flights - canGetThere");
		System.out.println(everyAirportBenchmark(deltaFlights, 
													"canGetThere", false));
		
		// quick test of fastestItinerary
		System.out.println("Delta Flights - fastestItinerary");
		System.out.println(everyAirportBenchmark(deltaFlights, 
													"fastestItinerary",false));
		
		// quick test of travelTime
		System.out.println("Delta Flights - travelTime");
		System.out.println(everyAirportBenchmark(deltaFlights, 
													"travelTime", false));
		
		// benchmark2 from set08 faculty testing - canGetThere
		
		reportText = runBenchmark("benchmark2", 20, "canGetThere", false);
		System.out.println(reportText);
		
		// benchmark2 from set08 faculty testing
		reportText = runBenchmark("benchmark2", 20, "fastestItinerary", false);
		System.out.println(reportText);
		
		// benchmark2 from set08 faculty testing
		reportText = runBenchmark("benchmark2", 20, "travelTime", false);
		System.out.println(reportText);
		
	}
	
	// GIVEN: a list of flights, and function name
	// WHERE function name is either canGetThere, fastestItinerary or travelTime
	// RETURNS: report after processing canGetThere from every airport in the 
	//          list, to every airport in the list NxN
	public static String everyAirportBenchmark(RacketList<Flight> flights, 
												String func, boolean report) {
		
		long start,end;
		
		String reportText = "";
		String data = "";
		
		RacketList<String> uniqueAirports = FlightH.uniqueAirportNames(flights);
		
		if (report) {
			reportText += "-------------------------------------------------\n";
			reportText += "Benchmark of " + func + " method, testing against\n";
			reportText += "all combinations of flights in the given list \n";
			reportText += "of flights.\n\n";
			reportText += "List of Airports  : " + uniqueAirports.toString();
			reportText += "\n";
			reportText += "Number of Flights : " + 
								RacketListH.size(uniqueAirports) + "\n\n"; 
		}

		RacketList<String> iterator1 = uniqueAirports;
		RacketList<String> iterator2;
		
		start = System.currentTimeMillis();
		while(!iterator1.isEmpty()) {
			iterator2 = uniqueAirports;
			while(!iterator2.isEmpty()) {
				if (report) {
					reportText += "     ";
					reportText += iterator1.first() + " to ";
					reportText += iterator2.first();
					reportText += " -> ";
				}
				if (func.equals("canGetThere")) {
					data += Schedules.canGetThere(iterator1.first(), 
													iterator2.first(), 
													flights);
				} else if (func.equals("fastestItinerary")) {
					data += Schedules.fastestItinerary(iterator1.first(), 
													iterator2.first(), 
													flights);					
				} else if (func.equals("travelTime")) {
					data += Schedules.travelTime(iterator1.first(), 
													iterator2.first(), 
													flights);
				}
				
				if (report) {
					reportText += data;
					reportText += "\n";
				}
				
				iterator2 = iterator2.rest();
			}
			iterator1 = iterator1.rest();
		}
		end = System.currentTimeMillis();
		
		reportText += "everyAirportBenchmark: " + (end-start) + " ms \n";
		
		if (report) {		
			reportText += "-------------------------------------------------\n";
		}
		return reportText;
	}
	
	public static String runBenchmark(String benchmark, int n, 
												String func, boolean report) {
		String reportText = "";
		for(int i=0; i<= n; i++) {
			if (benchmark.equals("benchmark2")) {
				reportText += "Benchmark2: N=" + i + " using " + func + "\n";
				reportText += everyAirportBenchmark(makeStressTest2(i), 
																func, report);
			}
		}
		return reportText;
	}
	
	public static RacketList<Flight> makeStressTest2 (int n) {
	
		RacketList<Flight> testFlights = RacketLists.empty();
		
		RacketList<String> airports = makeAirports(n);
		
		testFlights = makeFlights(airports);
	
		return testFlights;
	}
	
	public static RacketList<String> makeAirports(int n) {
		RacketList<String> airports = RacketLists.empty();
		for(int i=n; i>0; i--) {
			airports = airports.cons("AP"+ (i+100));
		}
		return airports;
	}
	
	public static UTC randomUTC1(String s1, String s2) {
		Random r = new Random();
		return UTCs.make(r.nextInt(23), r.nextInt(59));
	}
	
	public static UTC randomUTC2(String s1, String s2) {
		Random r = new Random();
		return UTCs.make(r.nextInt(23), r.nextInt(59));
	}
	
	public static Flight makeRandomFlight(String ap1, String ap2) {
		return Flights.make( ap1 + ap2, 
							 ap1,
							 ap2,
							 randomUTC1(ap1, ap2),
							 randomUTC2(ap1, ap2));
	}
	
	public static RacketList<Flight> makeFlights(RacketList<String> airports) {
		
		RacketList<Flight> newFlights = RacketLists.empty();
		RacketList<String> iterator1 = airports;
		RacketList<String> iterator2 = airports;
			
		while(!iterator1.isEmpty()) {
			iterator2 = airports;
			while(!iterator2.isEmpty()) {
				if (!iterator1.first().equals(iterator2.first())) {
					newFlights = newFlights.cons( makeRandomFlight(
													iterator1.first(), 
													iterator2.first()));
				}
				iterator2 = iterator2.rest();
			}
			iterator1 = iterator1.rest();
		}
		
		return newFlights;
	
	}	
}
