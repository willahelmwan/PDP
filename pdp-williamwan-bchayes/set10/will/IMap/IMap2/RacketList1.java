// Constructor template for RacketList1
//   new UTC1 (h, m)
// Interpretation:
//   h is the hour (0 <= h < 24)
//   m is the minute (0 <= m < 60)

class RacketList1<E> implements RacketList<E> {
	
	// RacketList<E> fields
	
	E f; 				// first element
	RacketList1<E> r;	// rest of elements
	int size;			// size of list as NonNegInt
	
	// RacketList<E> Constructor - empty list
	
	public RacketList1() {
		this.f = null;
		this.r = null;
		this.size = 0;
	}
	
	// RacketList<E> Constructor - single element
	
	public RacketList1(E x) {
		this.f = x;
		this.r = null;
		this.size = 1;
	}
	
	// RacketList<E> Constructor - cons of 1 element with another list
	
	public RacketList1(E x, RacketList1<E> r) {
		this.f = x;
		this.r = r;
		this.size = r.size() + 1;
	}

    // Is this list empty?
	
    public boolean isEmpty () {
		if (this.f == null) {
			return true;
		} else {
			return false;
		}
	} 

    // WHERE: this list is non-empty
    // RETURNS: first element of this list

    public E first () {
		// skelleton
		return this.f;
	}

    // WHERE: this list is non-empty
    // RETURNS: rest of this list

    public RacketList1<E> rest () {
		// skelleton
		return this.r;
	}

    // GIVEN: an arbitrary value x of type E
    // RETURNS: a list whose first element is x and whose
    //     rest is this list

    public RacketList1<E> cons (E x) {
		return new RacketList1<E>(x, this);
	}
	
	public int size() {
		return this.size();
	}
	
	// Returns true iff isEqual is true
	public boolean equals (RacketList<E> rl) {
		return this.isEqual(rl);
	}	
	
	// Returns true iff the given UTC is equal to this UTC.
    public boolean isEqual (RacketList<E> rl) {
		return RacketLists.isEqual(this, rl);
	}
	
	
	// RETURNS: hashCode for RacketList<E>
	public int hashCode() {
		return RacketLists.hashCode(this);
	}
	
	// RETURNS: string representation of RacketList
	public String toString() {
		return RacketLists.toString(this);	
	}
}