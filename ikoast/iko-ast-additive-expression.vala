/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.AdditiveExpression : MultiExpression {
  public AdditiveExpression.binary(Expression left, Expression right) {
    operands.add(left);
    operands.add(right);
  }

  public AdditiveExpression.empty() {
  }

  public AdditiveExpression.list(Gee.ArrayList<Expression> op_list) {
    operands.add_all(op_list);
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_additive_expression(this);
  }
}
