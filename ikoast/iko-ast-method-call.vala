/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.MethodCall : SimpleExpression {
  public ArrayList<Expression> args { get; private set; }

  public Expression method { get; construct; }

  public MethodCall(Expression method) {
    this.method = method;
  }

  construct {
    args = new ArrayList<Expression>();
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_method_call(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    method.accept(v);
    foreach(var a in args)
      a.accept(v);
  }
}
