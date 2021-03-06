// A Def is an object of any class that implements the Def interface.
//
// Interpretation: A Def represents one definition of the source program.

import java.util.*;

class DefClass extends AstClass implements Def {

	// fields
	String identifier;
	Exp expression;
	
	// constructor
	public DefClass(String identifier, Exp exp) {
		
		if (exp.isConstant() || exp.isLambda()) {
			this.identifier = identifier;
			this.expression = exp;
		} else {
			throw new RuntimeException("Def:Constructor:Invalid expression argument passed, ConstantExp or LambdaExp expression required.");
		}
	}

    // Returns the left hand side of this definition,
    // which will be an identifier represented as a String.

    public String lhs() {
		return this.identifier;
	}

    // Returns the right hand side of this definition,
    // which will be a ConstantExp or a LambdaExp.

    public Exp rhs() {
		return this.expression;
	}
	
	@Override
    public boolean isDef() {
		return true;
	}
    
	@Override
	public Def asDef() {
		return this;
	}
	
	public String toString() {
		
		String output = "";
		output = "(" + this.identifier + " ";
		if (this.expression != null) {
			output += this.expression.toString();
		} else {
			output += "NULL";
		}
		output += ")";
		
		return output;
	}
	
}
