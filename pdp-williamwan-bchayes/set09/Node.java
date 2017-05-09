// A Node is an object of any class that implements Node
//
// Interpretation: A Node represetnts an element in a data strucuture
//                 that will be used to represent a flight and its 
//                 relationship to other data.

interface Node {

	// RETURNS: the flight represented by the node
	public Flight flight();
	
	// RETURNS: path of flights 
	public RacketList<Flight> path();
	
	// RETURNS: list of outboundFlights leaving arrival airport for node flight
	public RacketList<Flight> outboundFlights();
	
	// RETURNS: NonNegInt representing the travelling time including layover
	public int travellingTime();
	
	// RETURNS: true iff the current node's flight arrival has 
	//          already been visited
	public boolean visited();

}