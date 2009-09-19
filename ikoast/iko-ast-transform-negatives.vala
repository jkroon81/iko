/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.TransformNegatives : ExpressionTransformer {
  public override void visit_negative_expression(NegativeExpression ne_in) {
    base.visit_negative_expression(ne_in);
    var ne = q.pop_head() as NegativeExpression;

    q.push_head(new MultiplicativeExpression.binary(IntegerLiteral.MINUS_ONE, ne.expr));
  }
}
