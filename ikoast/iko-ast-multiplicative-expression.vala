/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.MultiplicativeExpression : MultiExpression {
  public MultiplicativeExpression(Gee.ArrayList<Expression>? op_list) {
    op = Operator.MUL;
    if(op_list != null)
      operands.add_all(op_list);
  }

  public MultiplicativeExpression.from_binary(Expression left, Expression right) {
    op = Operator.MUL;
    operands.add(left);
    operands.add(right);
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_multiplicative_expression(this);
  }
}
