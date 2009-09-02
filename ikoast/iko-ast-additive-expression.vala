/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.AdditiveExpression : MultiExpression {
  public AdditiveExpression(Gee.ArrayList<Expression>? op_list) {
    op = Operator.PLUS;
    if(op_list != null)
      operands.add_all(op_list);
  }

  public AdditiveExpression.from_binary(Expression left, Expression right) {
    op = Operator.PLUS;
    operands.add(left);
    operands.add(right);
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_additive_expression(this);
  }
}
