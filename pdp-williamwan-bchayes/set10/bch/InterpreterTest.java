	
import java.lang.*;
import java.util.*;

public class InterpreterTest {

	public static void main(String[] args) {
		
		// variables
		List<Def> pgm = null;
		List<ExpVal> pgmArgs = null;
		ExpVal result = null;
		
		// AST variables
		Def def1 = null;
		Exp exp1 = null;

		System.out.println("------------------------------------------------");
		
		// ---------------------------------------------------------------------
		// Def w/ Constnat AST
		System.out.println("AST with only a constant expression");
		
		try {
			
			def1 = Asts.def("a", 
							Asts.constantExp(Asts.expVal (2)));
								
			// set args
			pgm = Asts.list(def1);
			pgmArgs = Asts.list();
			
			// run
			result = Programs.run(pgm, pgmArgs);
		
		} catch (Exception ex) {
			result = null;
		}
		
		// output result
		if (result!=null) {
			System.out.println("RESULT: "+result.toString());
		} else {
			System.out.println("RESULT: NONE");
		}
		System.out.println("------------------------------------------------");
		
		// ---------------------------------------------------------------------
		// Def w/ lambda, arithmetic and 2 passed values to do a + b
		
		System.out.println("AST simulates adding 2 numbers");
		
		try {
		
			exp1 = Asts.arithmeticExp(Asts.identifierExp("a"),
									  "PLUS",
									  Asts.identifierExp("b"));
			
			def1 = Asts.def("add-two",
							Asts.lambdaExp( Asts.list("a","b"),
											exp1 ));
											
			// set args
			pgm = Asts.list(def1);
			pgmArgs = Asts.list(Asts.expVal (2),
								Asts.expVal (3));
			
			// run
			result = Programs.run(pgm, pgmArgs);
		
		} catch (Exception ex) {
			result = null;
		}
		
		// output result
		if (result!=null) {
			System.out.println("RESULT: "+result.toString());
		} else {
			System.out.println("RESULT: NONE");
		}
		System.out.println("------------------------------------------------");
										
		
/*		
		// fact (n) if n < 2 then n else n * fact (n - 1)
		Exp exp1
			= Asts.arithmeticExp (Asts.identifierExp ("n"),
								  "MINUS",
								  Asts.constantExp (Asts.expVal (1)));
		Exp call1
			= Asts.callExp (Asts.identifierExp ("fact"),
							Asts.list (exp1));
		Exp testPart
			= Asts.arithmeticExp (Asts.identifierExp ("n"),
								  "EQ",
								  Asts.constantExp (Asts.expVal (0)));
		Exp thenPart
			= Asts.constantExp (Asts.expVal (1));
		Exp elsePart
			= Asts.arithmeticExp (Asts.identifierExp ("n"),
								  "TIMES",
								  call1);
		Def def1
			= Asts.def ("fact",
						Asts.lambdaExp (Asts.list ("n"),
										Asts.ifExp (testPart,
													thenPart,
													elsePart)));
	
	
	    pgm = Asts.list(def1);
		pgmArgs = Asts.list(Asts.expVal (5));
												
		result = Programs.run( pgm, pgmArgs);
		System.out.println (result);
		
*/	
	}
}