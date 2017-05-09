// Constructor template for CallExpClass
//   new CallExpClass(oper, arguments)
// Interpretation:
//   oper is the expression for the function part of the call.
//   arguments is the list of argument expressions of the call. 

import java.util.List;
import java.util.Map;

class CallExpClass extends ExpClass implements CallExp {

	// CallExpClass fields
	private Exp oper;
	private List<Exp> arguments;
	
	// Constructor
	public CallExpClass(Exp oper, List<Exp> arguments) {
		this.oper = oper;
		this.arguments = arguments;
	}

    // Returns the expression for the function part of the call.

	public Exp operator() {
		return this.oper;
	}

	// Returns the list of argument expressions.

	public List<Exp> arguments() {
		return this.arguments;
	}
	
	// should be able to return "this" as implements Exp
	public Exp asExp() {
		return this;
	}
	
    // GIVEN: environment
	// RETURNS: value in environment for current object, otherwise null
	public ExpVal value(Map<String,ExpVal> env) {
		if (env.containsKey(ProgramsH.getExpKey(this, 
											    (IMap<String,ExpVal>) env))) {
			return env.get(ProgramsH.getExpKey(this, 
											   (IMap<String,ExpVal>) env));
		} else {
			return null;
		}
	}
	
	// Returns true iff this Exp is a constant, otherwise the other methods
	// return false
    @Override
    public boolean isCall() { return true; }

	// if the corresponding predicate above is true, return this, 
	// otherwise throw RuntimeException
	
	@Override
    public CallExpClass asCall() { 
		return this; 
	}
	
}
