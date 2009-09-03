/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.MultiplicativeExpression : MultiExpression {
  public MultiplicativeExpression.binary(Expression left, Expression right) {
    op = Operator.MUL;
    operands.add(left);
    operands.add(right);
  }

  public MultiplicativeExpression.empty() {
    op = Operator.MUL;
  }

  public MultiplicativeExpression.list(Gee.ArrayList<Expression> op_list) {
    op = Operator.MUL;
    operands.add_all(op_list);
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_multiplicative_expression(this);
  }
}
