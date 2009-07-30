/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.CollectTerms : ExpressionTransformer {
  public override void visit_binary_expression(BinaryExpression be_in) {
    assert(be_in.op == Operator.DIV ||
           be_in.op == Operator.POWER);
    base.visit_binary_expression(be_in);
  }

  public override void visit_multi_expression(MultiExpression me_in) {
    assert(me_in.op == Operator.EQUAL ||
           me_in.op == Operator.MUL   ||
           me_in.op == Operator.PLUS);
    base.visit_multi_expression(me_in);
  }
}
