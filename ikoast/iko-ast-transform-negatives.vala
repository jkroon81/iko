/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.TransformNegatives : ExpressionTransformer {
  public override void visit_binary_expression(BinaryExpression be_in) {
    base.visit_binary_expression(be_in);
    var be = q.pop_head() as BinaryExpression;

    if(be.op == Operator.MINUS) {
      var right = new BinaryExpression(Operator.MUL, new IntegerLiteral("-1"), be.right);
      q.push_head(new BinaryExpression(Operator.PLUS, be.left, right));
    } else
      q.push_head(be);
  }

  public override void visit_unary_expression(UnaryExpression ue_in) {
    base.visit_unary_expression(ue_in);
    var ue = q.pop_head() as UnaryExpression;

    switch(ue.op) {
    case Operator.MINUS:
      q.push_head(new BinaryExpression(Operator.MUL, new IntegerLiteral("-1"), ue.expr));
      break;
    case Operator.PLUS:
      q.push_head(ue.expr);
      break;
    default:
      assert_not_reached();
    }
  }
}
