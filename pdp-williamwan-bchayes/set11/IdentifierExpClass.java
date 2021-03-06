// Constructor template for IdentifierExpClass
//   new IdentifierExpClass(name)
// Interpretation:
//   name is the name of this identifier. 

import java.util.Map;

class IdentifierExpClass extends ExpClass implements IdentifierExp {
	
	// IdentifierExpClass fields
	private String name;

	// Constructor
	public IdentifierExpClass(String name) {
		this.name = name;
	}
	
    // Returns the name of this identifier.

    public String name() {
		return this.name;
	}
	
	// should be able to return "this" as implements Exp
	public Exp asExp() {
		return this;
	}
	
	// Returns the value of this expression when its free variables
    //     have the values associated with them in the given Map.
    // May run forever if this expression has no value.
    // May throw a RuntimeException if some free variable of this
    //     expression is not a key of the given Map or if a type
    //     error is encountered during computation of the value.
	public ExpVal value(Map<String,ExpVal> env) {
		
		ExpVal ev;
		
		try {
			// get the ExpVal for this identifier from the environment
			ev = env.get(this.name());
			
			// check if identifier ExpVal is a integer/boolean and return value, 
			// otherwise process a FunVal
			return ev;
			
		} catch (Exception ex) {
			
			throw new RuntimeException("IdentifierExp:"+this.name() +
									":Unable to obtain ExpVal for identifier.");
			
		}
		
	}
	
	// Returns true iff this Exp is a constant, otherwise the other methods
	// return false
    @Override
    public boolean isIdentifier() { return true; }

	// if the corresponding predicate above is true, return this, 
	// otherwise throw RuntimeException
	
	@Override
    public IdentifierExpClass asIdentifier() { 
		return this; 
	}
	
	public String toString() {
		return this.name();
	}
	
	public int hasCode() {
		return this.name.hashCode();
	}
}

class IdentifierExpTest {
	
	public static void main(String[] args) {
		
		// test IdentifierExpClass to makes sure it works
		IdentifierExpClass iec = new IdentifierExpClass("foo");
		
		assert iec.name() == "foo" : 	
							"name() should return 'foo'";
		assert iec.isIdentifier() == true : 
							"isIdentifier() should return true";
		assert iec.asExp().isIdentifier() == true : 
							"asExp().isIdentifier() true";
		assert iec.asIdentifier().name() == "foo" :
							"asIdentifier.name() should return 'foo'";
		System.out.println ("All unit tests of IdentifierExpClass passed.");
	}
}
