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

    if(de.den is Literal) {
      var den = (de.den as Literal).value.to_double();
      if(den == 1.0)
        q.push_head(de.num);
      else if(de.num is Literal) {
        var num = (de.num as Literal).value.to_double();
        q.push_head(new FloatLiteral((num / den).to_string()));
      } else
        q.push_head(de);
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
        var nvalue = (op as Literal).value.to_double();
        lterm = new FloatLiteral((lterm.value.to_double() + nvalue).to_string());
      } else
        ae_new.operands.add(op);
    }
    if(lterm.value.to_double() != 0.0)
      ae_new.operands.add(lterm);
    switch(ae_new.operands.size) {
    case 0:
      q.push_head(IntegerLiteral.ZERO);
      break;
    case 1:
      q.push_head(ae_new.operands[0]);
      break;
    default:
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
      if(op is Literal) {
        var nvalue = (op as Literal).value.to_double();
        if(nvalue == 0.0) {
          q.push_head(IntegerLiteral.ZERO);
          return;
        } else
          lfactor = new FloatLiteral((lfactor.value.to_double() * nvalue).to_string());
      } else
        me_new.operands.add(op);
    }
    if(lfactor.value.to_double() != 1.0)
      me_new.operands.add(lfactor);
    switch(me_new.operands.size) {
    case 0:
      q.push_head(IntegerLiteral.ONE);
      break;
    case 1:
      q.push_head(me_new.operands[0]);
      break;
    default:
      q.push_head(me_new);
      break;
    }
  }

  public override void visit_power_expression(PowerExpression pe_in) {
    base.visit_power_expression(pe_in);
    var pe = q.pop_head() as PowerExpression;

    if(pe.exp is Literal) {
      var exp = (pe.exp as Literal).value.to_double();
      if(exp == 0.0)
        q.push_head(IntegerLiteral.ONE);
      else if(exp == 1.0)
        q.push_head(pe.bais);
      else if(pe.bais is Literal) {
        var bais = (pe.bais as Literal).value.to_double();
        if(bais == 1.0)
          q.push_head(IntegerLiteral.ONE);
        else
          q.push_head(pe);
      } else
        q.push_head(pe);
    } else
      q.push_head(pe);
  }
}
