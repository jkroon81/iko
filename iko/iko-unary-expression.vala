/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.UnaryExpression : Expression {
  public enum Operator {
    MINUS,
    PLUS,
    NONE;

    public string to_string() {
      switch(this) {
      case MINUS: return "-";
      case PLUS:  return "+";
      default:    assert_not_reached();
      }
    }
  }

  public Operator   op   { get; construct; }
  public Expression expr { get; construct; }

  public override DataType data_type { get { return expr.data_type; } }

  public UnaryExpression(SourceReference? src, Operator op, Expression expr) {
    this.src  = src;
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
