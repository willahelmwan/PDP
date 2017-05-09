	
import java.lang.*;
import java.util.*;

public class InterpreterTest2 {

	public static void main(String[] args) {
		
		// variables
		List<Def> pgm = null;
		List<ExpVal> pgmArgs = null;
		ExpVal result = null;
		
		// AST variables
		Def def1,def2 = null;
		Exp exp1,exp2,exp3,exp4 = null;

		System.out.println("------------------------------------------------");
		
		// ---------------------------------------------------------------------
		// Def w/ Constnat AST
		System.out.println("AST based on in class example");
		System.out.println("(lambda (x,y) \n" +
						   "    (lambda (f) \n" + 
						   "          x + y + f(7,8) + x + y) \n" +
						   "    ((lambda (y,z) y * z)))\n" +
						   " ---------------------------------\n" + 
						   " Input: 3 , 4 \n" +
						   " Result: 70\n" +
						   " ---------------------------------");
		
		try {
			
			exp4 = Asts.identifierExp("y");
			
			exp3 = Asts.arithmeticExp( Asts.identifierExp("x"),
										"PLUS",
										exp4 );
			
			exp2 = Asts.arithmeticExp( Asts.callExp(Asts.identifierExp ("f"),
										Asts.list ( Asts.constantExp( Asts.expVal(7)),
													Asts.constantExp( Asts.expVal(8)) ) ),
										"PLUS",
										exp3);
			
			exp1 = Asts.arithmeticExp( Asts.identifierExp("y"),
										"PLUS",
										exp2 );
			
			def1 = Asts.def("example", 
					Asts.lambdaExp( Asts.list("x","y"),
						Asts.arithmeticExp( Asts.identifierExp("x"),
											"PLUS",
											exp1 )));
											
			def2 = Asts.def("f",
							Asts.lambdaExp( Asts.list("y","z"),
											Asts.arithmeticExp( Asts.identifierExp( "y" ), "TIMES", Asts.identifierExp( "z" ))));
								
			// set args
			pgm = Asts.list(def1,def2);
			pgmArgs = Asts.list(Asts.expVal(3),Asts.expVal(4));
			
			// run
			result = Programs.run(pgm, pgmArgs);
			
			System.out.println("RESULT: "+result.toString());
		
		} catch (Exception ex) {
			System.out.println("ERROR: " + ex.toString());
		}
										
		
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