// Helper Class for RacketList
import java.util.function.*;

public class RacketListH {

	// GIVEN: a RacketList and an Element
	// RETURNS: true iff element is a member of the list
	
	public static <E> boolean member (E x,  RacketList<E> rl) {
		boolean isMember = false;
		while(rl.first()!=null) {
			if (rl.first().equals(x)) {
				isMember = true;
			}
			rl = rl.rest();
		}
		return isMember;
	}
	
	// GIVEN: A RacketList<E>
	// RETURNS: length of list
	public static <E> int length (RacketList<E> rl) {
		int counter = 0;
		while(!rl.isEmpty()) {
			counter++;
			rl = rl.rest();
		}
		
		return counter;
	}
	
	// GIVEN: two RacketList's
	// RETURNS: the union of the two lists
	public static <E> RacketList<E> append (RacketList<E> rl1, 
											RacketList<E> rl2) {
		
		RacketList<E> elements = RacketLists.empty();
		
		RacketList<E> union = RacketLists.empty();
		
		elements = rl1;
		while(elements.first() != null) {
			union = union.cons( elements.first() );
			elements = elements.rest();
		}
		
		elements = rl2;
		while(elements.first() != null) {
			union = union.cons( elements.first() );
			elements = elements.rest();
		}
			
		return union;
	}
	
	// GIVEN: a RacketList<E>
	// RETURNS: the reverse of the RacketList
	public static <E> RacketList<E> reverse( RacketList<E> rl ) {
		
		RacketList<E> reversedList = RacketLists.empty();
		
		RacketList<E> iterator = rl;
		
		while(!iterator.isEmpty()) {
			reversedList = reversedList.cons (iterator.first());
			iterator = iterator.rest();
		}
		
		return reversedList;
		
	}
	
	// GIVEN: an E and RacketList<E>
	// RETURNS: a list with the E added to the RacketList<E> 
	//          iff E is not member of RacketList<E> 
	public static <E> RacketList<E> listCons ( E x, RacketList<E> rl ) {
		if (!member( x , rl )) {
			return rl.cons( x );
		} else {
			return rl;
		}
	}
	
	// GIVEN: two RacketList<E>
	// RETURNS: the union of the two lists, except cases where
	//          elements from list1 already exist in list2
	// NOTE: this does not remove duplicates that might already exist in list2
	//       just stops us from adding duplicates from list1
	public static <E> RacketList<E> listUnion(RacketList<E> rl1, 
										      RacketList<E> rl2) {
		RacketList<E> iterator = rl1;
		RacketList<E> union = rl2;
		
		while(iterator.first() != null) {
			union = listCons (iterator.first(), union);
			iterator = iterator.rest();
		}
		
		return union;
	}
	
	// GIVEN: two RacketList<E>
	// RETURNS: RacketList<E> with all elements of list2 removed from list1
	public static <E> RacketList<E> listDiff (RacketList<E> rl1, 
											  RacketList<E> rl2) {
		int c = 0;
	
		RacketList<E> elements;
		RacketList<E> diff = RacketLists.empty();
		
		elements = rl1;
		while(elements.first() != null) {
			if (!member( elements.first(), rl2 )) {
				diff = diff.cons( elements.first() );
			}
			elements = elements.rest();
		}
	
		return diff;
	}
	
	// GIVEN: a RacketList
	// RETURNS: NonNegInt of the number of elements
	public static <E> int size(RacketList<E> rl) {
		int count = 0;
		
		RacketList<E> iterator = rl;
		while(!iterator.isEmpty()) {
			count++;
			iterator = iterator.rest();
		}
		
		return count;
	}
}