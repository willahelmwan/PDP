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
	
    // Returns the value of this expression when its free variables
    //     have the values associated with them in the given Map.
    // May run forever if this expression has no value.
    // May throw a RuntimeException if some free variable of this
    //     expression is not a key of the given Map or if a type
    //     error is encountered during computation of the value.
	public ExpVal value(Map<String,ExpVal> env) {
		return env.get("LA:"+this.hashCode());
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