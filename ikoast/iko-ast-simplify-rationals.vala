/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.SimplifyRationals : Visitor {
  Expression expr;

  public Expression simplify_rationals(Expression e) {
    e.accept(this);
    return expr;
  }

  public override void visit_binary_expression(BinaryExpression be) {
    assert(be.op == Operator.DIV ||
           be.op == Operator.POWER);

    be.left.accept(this);
    var left = expr;
    be.right.accept(this);
    var right = expr;

    if(be.op == Operator.DIV) {
      if(left is BinaryExpression) {
        var be_left = left as BinaryExpression;
        var right_new = new MultiExpression(Operator.MUL);
        right_new.add_operand(be_left.right);
        right_new.add_operand(right);
        expr = new BinaryExpression(Operator.DIV, be_left.left, right_new);
      } else if(right is BinaryExpression) {
        var be_right = right as BinaryExpression;
        var left_new = new MultiExpression(Operator.MUL);
        left_new.add_operand(left);
        left_new.add_operand(be_right.left);
        expr = new BinaryExpression(Operator.DIV, left_new, be_right.right);
      } else {
        expr = new BinaryExpression(Operator.DIV, left, right);
      }
      return;
    }
    expr = new BinaryExpression(be.op, left, right);
  }

  public override void visit_multi_expression(MultiExpression me) {
    assert(me.op == Operator.EQUAL ||
           me.op == Operator.MUL   ||
           me.op == Operator.PLUS);

    var op_list = new ArrayList<Expression>();

    foreach(var op in me.get_operands()) {
      op.accept(this);
      op_list.add(expr);
    }

    if(me.op == Operator.MUL) {
      var op_list_2 = new ArrayList<Expression>();
      for(var i = 0; i < op_list.size; i++) {
        var op = op_list[i];
        if(op is BinaryExpression) {
          var be_sub = op as BinaryExpression;
          var left = new MultiExpression(Operator.MUL);
          if(op_list_2.size > 0)
            left.add_operand_list(new ReadOnlyList<Expression>(op_list_2));
          for(var j = i + 1; j < op_list.size; j++)
            left.add_operand(op_list[j]);
          left.add_operand(be_sub.left);
          expr = new BinaryExpression(Operator.DIV, left, be_sub.right);
          return;
        } else
          op_list_2.add(op);
      }
    }
    var me_new = new MultiExpression(me.op);
    me_new.add_operand_list(new ReadOnlyList<Expression>(op_list));
    expr = me_new;
  }

  public override void visit_simple_expression(SimpleExpression se) {
    expr = se;
  }
}
