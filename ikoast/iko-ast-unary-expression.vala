/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.UnaryExpression : Expression {
  public Operator   op   { get; construct; }
  public Expression expr { get; construct; }

  public UnaryExpression(Operator op, Expression expr) {
    assert(op != Operator.DIV);
    assert(op != Operator.EQUAL);
    assert(op != Operator.MUL);
    this.op   = op;
    this.expr = expr;
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_unary_expression(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    expr.accept(v);
  }
}
