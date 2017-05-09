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
		
		LambdaExp lambda;
	
		// define new environment for use with lambda expressions
		Map<String,ExpVal> newMap = new HashMap<String, ExpVal>(env);
	
			// if lambda, populate arguments into newMap
		if (this.operator().isLambda()) {
			
			// cast operator() into lambda (simply code for readability)
			lambda = (LambdaExp) this.operator();
			
			// check if number of arguments match lambda formals
			if (lambda.formals().size() == this.arguments().size()) {
				
				// loop through formals and assignm argument values
				for(int i=0; i<lambda.formals().size(); i++) {
					
					// passing in lambda formal, and arugment value, where value
					// is called with original environment (env), not newEnv to 
					// maintain scope
					newMap.put(lambda.formals().get(i), this.arguments().get(i).value(env));
				}
				
			} else {
				throw new RuntimeException("CallExp:Invalid number of arguments.");
			}
			
			// process lambda for value, passing newEnv with arguments added 
			// from call expression
			result = lambda.body().value(newMap);
			
			// return result
			return result;
			
		} else if (this.operator().isIdentifier()) {
			
			// identifier variables
			IdentifierExp id = this.operator().asIdentifier();
			
			// get ExpVal of identifier
			result = id.value(env);
			
			// if result is function, then process arguments into 
			// the funVal's environment and the obtain the 
			// value of the function with that environment
			if (result.isFunction()) {
				
				// get lambda
				lambda = result.asFunction().code();
				
				// check if number of arguments match lambda formals
				if (lambda.formals().size() == this.arguments().size()) {
					
					// loop through formals and assignm argument values
					for(int i=0; i<lambda.formals().size(); i++) {
						
						// passing in lambda formal, and arugment value, where value
						// is called with original environment (env), not newEnv to 
						// maintain scope
						newMap.put(lambda.formals().get(i), this.arguments().get(i).value(env));
					}
					
				} else {
					throw new RuntimeException("CallExp:Invalid number of arguments.");
				}
				
				// get new result based on lambda value
				result = lambda.body().value(newMap);
				
				return result;
				
			} else {
				
				return result;
				
			}
			
		
		} else if (this.operator().isIf()) {
			
			IfExp ifte = this.operator().asIf();
			
			result = ifte.value(env);
			
			// if result is function, then process arguments into 
			// the funVal's environment and the obtain the 
			// value of the function with that environment
			if (result.isFunction()) {
				
				// get lambda
				lambda = result.asFunction().code();
				
				// check if number of arguments match lambda formals
				if (lambda.formals().size() == this.arguments().size()) {
					
					// loop through formals and assignm argument values
					for(int i=0; i<lambda.formals().size(); i++) {
						
						// passing in lambda formal, and arugment value, where value
						// is called with original environment (env), not newEnv to 
						// maintain scope
						newMap.put(lambda.formals().get(i), this.arguments().get(i).value(env));
					}
					
				} else {
					throw new RuntimeException("CallExp:Invalid number of arguments.");
				}
				
				// get new result based on lambda value
				result = lambda.body().value(newMap);
				
				return result;
				
			} else {
				return result;
			}
			
		} else if (this.operator().isCall()) {
			
			CallExp call = this.operator().asCall();
			
			result = call.value(env);
			
			// if result is function, then process arguments into 
			// the funVal's environment and the obtain the 
			// value of the function with that environment
			if (result.isFunction()) {
				
				// get lambda
				lambda = result.asFunction().code();
				
				// get environment
				//newMap = result.asFunction().environment();
				
				// check if number of arguments match lambda formals
				if (lambda.formals().size() == this.arguments().size()) {
					
					// loop through formals and assignm argument values
					for(int i=0; i<lambda.formals().size(); i++) {
						
						// passing in lambda formal, and arugment value, where value
						// is called with original environment (env), not newEnv to 
						// maintain scope
						newMap.put(lambda.formals().get(i), this.arguments().get(i).value(env));
					}
					
				} else {
					throw new RuntimeException("CallExp:Invalid number of arguments.");
				}
				
				// get new result based on lambda value
				result = lambda.body().value(newMap);
				
				return result;
				
			} else {
				return result;
			}
			
		} else if (this.operator().isArithmetic()) {
			
			// capture operator as Arithmetic Expression
			ArithmeticExp math = this.operator().asArithmetic();
			
			// get result of arithmetic operation
			result = math.value(env);
		
			// if result is function, then process arguments into 
			// the funVal's environment and the obtain the 
			// value of the function with that environment
			if (result.isFunction()) {
				
				// get lambda
				lambda = result.asFunction().code();
				
				// check if number of arguments match lambda formals
				if (lambda.formals().size() == this.arguments().size()) {
					
					// loop through formals and assignm argument values
					for(int i=0; i<lambda.formals().size(); i++) {
						
						// passing in lambda formal, and arugment value, where value
						// is called with original environment (env), not newEnv to 
						// maintain scope
						newMap.put(lambda.formals().get(i), this.arguments().get(i).value(env));
					}
					
				} else {
					throw new RuntimeException("CallExp:Invalid number of arguments.");
				}
				
				// get new result based on lambda value
				result = lambda.body().value(newMap);
				
				return result;
				
			} else {
				return result;
			}
		
		} else {
			
			System.out.println("NULLLLLLLLL");
			
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
	
	public String toString(boolean asAst) {
		String output = "";
		
		if (asAst) {
			output = "Asts.callExp(" + this.operator().toString(true) + ",";
			output += " list(";
			for(Exp e : this.arguments()) {
				output += e.toString(true) + ",";
			}
			output += output.substring(0,output.length()-1);
			output += "))";
		} else {
			output += this.toString();
		}
		
		return output;
	}
	
}
