// Constructor template for IfExpClass
//   new IfExpClass(testP, thenP, elseP)
// Interpretation:
//   testP is the test part of the if expression.
//   thenP is the then part of the if expression.
//   elseP is the else part of the if expression. 

import java.util.Map;

class IfExpClass extends ExpClass implements IfExp {

	private Exp testP;
	private Exp thenP;
	private Exp elseP;
	
	// Constructor
	public IfExpClass(Exp testP, Exp thenP, Exp elseP) {
		this.testP = testP;
		this.thenP = thenP;
		this.elseP = elseP;
	}

    // Returns the appropriate part of this if expression.

    public Exp testPart() {
		return this.testP;
	}
    public Exp thenPart(){
		return this.thenP;
	}
    public Exp elsePart(){
		return this.elseP;
	}
	
	// should be able to return "this" as ArithmeticExpClass implements Exp
	public Exp asExp() {
		return this;
	}
	
	// Not sure how to implement this
	public ExpVal value(Map<String,ExpVal> env) {
		
		ExpVal result;
		
		// check if test is returning boolean
		if (this.testPart().value(env).isBoolean()) {
		
			// Get's Test Value and checks for true/false to direct then/else
			if (this.testPart().value(env).asBoolean()) {
				
				// TRUE > THEN
				result =  this.thenPart().value(env);
				
				
			} else {
				
				// FALSE > ELSE
				result = this.elsePart().value(env);
			}
		
		} else {
			
			throw new RuntimeException("IfExp:value():Test not returning " +
										"a boolean value.");
			
		}
		
		
		// if result is boolean/integer, return value
		if (result.isBoolean() || result.isInteger()) {
			
			return result;
		
		// else result is FunVal, return FunVal
		} else {
			
			return result.asFunction().code().body().value(env);
		}
	}
	
	// Returns true iff this Exp is a constant, otherwise the other methods
	// return false
    @Override
    public boolean isIf() { return true; }

	// if the corresponding predicate above is true, return this, 
	// otherwise throw RuntimeException
	
	@Override
    public IfExp asIf() { 
		return this; 
	}
}
