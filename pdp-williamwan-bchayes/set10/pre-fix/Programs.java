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
		IMap<String,ExpVal> env = new IMapList<String,ExpVal>();
		
		// if List<Def> has more than one element process first element, 
		// otherwise throw error that there are no Def.
		if (pgm.size()>0) {
			
			// proces first def in list, this will recurse through all 
			// expressions in Def1's AST, and if a CallExp is found will reach 
			// into the other Def's in the List<Def> as needed. 
			env = processDef(pgm.get(0), pgm, inputs, env);
			
		} else {
			
			// throw error, no Def in list
			throw new RuntimeException("Programs.run():No Def to process.");
		}
		
		// return result of first Def, if return value is null throw error
		if ((env.containsKey("DEF:"+pgm.get(0).lhs())) && 
			(env.get("DEF:"+pgm.get(0).lhs()) != null)) {
			return env.get("DEF:"+pgm.get(0).lhs());
		} else {
			throw new RuntimeException(
						"Programs.run:Null result after processing List<Def> " +
						"with given inputs.");
		}
	}
	
	// GIVEN: a Def, list of Def, list of ExpVal and the environment
	// RETURNS: the updated environment, after having processed the Def
	//          using the list of inputs to update the starting identifiers
	//          for a given lambda. If a constant expression is present it 
	//          just returns the constant.
	// HALTING MEASURE: No further expressions to process
	private static IMap<String, ExpVal> processDef( Def d, 
												    List<Def> pgm, 
													List<ExpVal> inputs, 
													IMap<String,ExpVal> env) {
		// used to cast and hold a lambda expression
		LambdaExp lambda;
		
		// add default value to environment for Def
		env = env.extend("DEF:"+d.lhs(), null);
		
		// verify Def has expression
		if (d.rhs()==null) {
			throw new RuntimeException("processDef:DEF:" + d.lhs() +
										"Def does not contain an expression.");
		} else {
			
			// if expression is Constant
			if (d.rhs().isConstant()) {
				
				// processConstant
				env = processExpression(d.rhs(), env, pgm);
			
			// if expression is lambda
			} else if (d.rhs().isLambda()) {
				
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
					env = env.extend("ID:"+lambda.formals().get(i).toString(), 
									 inputs.get(i) );
				}
				
				// processLambda
				env = processExpression(d.rhs(), env, pgm);
			
			// else throw error
			} else {
				throw new RuntimeException("processDef:DEF:" + d.lhs() +
										"Def contains invalid expression, " + 
										"ConstantExp or LambdaExp required.");
			}
		}
		
		// set Def value in Map to right hand expression ExpVal
		env = env.extend("DEF:"+d.lhs(), d.rhs().value(env));
		
		// debug info (turned off for submission)
		ProgramsH.outputMap(env);
		
		return env;
	}
	
	// GIVEN: ConstantExp and the environment
	// RETURNS: environment with the Constant added too it
	// HALTING MEASURE: No further expressions to process
	private static IMap<String,ExpVal> processConstant(ConstantExp ce, 
														IMap<String,ExpVal> env, 
														List<Def> pgm) {
		
		// extend environment with constant
		env = env.extend(ProgramsH.getExpKey(ce.asExp(),env), ce.value());
		
		return env;
	}
	
	// GIVEN: LambdaExp and the environment
	// RETURNS: environment with the Lambda expression added to it with its 
	//          value, this may be after a number of expressions are evaluated
	// HALTING MEASURE: No further expressions to process
	private static IMap<String,ExpVal> processLambda(LambdaExp lambda, 
													 IMap<String,ExpVal> env,
													 List<Def> pgm) {
		
		// process ConstantExp
		env = processExpression(lambda.body(), env, pgm);
		
		// update lambda with constants value as it 
		// is stored in the environment
		env = ProgramsH.setKeyToExpValue(ProgramsH.getExpKey(lambda, env), 	
										 lambda.body(), env);
		
		return env;
	}
	
	// GIVEN: IdentifierExp and the environment
	// RETURNS: environment with the IdentifierExp added/updated with its value
	// HALTING MEASURE: No further expressions to process
	private static IMap<String,ExpVal> processIdentifier(
													IdentifierExp id,
													IMap<String,ExpVal> env,
													List<Def> pgm) {
		// init IdentifierExp if it is not in the environment
		if (id.value(env) == null) {
			env = env.extend("ID:" + id.name(), null);
		}
	
		return env;
	}
	
	// GIVEN: ArithmeticExp and the environment
	// RETURN: environment with the ArithmeticExp added/updated with its value
	// HALTING MEASURE: No further expressions to process
	private static IMap<String,ExpVal> processArithmetic(
													ArithmeticExp math,
													IMap<String,ExpVal> env,
													List<Def> pgm) {
														
		boolean boolResult;
		long intResult;
		
		// verify left operand has a value in the map, if not process exp
		// arithmetic cannot be processed if exp has not been resolved
		if ((math.leftOperand() != null) && 
			(math.leftOperand().value(env) == null)) {
			env = processExpression(math.leftOperand(), env, pgm);
		}
		
		// verify right operand has a value in the map, if not process exp
		// arithmetic cannot be processed if exp has not been resolved
		if ((math.rightOperand() != null) && 
			(math.rightOperand().value(env) == null)) {
			env = processExpression(math.rightOperand(), env, pgm);
		}

		// add ArithmeticExp to environment with default value
		env = env.extend(ProgramsH.getExpKey(math, env), null);
		
		// check if both operands are integer, if not throw error
		if (math.leftOperand().value(env).isInteger() &&
			math.rightOperand().value(env).isInteger()) {
								 
			// complete operation and update environment
			if (math.operation().equals("LT")) {

				// calculate true iff left operand is smaller than right operand
				boolResult = math.leftOperand().value(env).asInteger() < 
							 math.rightOperand().value(env).asInteger();
				
				// update environment with calculated value
				env = env.extend(ProgramsH.getExpKey(math, env), 
								 Asts.expVal(boolResult));
					
			} else if (math.operation().equals("EQ")) {
				
				// calculate true iff both values are the same
				boolResult = math.leftOperand().value(env).asInteger() == 
							 math.rightOperand().value(env).asInteger();
				
				// update environment with calculated value
				env = env.extend(ProgramsH.getExpKey(math, env), 
								 Asts.expVal(boolResult));
				
			} else if (math.operation().equals("GT")) {
				
				// calculate true iff left operand is larger than right operand
				boolResult = math.leftOperand().value(env).asInteger() > 
							 math.rightOperand().value(env).asInteger();
				
				// update environment with calculated value
				env = env.extend(ProgramsH.getExpKey(math, env), 
								 Asts.expVal(boolResult));

			} else if (math.operation().equals("PLUS")) {
				
				// calculates left plus right
				intResult = math.leftOperand().value(env).asInteger() + 
							math.rightOperand().value(env).asInteger();
				
				// update environment with calculated value
				env = env.extend(ProgramsH.getExpKey(math, env), 
								 Asts.expVal(intResult));

			} else if (math.operation().equals("MINUS")) {
				
				// calculates left minus right
				intResult = math.leftOperand().value(env).asInteger() - 
							math.rightOperand().value(env).asInteger();
				
				// update environment with calculated value
				env = env.extend(ProgramsH.getExpKey(math, env), 
								 Asts.expVal(intResult));

			} else if (math.operation().equals("TIMES")) {
				
				// calculates left times right
				intResult = math.leftOperand().value(env).asInteger() * 
							math.rightOperand().value(env).asInteger();
				
				// update environment with calculated value
				env = env.extend(ProgramsH.getExpKey(math, env), 
								 Asts.expVal(intResult));
				
			} else {
				
				// throw error - unknown operation
				throw new RuntimeException("processArithmetic:Unknown " + 
							"or no given operation. Operation must be either " +
							"LT, GT, PLUS, MINUS, TIMES. Operation: " + 
							math.operation());
			}
			
		} else {
			
			// throw error
			throw new RuntimeException("processArithmetic:Operands are of " +
							"different types, they must match. LeftOperand: " +
							math.leftOperand().value(env) + " RightOperand: " +
							math.rightOperand().value(env));
		}
		
		return env;
	
	}
	
	// GIVEN: IfExp and the environment
	// RETURN: environment with the IfExp added/updated with its value
	// HALTING MEASURE: No further expressions to process
	private static IMap<String,ExpVal> processIf(IfExp ifx,
												 IMap<String,ExpVal> env,
													List<Def> pgm) {
		
		ExpVal ev;

		// process testPart expression
		env = processExpression(ifx.testPart(), env, pgm);
		
		// write if:test to environment
		env = env.extend(ProgramsH.getExpKey(ifx, env), 
						 ifx.testPart().value(env));
		
		// get result of processing the testPart of the if expression
		ev = ifx.testPart().value(env);
		
		// check if testPart returned a boolean value
		if (env.get(ProgramsH.getExpKey(ifx, env)).isBoolean()) {
			
			// check if testPart returned true
			if (env.get(ProgramsH.getExpKey(ifx, env)).asBoolean()) {
				
				// if true, process thenPart
				env = processExpression(ifx.thenPart(), env, pgm);
				
				// add/update IfExp in environment to ExpVal
				env = env.extend(ProgramsH.getExpKey(ifx, env), 
								 ifx.thenPart().value(env));
				
			} else {
				
				// if false, process elsePart
				env = processExpression(ifx.elsePart(), env, pgm);
				
				// add/update IfExp in environment to ExpVal
				env = env.extend(ProgramsH.getExpKey(ifx, env), 
								 ifx.elsePart().value(env));
			}
			
		} else {
			
			// throw error, test did not return boolean
			throw new RuntimeException("processIf:testPart did not return " + 
										"a boolean value. ");
		}
		
		return env;
	}
	
	// GIVEN: CallExp and the environment
	// RETURN: environment with the CallExp added/updated with its value
	// HALTING MEASURE: No further expressions to process
	private static IMap<String,ExpVal> processCall(CallExp call,
												    IMap<String,ExpVal> env,
													List<Def> pgm) {
														
		// Def being called by CallExp
		Def callDef = null;
		List<ExpVal> inputs = new ArrayList<ExpVal>();
		
		// identify Def of call (function)
		String callFunction = ((CallExp) call).operator().toString();
		
		// obtain list of CallExp arguments
		List<Exp> callArguments = ((CallExp) call).arguments();
				
		// find Def in List<Def>
		for(Def d : pgm) {
			
			// find Def
			if (d.lhs().equals(callFunction)) {
				callDef = d;
			}
		}
		
		// loop through argument expressions, process each and
		// add each ExpVal from the process to the list of inputs
		for(Exp exp : callArguments) {
			
			// process argument
			env = processExpression(exp, env, pgm);
			
			// get expresssion value and return to inputs
			inputs.add(exp.value(env));
		}
		
		// Create CallEnv to process call
		IMap<String,ExpVal> callEnv = new IMapList<String,ExpVal>();
		
		// process Def w/ callInputs
		callEnv = processDef(callDef, pgm, inputs, callEnv);
		
		// update main environment with callEnvironment calculated value
		env = env.extend(ProgramsH.getExpKey(call, env), 
						 callEnv.get(ProgramsH.getExpKey(callDef.rhs(), 
														 callEnv)));
		
		return env;
	}
	
	// GIVEN: an expression and environment
	// RETURNS: the expression processed and its key,value added 
	//          to the environment
	// NOTE: Method simplifies the deteciton of type and calling the 
	//       required processing method
	private static IMap<String,ExpVal> processExpression(
													Exp exp,
													IMap<String,ExpVal> env,
													List<Def> pgm) {

		// constant
		if (exp.isConstant()) {
			// process expression and update environment
			env = processConstant((ConstantExp) exp, env, pgm);
		// lambda
		} else if (exp.isLambda()) {
			// process expression and update environment
			env = processLambda((LambdaExp) exp, env, pgm);
		// identifier	
		} else if (exp.isIdentifier()) {
			// process expression and update environment
			env = processIdentifier((IdentifierExp) exp, env, pgm);
		// arithmetic	
		} else if (exp.isArithmetic()) {
			// process expression and update environment
			env = processArithmetic((ArithmeticExp) exp, env, pgm);
		// call	
		} else if (exp.isCall()) {
			// process expression and update environment
			env = processCall((CallExp) exp, env, pgm);
		// if	
		} else if (exp.isIf()) {
			// process expression and update environment
			env = processIf((IfExp) exp, env, pgm);
		}
		
		// debug info (turned off for submission)
		ProgramsH.outputMap(env);
															
		return env;
	}
	
}