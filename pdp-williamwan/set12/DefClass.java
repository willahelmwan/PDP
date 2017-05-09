// Constructor template for DefClass
//   new DefClass(lhs, rhs)
// Interpretation:
//   lhs is the left hand side of this definition,
//       which is an identifier represented as a string.
//   rhs is the right hand side of this definition,
//       which is a ConstantExp or a LambdaExp.

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
			throw new RuntimeException(
			     "Def:Constructor:Invalid expression argument passed, " +
				 "ConstantExp or LambdaExp expression required.");
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
	
	// Returns true iff the Ast is for a definition.
	@Override
    public boolean isDef() {
		return true;
	}
    
	// Returns a representation of that definition.
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
