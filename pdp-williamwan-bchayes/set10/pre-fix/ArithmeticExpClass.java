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

		if (validOperators.contains(binaryOp)) {
			this.leftOper = leftOper;
			this.binaryOp = binaryOp;
			this.rightOper = rightOper;	
		} else {
			throw new RuntimeException("ArithmeticExp:Invalid Operator (" +
										binaryOp + ") not recognized.");
		}
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
	
	// Not sure how to implement this
	public ExpVal value(Map<String,ExpVal> env) {
		if (env.containsKey(ProgramsH.getExpKey(this, 
											    (IMap<String,ExpVal>) env))) {
			return env.get(ProgramsH.getExpKey(this, 
											   (IMap<String,ExpVal>) env));
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
