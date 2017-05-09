// Constructor template for ExpValClass
//   new ExpValClass(val)
//   new ExpValClass(lmda, env)
// Interpretation:
//   val can be a boolean or an integer value. 
//   lmda is a lambda expression.
//   env is the environment that maps the free variables of that
//       lambda expression to their values.

import java.util.Map;

class ExpValClass implements ExpVal {

	// ExpValClass Fields

	private long integer; 
	private boolean bool;
	protected LambdaExp lmda;
	protected Map<String,ExpVal> env;
	
	private boolean isInt;
	private boolean isBool;
	private boolean isFv;
	
	// ExpValClass Constructors
	public ExpValClass(long integer) {
		
		// set value
		this.integer = integer;
		
		// update predicates
		this.isInt = true;
		this.isBool = false;
		this.isFv = false;
	}
	
	public ExpValClass(boolean bool) {
		
		// assign value
		this.bool = bool;
		
		// update predicates
		this.isInt = false;
		this.isBool = true;
		this.isFv = false;
	}
	
	public ExpValClass(LambdaExp lmda, Map<String,ExpVal> env) {
		
		// assign values
		this.lmda = lmda;
		this.env = env;
		
		// update predicates
		this.isInt = false;
		this.isBool = false;
		this.isFv = true;
	}
	
    // Returns true iff this ExpVal is a boolean, integer, or
    // function (respectively).

    public boolean isBoolean() {
		return this.isBool;
	}
    public boolean isInteger() {
		return this.isInt;
	}
    public boolean isFunction() {
		return this.isFv;
	}

    // Precondition: the corresponding predicate above is true.
    // Returns this.
    // (These methods amount should eliminate most casts.)

    public boolean asBoolean() {
		if (this.isBoolean()) {
			return this.bool;
		} else {
			throw new RuntimeException("ExpValClass:" +
									   "asBoolean():" +
									   "ExpVal is not boolean, cannot " + 
									   "convert value.");
		}
	}
	
	// Returns the constant integer if this is a constan
    public long asInteger() {
		if (this.isInteger()) {
			return this.integer;
		} else {
			throw new RuntimeException("ExpValClass:" +
									   "asInteger():" +
									   "ExpVal is not integer, cannot " + 
									   "convert value.");
		}
	}
    public FunVal asFunction() {
		if (this.isFunction()) {
			return new FunValClass(this.lmda, this.env);
		} else {
			throw new RuntimeException("ExpValClass:" +
										"asFunction():" +
										"ExpVal is not function, cannot " + 
										"convert value.");
		}
	}
	
	// Override toString()
	@Override
	public String toString() {
		if (this.isBoolean()) {
			return this.bool+"";
		} else if (this.isInteger()) {
			return this.integer+"";
		} else {
			return this.lmda.toString();
		}
	}
	
	@Override
	public int hashCode() {
		String s = "";
		s = this.isBool + ":" + this.isInt + ":" + this.isFv;
		if (this.isBool) {
			s += this.bool;
		}
		if (this.isInt) {
			s += this.integer;
		}
		if (this.isFv) {
			for(String f : this.lmda.formals()) {
				s += f+":";
			}
			s += this.lmda.hashCode();
		}
		return s.hashCode();
	}
}