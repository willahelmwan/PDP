
import java.util.*;
import java.lang.*;

class ProgramsH {
	
	// GIVEN: a key, expression and environment
	// RETURN: the environment with the given key set to the 
	//         expressions value
	public static IMap<String,ExpVal> setKeyToExpValue(
													String key,
													Exp exp,
												    IMap<String,ExpVal> env) {
		
		// constant
		if (exp.isConstant()) {
			env = env.extend(key, ((ConstantExp) exp).value(env));
		// lambda
		} else if (exp.isLambda()) {
			env = env.extend(key, ((LambdaExp) exp).value(env));
		// identifier	
		} else if (exp.isIdentifier()) {
			env = env.extend(key, ((IdentifierExp) exp).value(env));
		// arithmetic	
		} else if (exp.isArithmetic()) {
			env = env.extend(key, ((ArithmeticExp) exp).value(env));
		// call	
		} else if (exp.isCall()) {
			env = env.extend(key, ((CallExp) exp).value(env));
		// if	
		} else if (exp.isIf()) {
			env = env.extend(key, ((IfExp) exp).value(env));
		}
	
		return env;
	}
	
	// GIVEN: an expression and environment
	// RETURNS: they environment key for the expression
	public static String getExpKey(Exp exp, IMap<String, ExpVal> env) {
		
		String key = "";
		
		// constant
		if (exp.isConstant()) {
			key = "CONST:";
			key += ((ConstantExp) exp).value();
		// lambda
		} else if (exp.isLambda()) {
			key = "LAMBDA:";
			key += ((LambdaExp) exp).formals().toString();
			key += " " + getExpKey(((LambdaExp) exp).body(), env);
			//key += ":" + ((LambdaExp) exp).hashCode();
		// identifier	
		} else if (exp.isIdentifier()) {
			key = "ID:";
			key += ((IdentifierExp) exp).name();
		// arithmetic	
		} else if (exp.isArithmetic()) {
			key = "ARITHMETIC:";
			key += "[";
			key += ((ArithmeticExp) exp).leftOperand().value(env);
			key += " ";
			key += ((ArithmeticExp) exp).operation();
			key += " ";
			key += ((ArithmeticExp) exp).rightOperand().value(env);
			key += "]";
		// call	
		} else if (exp.isCall()) {
			key = "CALL:";
			key += " " + getExpKey(((CallExp) exp).operator(), env);
			//key += ":" + ((CallExp) exp).hashCode();
		// if	
		} else if (exp.isIf()) {
			key = "IF:";
			key += getExpKey(((IfExp) exp).testPart().asExp(), env);
			//key += ":" + ((IfExp) exp).hashCode();
		}	
		
		return key;
		
	}
	
	// GIVEN: an environment
	// EFFECT: Display's contents of environment in console
	public static void outputMap(IMap<String,ExpVal> env) {
		if (debugOn()) {
			// output environment for debugging
			System.out.println("Environment Output :");
			for(Map.Entry<String,ExpVal> e : env.entrySet()) {
				if (e.getValue()!=null) {
					System.out.println("  " + e.getKey() + " => " + 
									   e.getValue().toString());
				} else {
					System.out.println("  " + e.getKey() + " => NULL");
				}
			}
			
			if (false) {
				try {
					System.in.read();
				} catch (Exception ex) {}
			}
		}
	}
	
	// RETURNS: true iff we should see debugging info
	private static boolean debugOn() {
		return false;
	}
}