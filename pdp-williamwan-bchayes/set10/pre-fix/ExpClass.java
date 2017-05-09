import java.util.*;

abstract class ExpClass extends AstClass implements Exp {

    // Returns true iff this Exp is a constant, identifier,
    // lambda, arithmetic, call, or if expression (respectively).

    public boolean isConstant() { return false; }
    public boolean isIdentifier() { return false; }
    public boolean isLambda() { return false; }
    public boolean isArithmetic() { return false; }
    public boolean isCall() { return false; }
    public boolean isIf() { return false; }

    // Precondition: the corresponding predicate above is true.
    // Returns this.
    // (These methods amount should eliminate most casts.)

    public ConstantExp   asConstant() { 
			throw new RuntimeException(this.getClass().getSimpleName()+
										":asConstant():" +
										"Unable to return a " +
										"ConstantExp, incorrect type."); 
	}
	
    public IdentifierExp asIdentifier() { 
			throw new RuntimeException(this.getClass().getSimpleName()+
										":asIdentifier():" +
										"Unable to return a " +
										"IdentifierExp, incorrect type."); 
	}
    public LambdaExp 	asLambda() { 
			throw new RuntimeException(this.getClass().getSimpleName()+
										":asLambda():" +
										"Unable to return a " +
										"LambdaExp, incorrect type."); 
	}
    public ArithmeticExp asArithmetic() { 
			throw new RuntimeException(this.getClass().getSimpleName() +
										":asArithmetic():" +
										"Unable to return a " +
										"ArithmeticExp, incorrect type."); 
	}
    public CallExp       asCall() { 
			throw new RuntimeException(this.getClass().getSimpleName()+
										":asCall():" +
										"Unable to return a " +
										"CallExp, incorrect type."); 
	}	
    public IfExp 		asIf() {
			throw new RuntimeException(this.getClass().getSimpleName()+
										":asIf():" +
										"Unable to return a " +
										"IfExp, incorrect type."); 
	}
	
	// Returns true iff this Ast is for a expression.
	@Override
	public boolean isExp() {
		return true;
	}
	
	// Returns a representation of that expression.
	@Override
	public Exp asExp() {
		return this;
	}
	
    // Returns the value of this expression when its free variables
    //     have the values associated with them in the given Map.
    // May run forever if this expression has no value.
    // May throw a RuntimeException if some free variable of this
    //     expression is not a key of the given Map or if a type
    //     error is encountered during computation of the value.
    abstract public ExpVal value (Map<String,ExpVal> env);
	


}