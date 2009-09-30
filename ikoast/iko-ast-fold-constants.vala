/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.FoldConstants : ExpressionTransformer {
  public override void visit_division_expression(DivisionExpression de_in) {
    base.visit_division_expression(de_in);
    var de = q.pop_head() as DivisionExpression;

    if(de.den.compare_to(IntegerLiteral.ONE) == 0)
      q.push_head(de.num);
    else if(de.num is Literal && de.den is Literal) {
      var num = (de.num as Literal).value.to_double();
      var den = (de.den as Literal).value.to_double();
      q.push_head(new FloatLiteral((num / den).to_string()));
    } else
      q.push_head(de);
  }

  public override void visit_additive_expression(AdditiveExpression ae_in) {
    base.visit_additive_expression(ae_in);
    var ae = q.pop_head() as AdditiveExpression;

    var ae_new = new AdditiveExpression();
    Literal lterm = IntegerLiteral.ZERO;
    foreach(var op in ae.operands) {
      if(op is Literal) {
        var t1 = lterm.value.to_double();
        var t2 = (op as Literal).value.to_double();
        lterm = new FloatLiteral((t1 + t2).to_string());
      } else
        ae_new.operands.prepend(op);
    }
    if(lterm.compare_to(IntegerLiteral.ZERO) != 0)
      ae_new.operands.prepend(lterm);
    switch(ae_new.operands.length()) {
    case 0:
      q.push_head(IntegerLiteral.ZERO);
      break;
    case 1:
      q.push_head(ae_new.operands.nth_data(0));
      break;
    default:
      ae_new.operands.reverse();
      q.push_head(ae_new);
      break;
    }
  }

  public override void visit_multiplicative_expression(MultiplicativeExpression me_in) {
    base.visit_multiplicative_expression(me_in);
    var me = q.pop_head() as MultiplicativeExpression;

    var me_new = new MultiplicativeExpression();
    Literal lfactor = IntegerLiteral.ONE;
    foreach(var op in me.operands) {
      if(op.compare_to(IntegerLiteral.ZERO) == 0) {
        q.push_head(IntegerLiteral.ZERO);
        return;
      }
      if(op is Literal) {
        var f1 = lfactor.value.to_double();
        var f2 = (op as Literal).value.to_double();
        lfactor = new FloatLiteral((f1 * f2).to_string());
      } else
        me_new.operands.prepend(op);
    }
    me_new.operands.reverse();
    if(lfactor.compare_to(IntegerLiteral.ONE) != 0)
      me_new.operands.prepend(lfactor);
    switch(me_new.operands.length()) {
    case 0:
      q.push_head(IntegerLiteral.ONE);
      break;
    case 1:
      q.push_head(me_new.operands.nth_data(0));
      break;
    default:
      q.push_head(me_new);
      break;
    }
  }

  public override void visit_power_expression(PowerExpression pe_in) {
    base.visit_power_expression(pe_in);
    var pe = q.pop_head() as PowerExpression;

    if(pe.bais.compare_to(IntegerLiteral.ONE) == 0)
      q.push_head(IntegerLiteral.ONE);
    else if(pe.bais.compare_to(IntegerLiteral.MINUS_ONE) == 0 && pe.exp is Literal) {
      var exp = (pe.exp as Literal).value.to_double();
      if(exp == Math.floor(exp)) {
        if(exp / 2.0 == Math.floor(exp / 2.0))
          q.push_head(IntegerLiteral.ONE);
        else
          q.push_head(IntegerLiteral.MINUS_ONE);
      } else
        q.push_head(pe);
    } else if(pe.exp.compare_to(IntegerLiteral.ZERO) == 0)
      q.push_head(IntegerLiteral.ONE);
    else if(pe.exp.compare_to(IntegerLiteral.ONE) == 0)
      q.push_head(pe.bais);
    else
      q.push_head(pe);
  }
}
