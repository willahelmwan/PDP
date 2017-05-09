
import java.util.*;
import java.lang.*;

class SimpleTest {

	public static void main(String[] args) {

		Def def1 = Asts.def("main",
					Asts.lambdaExp( Asts.list("n"),
						Asts.arithmeticExp( Asts.constantExp(Asts.expVal(1)),
											"PLUS",
											Asts.identifierExp("n") ) ) );
		
		List<Def> pgm = Asts.list( def1 );
		List<ExpVal> pgmArgs = Asts.list( Asts.expVal(5));
		
		ExpVal result = Programs.run( pgm, pgmArgs );
		
		System.out.println(result.toString());

	}

}