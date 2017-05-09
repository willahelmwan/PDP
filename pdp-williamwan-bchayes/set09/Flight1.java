// Constructor template for Flight1:
//    new Flight1(name, departs, arrives, departsAt, arrivesAt)
// Interpretation:
//    name - name of the flight (Ex. Delta 1232)
//    departs - name of the airport the flight is departing (Ex. LGA)
//    arrives - name of the airport the flight is arriving (Ex. BOS)
//    departsAt - UTC time the flight is departing
//    arrivesAt - UTC time the flight is arriving

public class Flight1 implements Flight {
	
	// Flight1 Fields
	
	String name;		// flight name
	String departs;		// departing airport name
	String arrives;		// arriving airport name
	UTC departsAt;		// departing UTC time
	UTC arrivesAt;		// arriving UTC time
	
	// Flight1 Constructor
	public Flight1 (String name, String departs, String arrives, 
					UTC departsAt, UTC arrivesAt) {
		this.name = name;
		this.departs = departs;
		this.arrives = arrives;
		this.departsAt = departsAt;
		this.arrivesAt = arrivesAt;
	}
	
	// Flight1 Public Methods
	
	// RETURNS: the name of this flight.
	public String name() {
		return this.name;
	}
	
	// RETURNS: the name of the airport from which this flight departs.
	public String departs() {
		return this.departs;
	}
	
	// RETURNS: the name of the airport at which this flight arrives.
	public String arrives() {
		return this.arrives;
	}
	
	// RETURNS: the time at which this flight departs.
	public UTC departsAt() {
		return this.departsAt;
	}
	
	// RETURNS: the time at which this flight arrives.
	public UTC arrivesAt() {
		return this.arrivesAt;
	}
	
	// RETURNS: true iff isEqual is true
	public boolean equals (Object x) {
		if (x instanceof Flight) {
			Flight f = (Flight) x;
			return isEqual(f);
	}
		else return false;
	}
	
    // RETURNS: true iff the given UTC is equal to this UTC.
    public boolean isEqual (Flight f) {
		return Flights.isEqual(this, f);
	}
	
	// RETURNS: unique hash code for flight
	public int hashCode () {
		return Flights.hashCode(this);
	}
	
	// RETURNS: string representation of flight
	public String toString() {
		return Flights.toString(this);
	}	
}