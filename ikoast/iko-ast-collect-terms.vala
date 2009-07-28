/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.CollectTerms : ExpressionTransformer {
  public override void visit_binary_expression(BinaryExpression be) {
    assert(be.op == Operator.DIV ||
           be.op == Operator.POWER);
    base.visit_binary_expression(be);
  }

  public override void visit_multi_expression(MultiExpression me) {
    assert(me.op == Operator.EQUAL ||
           me.op == Operator.MUL   ||
           me.op == Operator.PLUS);
    base.visit_multi_expression(me);
  }
}
