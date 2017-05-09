// Constructor template for DefClass:
//     new DefClass (lhs, rhs)
// Interpretation:
//     lhs returns the left hand side of this definition,
//         which will be an identifier represented as a String.
//     rhs returns the right hand side of this definition,
//         which will be a ConstantExp or a LambdaExp

import java.util.List;

class DefClass implements Def {

    // DefClass Fields

    String l;
    Exp r;

    // Costructor
    DefClass (String l, Exp r){
        this.l = l;
        this.r = r;
    }

    // DefClass Public Methods

    // returns the left hand side of this definition,
    // which will be an identifier represented as a String
    public String lhs() {
        return this.l;
    }

    // returns the right hand side of this definition,
    // which will be a ConstantExp or a LambdaExp
    public Exp rhs() {
        return this.r;
    }

    @Override
    public boolean isPgm() {
        return false;
    }

    @Override
    public boolean isDef() {
        return false;
    }

    @Override
    public boolean isExp() {
        return false;
    }

    @Override
    public List<Def> asPgm() {
        return null;
    }

    @Override
    public Def asDef() {
        return null;
    }

    @Override
    public Exp asExp() {
        return null;
    }
}
