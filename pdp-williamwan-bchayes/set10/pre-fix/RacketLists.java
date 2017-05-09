// The RacketLists class defines static methods for the RacketList<E>
//    type.
// In particular, it defines a static factory method for creating
//    the empty list of the RacketList<E> type. 

public class RacketLists {
	
	// RETURNS: an empty RacketList
	public static <E> RacketList<E> empty () {
		return new RacketList1<E>();
	}
	
	// RETURNS: String representation of the RacketList<E>
	public static <E> String toString(RacketList<E> x) {
		
		RacketList<E> t = x;
		
		String s = "(list";
		
		while(t.first() != null) {
			s += " \"" + t.first().toString() + "\"";
			t = t.rest();
		}
			
		s += ")";
		
		return s;
	}
	
	// RETURNS: hashCode for RacketList<E>
	public static <E> int hashCode(RacketList<E> x) {
		return x.toString().hashCode();
	}
	
	// RETURNS: true iff both RacketList's match
	public static <E> boolean isEqual(RacketList<E> rl1, RacketList<E> rl2) {
		if (rl1.toString().equals(rl2.toString())) {
			return true;
		} else {
			return false;
		}
	}
	
	// RETURNS: number of elements in RacketList
	public static <E> int length(RacketList<E> rl) {
		return rl.length();
	}
}