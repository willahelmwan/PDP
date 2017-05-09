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
		
		boolean boolResult;
		long intResult;
		
		// check if both operands are integer, if not throw error
		if (this.leftOperand().value(env).isInteger() &&
			this.rightOperand().value(env).isInteger()) {
								 
			// complete operation and update environment
			if (this.operation().equals("LT")) {

				// calculate true iff left operand is smaller than right operand
				boolResult = 	this.leftOperand().value(env).asInteger() < 
								this.rightOperand().value(env).asInteger();
				
				// update environment with calculated value
				env = ProgramsH.extend(env, ProgramsH.getExpKey(this, env), 
								 Asts.expVal(boolResult));
					
			} else if (this.operation().equals("EQ")) {
				
				// calculate true iff both values are the same
				boolResult = 	this.leftOperand().value(env).asInteger() == 
								this.rightOperand().value(env).asInteger();
				
				// update environment with calculated value
				env = ProgramsH.extend(env, ProgramsH.getExpKey(this, env), 
								 Asts.expVal(boolResult));
				
			} else if (this.operation().equals("GT")) {
				
				// calculate true iff left operand is larger than right operand
				boolResult = 	this.leftOperand().value(env).asInteger() > 
								this.rightOperand().value(env).asInteger();
				
				// update environment with calculated value
				env = ProgramsH.extend(env, ProgramsH.getExpKey(this, env), 
								 Asts.expVal(boolResult));

			} else if (this.operation().equals("PLUS")) {
				
				// calculates left plus right
				intResult = 	this.leftOperand().value(env).asInteger() + 
								this.rightOperand().value(env).asInteger();
				
				// update environment with calculated value
				env = ProgramsH.extend(env, ProgramsH.getExpKey(this, env), 
								 Asts.expVal(intResult));

			} else if (this.operation().equals("MINUS")) {
				
				// calculates left minus right
				intResult = 	this.leftOperand().value(env).asInteger() - 
								this.rightOperand().value(env).asInteger();
				
				// update environment with calculated value
				env = ProgramsH.extend(env, ProgramsH.getExpKey(this, env), 
								 Asts.expVal(intResult));

			} else if (this.operation().equals("TIMES")) {
				
				// calculates left times right
				intResult = 	this.leftOperand().value(env).asInteger() * 
								this.rightOperand().value(env).asInteger();
				
				// update environment with calculated value
				env = ProgramsH.extend(env, ProgramsH.getExpKey(this, env), 
								 Asts.expVal(intResult));
				
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
							this.leftOperand().value(env) + " RightOperand: " +
							this.rightOperand().value(env));
		}
		
		if (env.containsKey(ProgramsH.getExpKey(this, env))) {
			return env.get(ProgramsH.getExpKey(this, env));
		} else {
			return null;
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
