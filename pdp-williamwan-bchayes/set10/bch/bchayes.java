


import java.lang.*;
import java.util.*;

public class bchayes {

	public static void main(String[] args) {
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
																									
		ExpVal result = Programs.run( Asts.list(def1), Asts.list(Asts.expVal (5)));
		
	}
}