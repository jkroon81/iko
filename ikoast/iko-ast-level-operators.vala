/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.LevelOperators : ExpressionTransformer {
  public override void visit_additive_expression(AdditiveExpression ae_in) {
    base.visit_additive_expression(ae_in);
    var ae = q.pop_head() as AdditiveExpression;

    var ae_new = new AdditiveExpression();
    foreach(var op in ae.operands) {
      if(op is AdditiveExpression)
        foreach(var sub_op in (op as AdditiveExpression).operands)
          ae_new.operands.prepend(sub_op);
      else
        ae_new.operands.prepend(op);
    }
    ae_new.operands.reverse();
    q.push_head(ae_new);
  }

  public override void visit_multiplicative_expression(MultiplicativeExpression me_in) {
    base.visit_multiplicative_expression(me_in);
    var me = q.pop_head() as MultiplicativeExpression;

    var me_new = new MultiplicativeExpression();
    foreach(var op in me.operands) {
      if(op is MultiplicativeExpression)
        foreach(var sub_op in (op as MultiplicativeExpression).operands)
          me_new.operands.prepend(sub_op);
      else
        me_new.operands.prepend(op);
    }
    me_new.operands.reverse();
    q.push_head(me_new);
  }
}
