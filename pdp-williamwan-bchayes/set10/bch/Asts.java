
import java.lang.*;
import java.util.*;

public class Asts {

	// Static factory methods for Def

	// Returns a Def with the given left and right hand sides.

	public static Def def (String id1, Exp rhs) { 
	
		Def d = new DefClass(id1, rhs);
		return d;
	}

	// Static factory methods for Exp

	// Returns an ArithmeticExp representing e1 op e2.

	public static ArithmeticExp arithmeticExp (Exp e1, String op, Exp e2) {
		
		ArithmeticExp ae = new ArithmeticExpClass(e1, op, e2);
		return ae;
	}

	// Returns a CallExp with the given operator and operand expressions.

	public static CallExp callExp (Exp operator, List<Exp> operands) { 

		CallExp ce = new CallExpClass(operator, operands);
		return ce;
	}

	// Returns a ConstantExp with the given value.

	public static ConstantExp constantExp (ExpVal value) { 
		ConstantExp ce;
		if (value.isBoolean()) {
			ce = new ConstantExpClass(value.asBoolean());
		} else if (value.isInteger()) {
			ce = new ConstantExpClass(value.asInteger());
		} else {
			throw new RuntimeException("Asts:constantExp():Type error, " +
										"method requires a boolean or " +
										"integer value.");
		}
		return ce;
	}

	// Returns an IdentifierExp with the given identifier name.

	public static IdentifierExp identifierExp (String id) { 

		IdentifierExp ie =  new IdentifierExpClass(id);
		return ie;
	}

	// Returns an IfExp with the given components.

	public static IfExp ifExp (Exp testPart, Exp thenPart, Exp elsePart) {

		IfExp ife = new IfExpClass(testPart, thenPart, elsePart);
		return ife;
	}

	// Returns a LambdaExp with the given formals and body.

	public static LambdaExp lambdaExp (List<String> formals, Exp body) { 
	
		LambdaExp lmda = new LambdaExpClass(formals, body);
		return lmda;
	
	}

	// Static factory methods for ExpVal

	// Returns a value encapsulating the given boolean.

	public static ExpVal expVal (boolean b) {

		ExpVal ev = new ExpValClass(b);
		return ev;
	}

	// Returns a value encapsulating the given (long) integer.

	public static ExpVal expVal (long n) { 

		ExpVal ev = new ExpValClass(n);
		return ev;
	}

	// Returns a value encapsulating the given lambda expression
	// and environment.

	public static ExpVal expVal (LambdaExp exp, Map<String,ExpVal> env) { 
		ExpVal ev = new ExpValClass(exp, env);
		return ev;
	}

	// Static methods for creating short lists
	
	// - empty list
	public static <X> List<X> list() {
		List<X> l = new ArrayList<X>();
		return l;
	}

	// - list with 1 element
	public static <X> List<X> list (X x1) { 

		List<X> l = new ArrayList<X>();
		l.add(x1);
		return l;

	}

	// - list with 2 elements
	public static <X> List<X> list (X x1, X x2) { 

		List<X> l = new ArrayList<X>();
		l.add(x1);
		l.add(x2);
		return l;

	}

	// - list with 3 elements
	public static <X> List<X> list (X x1, X x2, X x3) { 
	
		List<X> l = new ArrayList<X>();
		l.add(x1);
		l.add(x2);
		l.add(x3);
		return l;

	}

	// - list with 3 elements
	public static <X> List<X> list (X x1, X x2, X x3, X x4) { 

		List<X> l = new ArrayList<X>();
		l.add(x1);
		l.add(x2);
		l.add(x3);
		l.add(x4);
		return l;

	}
	
}