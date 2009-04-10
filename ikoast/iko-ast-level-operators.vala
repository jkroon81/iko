/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.LevelOperators : Visitor {
  Expression expr;

  public Expression level_operators(Expression e) {
    e.accept(this);
    return expr;
  }

  public override void visit_binary_expression(BinaryExpression be) {
    assert(be.op != Operator.MINUS);

    be.left.accept(this);
    var left = expr;
    be.right.accept(this);
    var right = expr;

    if(be.op == Operator.EQUAL ||
       be.op == Operator.MUL   ||
       be.op == Operator.PLUS)
    {
      var me = new MultiExpression(be.op);
      if(left is MultiExpression) {
        var me_sub = left as MultiExpression;
        if(me_sub.op == be.op)
          me.add_operand_list(new ReadOnlyList<Expression>(me_sub.get_operands()));
        else
          me.add_operand(me_sub);
      } else
        me.add_operand(left);
      if(right is MultiExpression) {
        var me_sub = right as MultiExpression;
        if(me_sub.op == be.op)
          me.add_operand_list(new ReadOnlyList<Expression>(me_sub.get_operands()));
        else
          me.add_operand(me_sub);
      } else
        me.add_operand(right);
      expr = me;
      return;
    }
    expr = new BinaryExpression(be.op, left, right);
  }

  public override void visit_multi_expression(MultiExpression me) {
    var op_list = new ArrayList<Expression>();

    foreach(var op in me.get_operands()) {
      op.accept(this);
      op_list.add(expr);
    }

    var me_new = new MultiExpression(me.op);
    me_new.add_operand_list(new ReadOnlyList<Expression>(op_list));
    expr = me_new;
  }

  public override void visit_simple_expression(SimpleExpression se) {
    expr = se;
  }
}
