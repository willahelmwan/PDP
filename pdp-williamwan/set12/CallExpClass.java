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
		
		LambdaExp fvLambda;
		Map<String,ExpVal> fvEnv;
		Map<String,ExpVal> argEnv;
		ExpVal argResult;
		
		// copy env
		Map<String, ExpVal> operEnv = new HashMap<String, ExpVal>(env);
		
		// process operator with environment copy
		ExpVal operResult = this.operator().value(operEnv);
		
		//  check if operator result is a function
		if (operResult.isFunction()) {
			
			// obtain lambda from FunVal
			fvLambda = operResult.asFunction().code();
			
			// obtain environment from FunVal, and copy it into a new map
			// some black box testing passes an unmodifiableMap
			fvEnv = new HashMap<String,ExpVal>(operResult.asFunction().environment());
			
			// process CallExp arguments and bind them to lambda formals
			// in the fvEnv
			for(int i=0; i<this.arguments().size();i++) {
				
				// set argEnv to original env
				argEnv = new HashMap<String,ExpVal>(env);
				
				// process argument for result
				argResult = this.arguments().get(i).value(argEnv);
				
				// bind argument result to lambda formal in fvEnv
				fvEnv.put(fvLambda.formals().get(i), argResult);
			}
			
			// process fvLambda and return result passing the extended fvEnv
			// with the bound formals to call arguments
			return fvLambda.body().value(fvEnv);
			
		} else {
			
			return operResult;
			
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
