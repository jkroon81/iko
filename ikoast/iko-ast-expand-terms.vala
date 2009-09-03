/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.ExpandTerms : ExpressionTransformer {
  public override void visit_multiplicative_expression(MultiplicativeExpression me_in) {
    base.visit_multiplicative_expression(me_in);
    var me = q.pop_head() as MultiplicativeExpression;

    var op_list = new Gee.ArrayList<Expression>();
    foreach(var op in me.operands) {
      if(op is AdditiveExpression) {
        var ae_sub = op as AdditiveExpression;
        me.operands.remove(ae_sub);
        foreach(var f1 in ae_sub.operands) {
          var t = new MultiplicativeExpression.list(me.operands);
          t.operands.add(f1);
          op_list.add(transform(t));
        }
        break;
      }
    }
    if(op_list.size > 0)
      q.push_head(new AdditiveExpression.list(op_list));
    else
      q.push_head(me);
  }

  public override void visit_power_expression(PowerExpression pe_in) {
    base.visit_power_expression(pe_in);
    var pe = q.pop_head() as PowerExpression;

    if(pe.right is Literal) {
      var exp = (pe.right as Literal).value.to_double();
      if(exp == Math.floor(exp)) {
        if(exp > 0.0) {
          var me = new MultiplicativeExpression();
          for(int i = 0; i < Math.floor(exp); i++) {
            me.operands.add(pe.left);
          }
          q.push_head(transform(me));
          return;
        }
      }
    }
    if(pe.right is AdditiveExpression) {
      var ae_right = pe.right as AdditiveExpression;
      var me = new MultiplicativeExpression();
      foreach(var op in ae_right.operands)
        me.operands.add(transform(new PowerExpression(pe.left, op)));
      q.push_head(me);
      return;
    }
    if(pe.left is MultiplicativeExpression) {
      var me_left = pe.left as MultiplicativeExpression;
      var me = new MultiplicativeExpression();
      foreach(var op in me_left.operands)
        me.operands.add(transform(new PowerExpression(op, pe.right)));
      q.push_head(me);
      return;
    }
    q.push_head(pe);
  }
}
