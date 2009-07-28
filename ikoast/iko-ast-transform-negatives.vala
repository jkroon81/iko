/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.TransformNegatives : ExpressionTransformer {
  public override void visit_binary_expression(BinaryExpression be) {
    var left = transform(be.left);
    var right = transform(be.right);

    if(be.op == Operator.MINUS) {
      right = new BinaryExpression(Operator.MUL, new IntegerLiteral("-1"), right);
      q.push_head(new BinaryExpression(Operator.PLUS, left, right));
    } else
      q.push_head(new BinaryExpression(be.op, left, right));
  }

  public override void visit_unary_expression(UnaryExpression ue) {
    var expr = transform(ue.expr);
    switch(ue.op) {
    case Operator.MINUS:
      q.push_head(new BinaryExpression(Operator.MUL, new IntegerLiteral("-1"), expr));
      break;
    case Operator.PLUS:
      q.push_head(expr);
      break;
    default:
      assert_not_reached();
    }
  }
}
