/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.TransformNegatives : Visitor {
  Expression expr;

  public Expression transform_negatives(Expression e) {
    e.accept(this);
    return expr;
  }

  public override void visit_binary_expression(BinaryExpression be) {
    be.left.accept(this);
    var left = expr;
    be.right.accept(this);
    var right = expr;

    if(be.op == Operator.MINUS) {
      right = new BinaryExpression(Operator.MUL, new IntegerLiteral("-1"), right);
      expr = new BinaryExpression(Operator.PLUS, left, right);
    } else
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

  public override void visit_unary_expression(UnaryExpression ue) {
    ue.expr.accept(this);
    switch(ue.op) {
    case Operator.MINUS:
      expr = new BinaryExpression(Operator.MUL, new IntegerLiteral("-1"), expr);
      break;
    case Operator.PLUS:
      expr = new BinaryExpression(Operator.MUL, new IntegerLiteral("1"), expr);
      break;
    default:
      assert_not_reached();
    }
  }
}
