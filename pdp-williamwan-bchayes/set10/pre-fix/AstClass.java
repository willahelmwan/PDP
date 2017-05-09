import java.util.*;

class AstClass implements Ast {

    // Returns true iff this Ast is for a program, definition,
    // or expression, respectively

    public boolean isPgm() {
		return false;
	} 
    public boolean isDef() {
		return false;
	}
    public boolean isExp() {
		return false;
	}

    // Precondition: this Ast is for a program.
    // Returns a representation of that program.

    public List<Def> asPgm() {
		throw new UnsupportedOperationException(
									this.getClass().getSimpleName() + 
								   "asPgm():" +
								   "Unable to return a List<Def>, " +
								   "incorrect type."); 
	}

    // Precondition: this Ast is for a definition.
    // Returns a representation of that definition.

    public Def asDef() {
		throw new UnsupportedOperationException(
									this.getClass().getSimpleName() + 
								   "asDef():" +
								   "Unable to return a Def, " +
								   "incorrect type."); 
	}

    // Precondition: this Ast is for an expression.
    // Returns a representation of that expression.
	
    public Exp asExp() {
		throw new UnsupportedOperationException(
									this.getClass().getSimpleName() + 
								   "asExp():" +
								   "Unable to return a Exp, " +
								   "incorrect type."); 
	}

}