/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.SimplifyRationals : ExpressionTransformer {
  public override void visit_binary_expression(BinaryExpression be) {
    assert(be.op == Operator.DIV ||
           be.op == Operator.POWER);

    var left = transform(be.left);
    var right = transform(be.right);

    if(be.op == Operator.DIV) {
      if(left is BinaryExpression) {
        var be_left = left as BinaryExpression;
        var right_new = new MultiExpression(Operator.MUL, null);
        right_new.add_operand(be_left.right);
        right_new.add_operand(right);
        q.push_head(new BinaryExpression(Operator.DIV, be_left.left, right_new));
      } else if(right is BinaryExpression) {
        var be_right = right as BinaryExpression;
        var left_new = new MultiExpression(Operator.MUL, null);
        left_new.add_operand(left);
        left_new.add_operand(be_right.left);
        q.push_head(new BinaryExpression(Operator.DIV, left_new, be_right.right));
      } else {
        q.push_head(new BinaryExpression(Operator.DIV, left, right));
      }
    } else
      q.push_head(new BinaryExpression(be.op, left, right));
  }

  public override void visit_multi_expression(MultiExpression me) {
    assert(me.op == Operator.EQUAL ||
           me.op == Operator.MUL   ||
           me.op == Operator.PLUS);

    var op_list = new ArrayList<Expression>();

    foreach(var op in me.get_operands())
      op_list.add(transform(op));

    if(me.op == Operator.MUL) {
      var op_list_2 = new ArrayList<Expression>();
      for(var i = 0; i < op_list.size; i++) {
        var op = op_list[i];
        if(op is BinaryExpression) {
          var be_sub = op as BinaryExpression;
          var left = new MultiExpression(Operator.MUL, null);
          if(op_list_2.size > 0)
            left.add_operand_list(new ReadOnlyList<Expression>(op_list_2));
          for(var j = i + 1; j < op_list.size; j++)
            left.add_operand(op_list[j]);
          left.add_operand(be_sub.left);
          q.push_head(new BinaryExpression(Operator.DIV, left, be_sub.right));
          return;
        } else
          op_list_2.add(op);
      }
    }
    q.push_head(new MultiExpression(me.op, new ReadOnlyList<Expression>(op_list)));
  }
}
