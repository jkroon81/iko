/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.ExpandSymbols : ExpressionTransformer {
  const int MAX_POWER_EXPANSION_FACTORS = 5;

  public override void visit_division_expression(DivisionExpression de_in) {
    base.visit_division_expression(de_in);
    var de = q.pop_head() as DivisionExpression;

    if(de.num is AdditiveExpression) {
      var num = de.num as AdditiveExpression;
      var ae = new AdditiveExpression();
      foreach(var op in num.operands) {
        ae.operands.add(new DivisionExpression(op, de.den));
      }
      q.push_head(ae);
    } else
      q.push_head(de);
  }

  public override void visit_multiplicative_expression(MultiplicativeExpression me_in) {
    base.visit_multiplicative_expression(me_in);
    var me = q.pop_head() as MultiplicativeExpression;

    var ae = new AdditiveExpression();
    foreach(var op in me.operands) {
      if(op is AdditiveExpression) {
        var ae_sub = op as AdditiveExpression;
        me.operands.remove(ae_sub);
        foreach(var f1 in ae_sub.operands) {
          var t = new MultiplicativeExpression.list(me.operands);
          t.operands.add(f1);
          ae.operands.add(transform(t));
        }
        break;
      }
    }
    if(ae.operands.size > 0)
      q.push_head(ae);
    else
      q.push_head(me);
  }

  public override void visit_power_expression(PowerExpression pe_in) {
    base.visit_power_expression(pe_in);
    var pe = q.pop_head() as PowerExpression;

    if(pe.bais is MultiplicativeExpression) {
      var bais = pe.bais as MultiplicativeExpression;
      var me = new MultiplicativeExpression();
      foreach(var op in bais.operands)
        me.operands.add(transform(new PowerExpression(op, pe.exp)));
      q.push_head(me);
    } else if(pe.bais is AdditiveExpression) {
      if (pe.exp is IntegerLiteral) {
        var exp = (pe.exp as IntegerLiteral).value.to_int();
        if(exp <= MAX_POWER_EXPANSION_FACTORS) {
          var me = new MultiplicativeExpression();
          for(int i = 0; i < exp; i++) {
            me.operands.add(pe.bais);
          }
          q.push_head(transform(me));
        } else
          q.push_head(pe);
      } else
        q.push_head(pe);
    } else if(pe.exp is AdditiveExpression) {
      var exp = pe.exp as AdditiveExpression;
      var me = new MultiplicativeExpression();
      foreach(var op in exp.operands)
        me.operands.add(transform(new PowerExpression(pe.bais, op)));
      q.push_head(me);
    } else
      q.push_head(pe);
  }
}
