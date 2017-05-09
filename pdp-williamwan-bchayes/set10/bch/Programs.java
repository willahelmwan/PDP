
import java.lang.*;
import java.util.*;

public class Programs {

	public static ExpVal run (List<Def> pgm, List<ExpVal> inputs) {
		
		// create environment 
		// Using iMapList which should be immutable - based on RacketList
		IMap<String,ExpVal> env = new IMapList<String,ExpVal>();
		
		// loop through pgm and parse Asts to initialize the environment
		// expressions without values will be set to null
		try {
			env = initEnvironment(pgm, inputs, env);
		} 
		catch (Exception ex)
		{
			System.out.println(ex.getMessage());
		}
		
		// output environment for debugging
		System.out.println("ENV:");
		for(Map.Entry<String,ExpVal> e : env.entrySet()) {
			if (e.getValue()!=null) {
				System.out.println("  " + e.getKey() + " => " + e.getValue().toString());
			} else {
				System.out.println("  " + e.getKey() + " => NULL");
			}
		}
		
		// parse Ast to calculate, updating map values as 
		// it processes.
		
		
		// return result
		if ((env.containsKey("D:"+pgm.get(0).lhs())) && (env.get("D:"+pgm.get(0).lhs()).toString() != null)) {
			return env.get("D:"+pgm.get(0).lhs());
		} else {
			throw new RuntimeException("Programs.run:Null result");
		}
	
	}
	
	private static IMap<String,ExpVal> initEnvironment(List<Def> pgm,
													   List<ExpVal> inputs,
													   IMap<String,ExpVal> env){
														   
		LambdaExp lambda;
		ConstantExp constant;
		IdentifierExp id;
		
		// loop through List<Def> (program) and init environment
		for(Def d : pgm) {
			
			if (d.rhs() == null) {
				throw new RuntimeException("initEnvironment:DEF("+
								d.lhs()+"):Expression is null.");
			}
			
			// check if Def right hand is lambda
			if (d.rhs().isLambda()) {
				
				// add definition to environment
				env = env.extend("D:"+d.lhs(), null);
				
				// cast & store lambda expression
				lambda = (LambdaExp) d.rhs();
				
				// verify lambda formals count matches input count
				if (lambda.formals().size() == inputs.size()) {
					
					// add formals w/ values into environment
					for(int i=0; i<lambda.formals().size();i++) {
						
						// create identifier with formal
						id = Asts.identifierExp( lambda.formals().get(i) );
						
						// extend environment with identifierExp key and 
						// matching inputs value
						env = env.extend("ID:"+id.name(), inputs.get(i) );
					}
					
				} else {
					
					// throw error, incorrect number of arguments
					throw new RuntimeException("initEnvironment:DEF("+
									d.lhs()+"):Incorrect number of arguments.");
									
				}
				
				// extend env with lambda entry with value of null
				env = env.extend("LA:"+lambda.formals().toString(), null);
				
				// call initProcExp on lambda body
				env = initProcExp(lambda.body(), env);
				
				
			} else if (d.rhs().isConstant()) {
				
				constant = (ConstantExp) d.rhs();
				
				// add definition to environment
				env = env.extend("D:"+d.lhs(), constant.value() );
				
				// add constant to environment
				env = env.extend("C:"+d.lhs(), constant.value() );

				
				
			} else {
				
				// throw error, not a lambda or constant
				throw new RuntimeException("initEnvironment:DEF("+
									d.lhs()+"):Invalid expression, not a "+
									"LambdaExp or ConstantExp.");
			}
		
		}
		
		return env;
	}
	
	private static IMap<String,ExpVal> initProcExp(Exp e, IMap<String,ExpVal> env) {
		
		// identify type of expression and process accordingly
		if (e.isLambda()) {
			
			// cast and store in LambdaExp variable
			LambdaExp lambdaExp = (LambdaExp) e;
			
			// create environment entry for lambda expression
			if (!env.containsKey("LA:"+lambdaExp.formals().toString())) {
				env = env.extend("LA:"+lambdaExp.formals().toString(), null);
			}
			
			// process body which is another expression
			env = initProcExp( lambdaExp.body(), env );
			
		} else if (e.isConstant()) {
			
			// cast and store in ConstantExp variable
			ConstantExp constantExp = (ConstantExp) e;
			
			// constant
			env = env.extend("CN:"+constantExp.hashCode()+"", constantExp.value());
			
		} else if (e.isIf()) {
			
			// cast and store in IfExp variable
			IfExp ifExp = (IfExp) e;
			
			// if
			env = env.extend("IF:"+ifExp.hashCode()+"", null);
			
			env = initProcExp( ifExp.testPart(), env );
			
			env = initProcExp( ifExp.thenPart(), env );
			
			env = initProcExp( ifExp.elsePart(), env );
			
		} else if (e.isArithmetic()) {
			
			// cast and store in ArithmeticExp variable
			ArithmeticExp arithmeticExp = (ArithmeticExp) e;
			
			// arithmetic
			env = env.extend("AR:("+arithmeticExp.leftOperand().toString()+" "+arithmeticExp.operation()+" "+arithmeticExp.rightOperand().toString()+")", null);
			
			env = initProcExp( arithmeticExp.leftOperand(), env );
			
			env = initProcExp( arithmeticExp.rightOperand(), env );
			
		} else if (e.isCall()) {
			
			// cast and store in CallExp variable
			CallExp callExp = (CallExp) e;
			
			// call
			env = env.extend("CL:"+callExp.hashCode()+"", null);
			
			// operator expression
			env = initProcExp( callExp.operator(), env );
			
		} else {
			
			// cast and store in IdentifierExp variable
			IdentifierExp identifierExp = (IdentifierExp) e;
			
			// identifier
			if (!env.containsKey("ID:"+identifierExp.name())) {
				env = env.extend("ID:"+identifierExp.name(), null );
			}
		}
		
		return env;
	}
}