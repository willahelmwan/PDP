// Constructor template for LambdaExpClass
//   new LambdaExpClass(fmls, bdy)
// Interpretation:
//   fmls is the formal parameters of this lambda expression.
//   bdy is the body of this lambda expression. 

import java.util.*;
import java.lang.*;

class LambdaExpClass extends ExpClass implements LambdaExp {

	// Lambda Fields
	private List<String> fmls;
	private Exp bdy;
	
	// Lambda Constructor
	public LambdaExpClass(List<String> fmls, Exp bdy) {
		this.fmls = fmls;
		this.bdy = bdy;
	}
		
    // Returns the formal parameters of this lambda expression.

    public List<String> formals() {
		return this.fmls;
	}

    // Returns the body of this lambda expression.

    public Exp body() {
		return this.bdy;
	}

	// should be able to return "this" as LambdaExpClass implements Exp
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
    public boolean isLambda() { 
		return true; 
	}

	// if the corresponding predicate above is true, return this, 
	// otherwise throw RuntimeException
	
	@Override
    public LambdaExp asLambda() { 
		return this; 
	}
	
}