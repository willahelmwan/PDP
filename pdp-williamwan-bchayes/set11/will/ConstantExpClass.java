// Constructor template for ConstantExpClass
//   new ConstantExpClass(val)
// Interpretation:
//   val is a boolean or an integer value. 

import java.util.*;

class ConstantExpClass extends ExpClass implements ConstantExp {
	
	// ConstantExp Fields
	private ExpVal val;
	
	// Constructor - boolean
	public ConstantExpClass(boolean bool) {
		this.val = Asts.expVal(bool);
	}
	
	// Constructor - integer (long)
	public ConstantExpClass(long integer) {
		this.val = Asts.expVal(integer);
	}
	
	// returns the current expression
	public Exp asExp() {
		return this;
	}
	
	// Returns the value of this constant expression.
	
	public ExpVal value() {
		return this.val;
	}

	// Returns the value of this expression when its free variables
    //     have the values associated with them in the given Map.
    // May run forever if this expression has no value.
    // May throw a RuntimeException if some free variable of this
    //     expression is not a key of the given Map or if a type
    //     error is encountered during computation of the value.
    public ExpVal value (Map<String,ExpVal> env) {
		if (env.containsKey(ProgramsH.getExpKey(this, env))) {
			return env.get(ProgramsH.getExpKey(this, env));
		} else {
			return this.val;
		}
	}
	
	// Returns true iff this Exp is a constant, otherwise the other methods
	// return false
    @Override
    public boolean isConstant() { return true; }

	// if the corresponding predicate above is true, return this, 
	// otherwise throw RuntimeException
	
	@Override 
	public int hashCode() {
		return this.toString().hashCode();
	}
	
	@Override
    public ConstantExp asConstant() { 
		return this; 
	}
	
	public String toString() {
		return "ConstantExp:" + this.val.toString();
	}
	
	public String toString(boolean asAst) {
		String output = "";

		if (asAst) {
			output = "Asts.constantExp(Asts.expVal(" + this.val.toString() + "))";
		} else {
			output = this.toString();
		}

		return output;
	}
	
	
	
}