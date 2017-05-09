
public class Schedules {
	
	// Constants
	private static int MAXTIME = 999999;
	private static int MINUTESINHOUR = 60;
	private static int HOURSINDAY = 24;

	// GIVEN: the names of two airports, ap1 and ap2 (respectively),
	//     and a RacketList<Flight%gt; that describes all of the flights a
	//     traveller is willing to consider taking
	// RETURNS: true if and only if it is possible to fly from the
	//     first airport (ap1) to the second airport (ap2) using
	//     only the given flights
	// EXAMPLES:
	//     canGetThere ("06N", "JFK", FlightExamples.panAmFlights)  =>  false
	//     canGetThere ("JFK", "JFK", FlightExamples.panAmFlights)  =>  true
	//     canGetThere ("06N", "LAX", FlightExamples.deltaFlights)  =>  false
	//     canGetThere ("LAX", "06N", FlightExamples.deltaFlights)  =>  false
	//     canGetThere ("LGA", "PDX", FlightExamples.deltaFlights)  =>  true

	public static boolean canGetThere (String ap1,
									   String ap2,
									   RacketList<Flight> flights) {
										   
		RacketList<String> travelledAirports = RacketLists.empty();
		RacketList<String> currentAirports = RacketLists.empty();
		currentAirports = currentAirports.cons(ap1);
										   
		return hasPath(travelledAirports, currentAirports, ap2, flights);
		
	}
			
	// GIVEN: the names of two airports, ap1 and ap2 (respectively),
	//     and a RacketList<Flight> that describes all of the flights a
	//     traveller is willing to consider taking
	// WHERE: it is possible to fly from the first airport (ap1) to
	//     the second airport (ap2) using only the given flights
	// RETURNS: a list of flights that tells how to fly from the
	//     first airport (ap1) to the second airport (ap2) in the
	//     least possible time, using only the given flights
	// NOTE: to simplify the problem, your program should incorporate
	//     the totally unrealistic simplification that no layover
	//     time is necessary, so it is possible to arrive at 1500
	//     and leave immediately on a different flight that departs
	//     at 1500
	// EXAMPLES:
	//     fastestItinerary ("JFK", "JFK", FlightExamples.panAmFlights)
	//         =>  RacketLists.empty()
	//
	//     fastestItinerary ("LGA", "PDX", FlightExamples.deltaFlights)
	// =>  RacketLists.empty().cons
	//         (Flights.make ("Delta 2163",
	//                        "MSP", "PDX",
	//                        UTCs.make (15, 0), UTCs.make (19, 2))).cons
	//             (Flights.make ("Delta 0121",
	//                            "LGA", "MSP",
	//                            UTCs.make (11, 0),
	//                            UTCs.make (14, 9)))
	//
	// (Note: The Java syntax for a method call makes those calls
	// to cons look backwards from what you're used to in Racket.)

	public static
		RacketList<Flight> fastestItinerary (String ap1,
											 String ap2,
											 RacketList<Flight> flights) {
												 								 
		RacketList<Flight> emptyLOF = RacketLists.empty();
		RacketList<Flight> canFlyThere;
		RacketList<Flight> fastest;
		RacketList<Node> d;
		RacketList<RacketList<Flight>> pi;
		
		RacketList<Node> graph;
		int graphLength = 0;
			
		if (ap1 == ap2) {
			return emptyLOF;
		} else {
			graph = createGraph(flights, ap1);
			graphLength = RacketListH.length(graph);
			d = dijkstras(graph, graphLength);
			pi = possibleItineraries(d, ap2);
			
			if (pi.isEmpty()) {
				return emptyLOF;
			} else {
				fastest = bestRoute(pi);
				if (fastest.isEmpty()) {
					return emptyLOF;
				} else {
					return fastest;
				}
			}
		}
	}
	
	// GIVEN: the names of two airports, ap1 and ap2 (respectively),
	//     and a RacketList<Flight> that describes all of the flights a
	//     traveller is willing to consider taking
	// WHERE: it is possible to fly from the first airport (ap1) to
	//     the second airport (ap2) using only the given flights
	// RETURNS: the number of minutes it takes to fly from the first
	//     airport (ap1) to the second airport (ap2), including any
	//     layovers, by the fastest possible route that uses only
	//     the given flights
	// EXAMPLES:
	//     travelTime ("JFK", "JFK", FlightExamples.panAmFlights)  =>  0
	//     travelTime ("LGA", "PDX", FlightExamples.deltaFlights)  =>  482

	public static int travelTime (String ap1,
								  String ap2,
								  RacketList<Flight> flights) {
		
		RacketList<Flight> fi = fastestItinerary(ap1, ap2, flights);
		
		if (fi.isEmpty()) {
			return 0;
		} else {
			return journeyTime(fi);
		}
	}
	
	// -------------------------------------------------------------------------
	// HELPER FUNCTIONS - for can-get-there?
	// -------------------------------------------------------------------------
	
	// hasPath : ListOfString ListOfString String ListOfFlight -> Boolean
    // GIVEN: 	a list of travelled airport names, current airport names,
	//		  	destination name and list of flights
	// RETURNS: true iff destination is a member of current airports
	private static boolean hasPath (RacketList<String> travelledAirports,
									RacketList<String> currentAirports,
									String des,
									RacketList<Flight> flights) {
								
		boolean reachable = false;
		
		RacketList<String> nextTravelledAP;
		RacketList<String> nextCurrentAP;
		
		if (RacketListH.member(des, currentAirports)) {
			return true;
		} else if (currentAirports.isEmpty()) {
			return false;
		} else {
			
			nextTravelledAP = nextTravelledAirports( travelledAirports, 
													 currentAirports );

			nextCurrentAP = nextCurrentAirports ( currentAirports,
												  nextTravelledAP,
												  flights);
												 
			reachable = hasPath( nextTravelledAP, 
								 nextCurrentAP, 
								 des,
								 flights);
		}
	
		return reachable;
	}
	
	// nextTravelledAirports : ListOfString ListOfString -> ListOfString
	// GIVEN: a list of travelled airports, and a list of current airports
	// RETURNS: the union of the two lists
	private static RacketList<String> nextTravelledAirports (
										RacketList<String> travelledAirports,
										RacketList<String> currentAirports) {
											
		RacketList<String> nextTravelled 
			= RacketListH.append( travelledAirports, currentAirports );
		
		return nextTravelled;

	}
	
	// arrivalAirports : ListOfFlight -> ListOfString
	// GIVEN: a list of flights
	// RETURNS: the name of the arrival airports
	private static RacketList<String> arrivalAirports(
												RacketList<Flight> flights) {
		RacketList<String> arrivals = RacketLists.empty();
		RacketList<Flight> itr = flights;
		while(itr.first() != null) {
			arrivals = RacketListH.listCons(itr.first().arrives(), 
											arrivals);
			itr = itr.rest();
		}
		
		return arrivals;
	}
	
	// departureFlights : String ListOfFlight -> ListOfFlight
	// GIVEN: the source and a list of flights
	// RETURNS: flights with the same departs as source
	private static RacketList<Flight> departureFlights(String source, 
												RacketList<Flight> flights) {
		RacketList<Flight> itr = flights;
		RacketList<Flight> departures = RacketLists.empty();
		
		while(itr.first()!=null) {
			if (itr.first().departs().equals(source)) {
				departures = departures.cons( itr.first() );
			}
			itr = itr.rest();
		}
		
		return departures;
	}
	
	// childrenAp : ListOfString ListOfFlight -> ListOfString
	// GIVEN: an airport name and a list of flights
	// RETURNS: List of airport names reachable from the airport given 
	//          using the list of flights (as a direct flight)
	private static RacketList<String> childrenAp(
										String currentAirport,
										RacketList<Flight> availableFlights) {
		return arrivalAirports(
					departureFlights(currentAirport, availableFlights));
	}
	
	// allChildrenAp : ListOfString ListOfFlight -> ListOfString
	// GIVEN: a list of airport names, and a list of flights
	// RETURNS: a list of all destination airports reachable from
	//          current airports
	private static RacketList<String> allChildrenAp(
										RacketList<String> currentAirports,
										RacketList<Flight> availableFlights) {
		
		RacketList<String> destinations = RacketLists.empty();
		
		RacketList<String> itr = currentAirports;
		while(itr.first() != null) {
			destinations = RacketListH.listUnion( childrenAp(itr.first(), 
															 availableFlights),
												  destinations );
			itr = itr.rest();
		}
		
		return destinations;
	}

	// nextCurrentAirports
	// GIVEN: A list of currently reachable airports, and a list of currently 
	//        travelled airports
	// RETURNS: A list of airports we can get too, that we have not already been
	private static RacketList<String> nextCurrentAirports(
										RacketList<String> currentAirports,
										RacketList<String> haveTravelledTo,
										RacketList<Flight> flights) {
											
		return RacketListH.listDiff( allChildrenAp( currentAirports, flights ), 
									 haveTravelledTo );
	}
	
	// -------------------------------------------------------------------------
	// HELPER FUNCTIONS - for fastestItinerary
	// -------------------------------------------------------------------------

	// createGraph: ListofFlight ListofFlight String -> ListofNode
	// GIVEN: A Listofflight, same ListofFlight and the source airport
	// RETURNS: A graph to use for applying dijkstra's algorithm	
	private static RacketList<Node> createGraph(RacketList<Flight> flights,
											   String source) {
		// variables
		RacketList<Flight> emptyLOF;
		RacketList<Flight> departures;
		RacketList<Node> graph = RacketLists.empty();
		
		// iterator 
		RacketList<Flight> iterator = flights;
		
		// while iterator is not empty (go one by one through flights)
		while(!iterator.isEmpty()) {
			
			// define an empty List of Flight
			emptyLOF = RacketLists.empty();
			
			// get departures flights from the current flights arrival airport
			departures = getAirportDepartures(flights, 
												   iterator.first().arrives());
												   						   
			// if current airport (iterator) departs from source
			if (iterator.first().departs().equals(source)) {
				// create current location node
				graph = graph.cons(
							Nodes.make(iterator.first(), 
							  emptyLOF.cons(iterator.first()),
							  departures,
							  FlightH.flightTime(iterator.first()),
							  false));
			} else {
				// create other nodes
				graph = graph.cons(
							Nodes.make(iterator.first(), 
							  emptyLOF,
							  departures,
							  MAXTIME,
							  false));	
			}
			
			// set iterator to rest
			iterator = iterator.rest();
		}
		
		return graph;
    }
	
	// getAirportDepartures : ListOfFlight String -> ListOfFlight
	// GIVEN: a list of flights and an airport name
	// RETURNS: a list of flights departing that particular airport	
	private static RacketList<Flight> getAirportDepartures(
													RacketList<Flight> flights,
													String airportName) {
		// departures is empty
		RacketList<Flight> departures = RacketLists.empty();
		
		// set iterator to flight
		RacketList<Flight> iterator = flights;
		
		// FILTER
		// go through flights, departs matches airportName add to departures
		while(!iterator.isEmpty()) {
			if (iterator.first().departs().equals(airportName)) {
				departures = departures.cons(iterator.first());
			}
			iterator = iterator.rest();
		}
		
		return departures;
													
    }
	
	// minimumNode: ListofNode -> Node
	// GIVEN: A listofNode  
	// RETURNS: Node with minimum travel-time value from the list	
	private static Node minimumNode(RacketList<Node> lon) {
	
		Node minNode = null;
		int minValue = MAXTIME + 1;

		RacketList<Node> iterator = lon;
		
		while(!iterator.isEmpty()) {
			
			if (!iterator.first().visited()) {
				if (iterator.first().travellingTime() < minValue) {
					minValue = iterator.first().travellingTime();
					minNode = iterator.first();
				}
			}
			
			iterator = iterator.rest();
		}
		
		return minNode;
	}
	
	// modifyLONForNode: Node ListofNode -> ListofNode
	// GIVEN: A Node and a listofNode  
	// RETURNS: a new list of node which has been adjusted by applying Dijsktra
	private static RacketList<Node> modifyLONForNode(Node node, 
													RacketList<Node> lon) {

		RacketList<Node> modLON = RacketLists.empty();
													
		// iterator
		RacketList<Node> iterator = lon;
		
		while(!iterator.isEmpty() && (node != null)) {
			
			// if current node from list, flight equals node argument's flight
			if (iterator.first().flight().equals(node.flight())) {
				modLON = modLON.cons (Nodes.make( iterator.first().flight(),
										 iterator.first().path(),
										 iterator.first().outboundFlights(),
										 iterator.first().travellingTime(),
										 true));
			} else if (RacketListH.member(iterator.first().flight(), 
													node.outboundFlights())) {
				modLON = modLON.cons( 
							outboundAfterModification( node, iterator.first()));
			} else {
				modLON = modLON.cons (iterator.first());
			}
			
			iterator = iterator.rest();
		}
		
		return modLON;		
	}
	
	// outboundAfterModification: Node Node -> Node
	// GIVEN: A Node and the node corresponding to one of its outbound-flights 
	// RETURNS: Modify the outbound Node by updating its path
	//         and travelling-time values
	private static Node outboundAfterModification(Node node1, Node node2) {
		
		RacketList<Flight> emptyLOF = RacketLists.empty();
		RacketList<Flight> node1path = node1.path();
		
		int journeyTime = nodeJourneyTime(node1, node2);
		
		if ((node2.visited()) || (node2.travellingTime() <= journeyTime)) {
			return node2;
		} else {
			return Nodes.make(node2.flight(),
							  node1path.cons(node2.flight()),
							  node2.outboundFlights(),
							  journeyTime,
							  node2.visited());
		}
		
	}
	
	// nodeJourneyTime : Node Node -> NonNegInt
	// GIVEN: two nodes
	// RETURNS: the total journey time based on the two nodes including travel 
	//          time and time of flight and layover time.
	private static int nodeJourneyTime (Node node1, Node node2) {
		
		int journeyTime = 0;
		
		journeyTime = node1.travellingTime();
		journeyTime += FlightH.flightTime(node2.flight());
		journeyTime += FlightH.layoverTime(node1.flight(), node2.flight());
	
		return journeyTime;
	}
	
	// dijkstras: ListofNode NonNegInt -> ListofNode
	// GIVEN: A listofNode and its length 
	// RETURNS: A ListofNode after applying Dijkstra's to it
	private static RacketList<Node> dijkstras(RacketList<Node> lon, int len) {
		
		Node minNode;
		RacketList<Node> modifiedLON;
		
		long start,end;
		
		if (len == 0) {
			return lon;
		} else {
			// get minimum node O(n)
			minNode = minimumNode(lon);
			
			// get modified LON O(n^2 + n)
			modifiedLON = modifyLONForNode(minNode, lon);
			
			// recurisve until len = 0
			return dijkstras(modifiedLON, (len-1));
		}
	}
	
	
	// possible-itineraries : ListofNode String ->  ListOfListOfFlight
	// GIVEN: a graph representing the listofflights passed to fastest-itinerary
	//        and arrival airport ap2 
	// RETURNS: a ListOfListOfFlight which represents each possible itineraries
	//          from ap1 to ap2
	private static RacketList<RacketList<Flight>> possibleItineraries(
									RacketList<Node> graph,
									String destination) {
	
		RacketList<RacketList<Flight>> itineraries = RacketLists.empty();
		
		RacketList<Node> iterator = graph;
		
		while(!iterator.isEmpty()) {
			
			if (iterator.first().flight().arrives().equals(destination)) {
				itineraries = itineraries.cons (iterator.first().path());
			}
			
			iterator = iterator.rest();
		}
		
		return itineraries;
	}
	
	// journey-time : ListofFlight -> NonNegInt
	// GIVEN: A Non-empty list of flights for a particular itinerary
	// RETURNS: the travel time for that journey in minutes	
	private static int journeyTime(RacketList<Flight> flights) {
		
		int journey = 0;
		
		if (flights.rest().isEmpty()) {
			
			return FlightH.flightTime(flights.first());
			
		} else {
			
			journey += FlightH.flightTime(flights.first());
			journey += FlightH.layoverTime(flights.rest().first(), 
										   flights.first());
			journey += journeyTime(flights.rest());
			
			return journey;
		}
	}
	
	// bestRoute : ListOfListOfFlight -> ListOfFlight
	// GIVEN: a list of list of flights (or list of itineraries)
	// RETURNS: the fastest itinerary
	private static RacketList<Flight> bestRoute(
								RacketList<RacketList<Flight>> itineraries) {

		int fTime = 999999;
		int jTime = 0;
		RacketList<Flight> fastest = null;
		
		RacketList<RacketList<Flight>> iterator = itineraries;
		
		while(!iterator.isEmpty()) {
			jTime = journeyTime(iterator.first());
			if (jTime < fTime) {
				fTime = jTime;
				fastest = iterator.first();
			}
			iterator = iterator.rest();
		}
		
		return fastest;
		
	}
}