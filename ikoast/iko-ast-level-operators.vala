/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.LevelOperators : ExpressionTransformer {
  public override void visit_binary_expression(BinaryExpression be) {
    assert(be.op != Operator.MINUS);

    var left = transform(be.left);
    var right = transform(be.right);

    if(be.op == Operator.EQUAL ||
       be.op == Operator.MUL   ||
       be.op == Operator.PLUS)
    {
      var me = new MultiExpression(be.op, null);
      if(left is MultiExpression) {
        var me_sub = left as MultiExpression;
        if(me_sub.op == be.op)
          me.add_operand_list(me_sub.operands);
        else
          me.operands.add(me_sub);
      } else
        me.operands.add(left);
      if(right is MultiExpression) {
        var me_sub = right as MultiExpression;
        if(me_sub.op == be.op)
          me.add_operand_list(me_sub.operands);
        else
          me.operands.add(me_sub);
      } else
        me.operands.add(right);
      q.push_head(me);
    } else
      q.push_head(new BinaryExpression(be.op, left, right));
  }
}
