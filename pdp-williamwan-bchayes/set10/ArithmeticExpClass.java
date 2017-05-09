// Constructor template for ArithmeticExpClass
//   new ArithmeticExpClass (leftOper, binaryOp, rightOper)
// Interpretation:
//    leftOper is the left operator
//    binaryOp is one of the operators below:
//     <
//     =
//     >
//     +
//     -
//     *
//    represented in strings below: 
//     "LT"
//     "EQ"
//     "GT"
//     "PLUS"
//     "MINUS"
//     "TIMES"
// 	  rightOper is the right operator


import java.util.*;
import java.util.Map;

class ArithmeticExpClass extends ExpClass implements ArithmeticExp {

	// ArithmeticExpClass Fields
	private Exp leftOper;   	// left operator
	private String binaryOp;	// binary operator
	private Exp rightOper;   	// right operator
	
	// Constructor - Exp String Exp
	public ArithmeticExpClass(Exp leftOper, String binaryOp, Exp rightOper) {
		
		// check that op is a valid operator
		String[] ops = {"LT","EQ","GT","PLUS","MINUS","TIMES"};
		List<String> validOperators = new ArrayList<String>();
		validOperators = Arrays.asList(ops);

		this.leftOper = leftOper;
		this.binaryOp = binaryOp;
		this.rightOper = rightOper;	
	}

    // Returns the appropriate subexpression.

    public Exp leftOperand(){
		return this.leftOper;
	}
    public Exp rightOperand() {
		return this.rightOper;
	}

    // Returns the binary operation as one of the strings
    //     "LT"
    //     "EQ"
    //     "GT"
    //     "PLUS"
    //     "MINUS"
    //     "TIMES"

    public String operation() {
		return this.binaryOp;
	}
	
	// should be able to return "this" as ArithmeticExpClass implements Exp
	public Exp asExp() {
		return this;
	}
	
	
	public ExpVal value(Map<String,ExpVal> env) {
		
		LambdaExp lambda;
		
		boolean boolResult;
		long intResult;
		
		ExpVal leftResult;
		ExpVal rightResult;
		
		ExpVal result;
		
		try {
		
			// find results from left and right expressions
			leftResult = this.leftOperand().value(env);
			
			// if return is a function
			if (leftResult.isFunction()) {
				
				// get lambda
				lambda = leftResult.asFunction().code();
				
				// process new result
				leftResult = lambda.body().value(leftResult.asFunction().environment());
			}
			
			rightResult = this.rightOperand().value(env);
			
			// if return is a function
			if (rightResult.isFunction()) {
				
				// get lambda
				lambda = rightResult.asFunction().code();
				
				// process new result
				rightResult = lambda.body().value(rightResult.asFunction().environment());
			}
			
			// check if both operands are integer, if not throw error
			if (leftResult.isInteger() && rightResult.isInteger()) {
									 
				// complete operation and update environment
				if (this.operation().equals("LT")) {

					// calculate true iff left operand is smaller than right operand
					boolResult = 	leftResult.asInteger() < 
									rightResult.asInteger();
									
					result = Asts.expVal(boolResult);
					
					return result;
						
				} else if (this.operation().equals("EQ")) {
					
					// calculate true iff both values are the same
					boolResult = 	leftResult.asInteger() == 
									rightResult.asInteger();
					
					result = Asts.expVal(boolResult);
					
					return result;
					
				} else if (this.operation().equals("GT")) {
					
					// calculate true iff left operand is larger than right operand
					boolResult = 	leftResult.asInteger() > 
									rightResult.asInteger();
					
					result = Asts.expVal(boolResult);
					
					return result;

				} else if (this.operation().equals("PLUS")) {
					
					// calculates left plus right
					intResult = 	leftResult.asInteger() + 
									rightResult.asInteger();
					
					result = Asts.expVal(intResult);
					
					return result;

				} else if (this.operation().equals("MINUS")) {
					
					// calculates left minus right
					intResult = 	leftResult.asInteger() - 
									rightResult.asInteger();
					
					result = Asts.expVal(intResult);
					
					return result;

				} else if (this.operation().equals("TIMES")) {
					
					// calculates left times right
					intResult = 	leftResult.asInteger() * 
									rightResult.asInteger();
					
					
					
					result = Asts.expVal(intResult);
					
					return result;
					
				} else {
					
					// throw error - unknown operation
					throw new RuntimeException("processArithmetic:Unknown " + 
								"or no given operation. Operation must be either " +
								"LT, GT, PLUS, MINUS, TIMES. Operation: " + 
								this.operation());
				}
				
			} else {
				
				// throw error
				throw new RuntimeException("ArithmeticExp.value():Operands are of " +
								"different types, they must match. LeftOperand: " +
								leftResult + " RightOperand: " +
								rightResult);
			}
		} catch (Exception ex) {
			throw new RuntimeException("ArithmeticExp.value()"+ex.getMessage());
		}
	}
	
	// Returns true iff this Exp is a constant, otherwise the other methods
	// return false
    @Override
    public boolean isArithmetic() { return true; }

	// if the corresponding predicate above is true, return this, 
	// otherwise throw RuntimeException
	
	@Override
    public ArithmeticExp asArithmetic() { 
		return this; 
	}
	
	public String toString(boolean asAst) {
		String output = "";
		
		if (asAst) {
			output = "Asts.arithmeticExp( " + this.leftOperand().toString(true);
			output += " , " + this.operation();
			output += " , " + this.rightOperand().toString(true) + ")";
		
		} else {
			output = this.toString();
		}
		
		return output;
	}
}
