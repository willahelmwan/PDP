// Constructor template for CallExpClass
//   new CallExpClass(oper, arguments)
// Interpretation:
//   oper is the expression for the function part of the call.
//   arguments is the list of argument expressions of the call. 

import java.util.*;
import java.util.*;

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
		
		ExpVal idVal;
		FunVal fVal;
		ExpVal result;
		
		// Get list of variables within this CallExp (until another CallExp)
		List<String> vars = new ArrayList<String>();
		vars = Programs.getVariables(this.operator(), env, vars);
		
		// loop variables and populate into environment with argument data
		for(int i=0;i<this.arguments().size();i++) {
			env = ProgramsH.extend(env, vars.get(i), this.arguments().get(i).value(env));				
		}
	
		// process based on type of expression being called
		if (this.operator().isIdentifier()) {
			
			// identifier variables
			IdentifierExp id = this.operator().asIdentifier();
			
			// get ExpVal of identifier
			idVal = id.value(env);
			
		    // check to see if idVal is function
			if (idVal.isFunction()) {
				
				// get FunVal
				fVal = idVal.asFunction();
				
				// get value from FunVal Code
				result = fVal.code().body().value(env);
				
				// return lambda value
				return result;
				
			} else if (idVal.isBoolean()||idVal.isInteger()) {
				
				// return result
				return idVal;
				
			} else {
				return null;
			}
		
		} else if (this.operator().isIf()) {
			
			IfExp ifte = this.operator().asIf();
			
			result = ifte.value(env);
			return result;
			
		} else if (this.operator().isCall()) {
			
			CallExp call = this.operator().asCall();
			
			if (call.operator().isLambda()) {
				LambdaExp lambda = (LambdaExp) call.operator();
				result = lambda.body().value(env);
			} else {
				result = call.operator().value(env);				
			}
					
			return result;
			
		} else if (this.operator().isLambda()) {
			LambdaExp lambda = (LambdaExp) this.operator();
			return lambda.body().value(env);
			
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
