/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.Equation : Node {
  public Expression left  { get; construct; }
  public Expression right { get; construct; }

  public Equation(SourceReference? src, Expression left, Expression right) {
    this.src   = src;
    this.left  = left;
    this.right = right;
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_equation(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    left.accept(v);
    right.accept(v);
  }
}
