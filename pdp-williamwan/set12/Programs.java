// The Asts class defines static methods for the Ast type. 
// In particular, it defines a static factory method for creating 
// Def type, ArithmeticExp type, CallExp type, ConstantExp type,
// IdentifierExp type, IfExp type, LambdaExp type, ExpVal type,
// empty List type, 1 element List type, 2 elements List type, 
// 3 elements List type, and 4 elements List type. 

// The Programs class defines static methods that process 
// Ast data structures. In particular it includes ...
// - run() - a method which processes a list of Def and inputs to 
//           calculate a result
// - processDef() 			- processes an Ast Def object
// - processConstant() 		- processes an Ast ConstantExp
// - processLambda() 		- processes an Ast LambdaExp
// - processIdentifier()	- processes an Ast IdentifierExp
// - processCall()			- processes an Ast CallExp
// - processIf()			- processes an Ast IfExp
// - processArithmetic()	- processes an Ast ArithmeticExp
// - processExpression()	- processes an Ast Expression , this detects
//                            the type of expression and then callst he 
//                            type specific expression process method.

import java.lang.*;
import java.util.*;

public class Programs {

	public static ExpVal run (List<Def> pgm, List<ExpVal> inputs) {
		
		// create environment 
		// Using iMapList which should be immutable - based on RacketList
		Map<String,ExpVal> env = new HashMap<String,ExpVal>();
		
		// if List<Def> has more than one element process first element, 
		// otherwise throw error that there are no Def.
		if (pgm.size()>0) {
			
			// load all Def into env, loop multiple times so that FunVal
			// have an accurate environment with all other fully defined
			// Def's with matching FunVal environments
			for(Def d : pgm) {
				
				if (d.rhs().isLambda()) {
					env.put(d.lhs().toString(), Asts.expVal(d.rhs().asLambda(), env));
				} else if (d.rhs().isConstant()) {
					env.put(d.lhs(), ((ConstantExp) d.rhs()).value());
				}
			}
			
			// display environment - debug only
			ProgramsH.outputMap(env);
			
			// proces first def in list, this will recurse through all 
			// expressions in Def1's AST, and if a CallExp is found will reach 
			// into the other Def's in the List<Def> as needed. 
			return  processDef(pgm.get(0), inputs, env);
			
		} else {
			
			// throw error, no Def in list
			throw new RuntimeException("Programs.run():No Def to process.");
		}
	}
	
	// GIVEN: a Def, list of Def, list of ExpVal and the environment
	// RETURNS: the updated environment, after having processed the Def
	//          using the list of inputs to update the starting identifiers
	//          for a given lambda. If a constant expression is present it 
	//          just returns the constant.
	// HALTING MEASURE: No further expressions to process
	private static ExpVal processDef( Def d, 
									  List<ExpVal> inputs, 
									  Map<String,ExpVal> env) {
		// used to cast and hold a lambda expression
		LambdaExp lambda;
		ExpVal result;
		
		// verify Def has expression
		if (d.rhs()==null) {
			throw new RuntimeException("processDef:DEF:" + d.lhs() +
										"Def does not contain an expression.");
		} else {
			
			// if expression is lambda
			if (d.rhs().isLambda()) {
				
				// cast and store LambdaExp
				lambda = (LambdaExp) d.rhs();
				
				// verify inputs count matches lambda formals count
				if (inputs.size() != (lambda.formals().size())) {
					throw new RuntimeException("processDef:DEF:" + d.lhs() +
										"Invalid number of arguments, " +
										"number of inputs do not match " + 
										"the number of the lambda's formals." +
										"Inputs: " + inputs.size() + 
										" Formals: " + lambda.formals().size());
				}
				
				// add formals w/ input values to environment, needed before
				// processing lambda
				for(int i=0;i<inputs.size();i++) {
					
					// create identifiers for starting inputs
					env.put(lambda.formals().get(i).toString(), inputs.get(i));
				}
				
				// return the result of processing lambda
				return lambda.body().value(env);
			
			// else throw error
			
			} else {
				
				throw new RuntimeException("processDef:DEF:" + d.lhs() +
										"Def contains invalid expression, " + 
										"ConstantExp or LambdaExp required.");
			}
		}
		
	}

	// Runs the ps11 program found in the file named on the command line
	// on the integer inputs that follow its name on the command line,
	// printing the result computed by the program.
	//
	// Example:
	//
	//     % java Programs sieve.ps11 2 100
	//     25
	public static void main (String[] args) { 
	
		// call Sacnner.main and pass args to it
		Scanner.main(args);
	
	}

}