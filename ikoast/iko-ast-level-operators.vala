/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.LevelOperators : ExpressionTransformer {
  public override void visit_binary_expression(BinaryExpression be_in) {
    assert(be_in.op != Operator.MINUS);
    base.visit_binary_expression(be_in);
    var be = q.pop_head() as BinaryExpression;

    if(be.op == Operator.EQUAL ||
       be.op == Operator.MUL   ||
       be.op == Operator.PLUS)
    {
      var me = new MultiExpression(be.op, null);
      if(be.left is MultiExpression) {
        var me_sub = be.left as MultiExpression;
        if(me_sub.op == be.op)
          me.add_operand_list(me_sub.operands);
        else
          me.operands.add(me_sub);
      } else
        me.operands.add(be.left);
      if(be.right is MultiExpression) {
        var me_sub = be.right as MultiExpression;
        if(me_sub.op == be.op)
          me.add_operand_list(me_sub.operands);
        else
          me.operands.add(me_sub);
      } else
        me.operands.add(be.right);
      q.push_head(me);
    } else
      q.push_head(be);
  }
}
