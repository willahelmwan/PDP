// Constructor template for Node1
//   new Node1 (flight, path, outboundFlights, travellingTime, visited)
// Interpretation:
//   flight is the current flight represented by the node
//   path is the path of flights to the destination
//   outboundFlights is the flights departing from this flights arrival airport
//   travellingTime is the time spent travelling 
//   visited is true iif this airport has been visited

public class Node1 implements Node {

	// Node1 fields	
	
	Flight flight;
	RacketList<Flight> path;
	RacketList<Flight> outboundFlights;
	int travellingTime;
	boolean visited;
	
	// Node1 Constructor
	
	public Node1(Flight flight, 
				 RacketList<Flight> path,
				 RacketList<Flight> outboundFlights,
				 int travellingTime,
				 boolean visited) {
					 
		this.flight = flight;
		this.path = path;
		this.outboundFlights = outboundFlights;
		this.travellingTime = travellingTime;
		this.visited = visited;
	}
	
	// Node1 public methods
	
	// RETURNS: the flight represented by the node
	public Flight flight() {
		return this.flight;
	}
	
	// RETURNS: path of flights 
	public RacketList<Flight> path() {
		return this.path;
	}
	
	// RETURNS: list of outboundFlights leaving arrival airport for node flight
	public RacketList<Flight> outboundFlights() {
		return this.outboundFlights;
	}
	
	// RETURNS: NonNegInt representing the travelling time including layover
	public int travellingTime() {
		return this.travellingTime;
	}
	
	// RETURNS: true iff the current node's flight arrival has 
	//          already been visited
	public boolean visited() {
		return this.visited;
	}
	
	// RETURNS: string representation of a node
	public String toString() {
		return Nodes.toString(this);
	}
	
	// RETURNS: unique hash code for node
	public int hashCode() {
		return Nodes.hashCode(this);
	}
	
	// RETURNS: true iff isEqual is true
	public boolean equals (Object x) {
		if (x instanceof Node) {
			Node n2 = (Node) x;
			return isEqual(n2);
		}
		else return false;
	}
	
    // RETURNS: true iff the given Node is equal to this Node.
    public boolean isEqual (Node n2) {
		return Nodes.isEqual(this, n2);
	}
}