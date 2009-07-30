/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.SimplifyRationals : ExpressionTransformer {
  public override void visit_binary_expression(BinaryExpression be_in) {
    assert(be_in.op == Operator.DIV ||
           be_in.op == Operator.POWER);
    base.visit_binary_expression(be_in);
    var be = q.pop_head() as BinaryExpression;

    if(be.op == Operator.DIV) {
      if(be.left is BinaryExpression) {
        var be_left = be.left as BinaryExpression;
        var right_new = new MultiExpression(Operator.MUL, null);
        right_new.operands.add(be_left.right);
        right_new.operands.add(be.right);
        q.push_head(new BinaryExpression(Operator.DIV, be_left.left, right_new));
      } else if(be.right is BinaryExpression) {
        var be_right = be.right as BinaryExpression;
        var left_new = new MultiExpression(Operator.MUL, null);
        left_new.operands.add(be.left);
        left_new.operands.add(be_right.left);
        q.push_head(new BinaryExpression(Operator.DIV, left_new, be_right.right));
      } else
        q.push_head(be);
    } else
      q.push_head(be);
  }

  public override void visit_multi_expression(MultiExpression me_in) {
    assert(me_in.op == Operator.EQUAL ||
           me_in.op == Operator.MUL   ||
           me_in.op == Operator.PLUS);
    base.visit_multi_expression(me_in);
    var me = q.pop_head() as MultiExpression;

    if(me.op == Operator.MUL) {
      var op_list = new ArrayList<Expression>();
      for(var i = 0; i < me.operands.size; i++) {
        var op = me.operands[i];
        if(op is BinaryExpression) {
          var be_sub = op as BinaryExpression;
          var left = new MultiExpression(Operator.MUL, null);
          if(op_list.size > 0)
            left.add_operand_list(op_list);
          for(var j = i + 1; j < me.operands.size; j++)
            left.operands.add(me.operands[j]);
          left.operands.add(be_sub.left);
          q.push_head(new BinaryExpression(Operator.DIV, left, be_sub.right));
          return;
        } else
          op_list.add(op);
      }
    }
    q.push_head(me);
  }
}
