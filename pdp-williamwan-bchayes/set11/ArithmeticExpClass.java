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
		
		ExpVal leftResult, rightResult, result;
		
		leftResult = this.leftOperand().value(env);
		rightResult = this.rightOperand().value(env);
		
		// check if both operands are integer, if not throw error
		if (leftResult.isInteger() && rightResult.isInteger()) {
								 
			// complete operation and update environment
			if (this.operation().equals("LT")) {

				// calculate true iff left operand is smaller than right operand
				result = Asts.expVal(
								leftResult.asInteger() < 
								rightResult.asInteger());
				
				return result;
					
			} else if (this.operation().equals("EQ")) {
				
				// calculate true iff both values are the same
				result = Asts.expVal(
								leftResult.asInteger() == 
								rightResult.asInteger());
				
				return result;
				
			} else if (this.operation().equals("GT")) {
				
				// calculate true iff left operand is larger than right operand
				result = Asts.expVal(
								leftResult.asInteger() > 
								rightResult.asInteger());
				
				return result;

			} else if (this.operation().equals("PLUS")) {
				
				// calculates left plus right
				result = Asts.expVal(
								leftResult.asInteger() + 
								rightResult.asInteger());
				
				return result;

			} else if (this.operation().equals("MINUS")) {
				
				// calculates left minus right
				result = Asts.expVal(
								leftResult.asInteger() - 
								rightResult.asInteger());
				
				return result;

			} else if (this.operation().equals("TIMES")) {
				
				// calculates left times right
				result = Asts.expVal(
								leftResult.asInteger() * 
								rightResult.asInteger());
				
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
			throw new RuntimeException("processArithmetic:Operands are of " +
							"different types, they must match. LeftOperand: " +
							leftResult + " RightOperand: " +
							rightResult);
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

}
