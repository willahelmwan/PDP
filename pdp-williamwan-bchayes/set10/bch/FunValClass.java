
import java.util.Map;

class FunValClass extends ExpValClass implements FunVal {


	// Constructor
	public FunValClass(LambdaExp lmda, Map<String,ExpVal> env) {
		super(lmda, env);
	}
	
	// return LambdaExp 
    public LambdaExp code() {
		return this.lmda;
	}

    // Returns the environment that maps the free variables of that
    // lambda expression to their values.

    public Map<String,ExpVal> environment() {
		return this.env;
	}
	
}