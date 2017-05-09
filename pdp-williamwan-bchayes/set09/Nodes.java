
public class Nodes {
	
	// GIVEN: a flight, two list of flights, a number of minutes and true/false
	// RETURNS: a Node object
	public static Node make (Flight flight, 
							 RacketList<Flight> path,
							 RacketList<Flight> outboundFlights,
							 int travellingTime,
							 boolean visited) {
					 
		return new Node1(flight, 
						 path, 
						 outboundFlights, 
						 travellingTime, 
						 visited);
	}
	
	// RETURNS: true iff two nodes are equal
	public static boolean isEqual(Node n1, Node n2) {
		if (n1.toString().equals(n2.toString())) {
			return true;
		} else {
			return false;
		}
	}

	// RETURNS: a string representation of a Node
	public static String toString(Node n) {
		String s = "";
		
		s = "{";
		s += n.flight().toString() + "\n";
		s += n.path().toString() + "\n";
		s += n.outboundFlights().toString() + "\n";
		s += n.travellingTime() + " minutes\n";
		s += "Visited? " + n.visited();
		s += "}\n";
		
		return s;
	}
	
	// RETURNS: unqiue hash code for node
	public static int hashCode(Node n) {
		return n.toString().hashCode();
	}
	
}