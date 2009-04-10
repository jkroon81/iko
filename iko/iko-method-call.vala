/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.MethodCall : Expression {
  ArrayList<Expression> args;

  public Expression method { get; construct; }

  public override DataType data_type { get { return method.data_type; } }

  public MethodCall(SourceReference? src, Expression method) {
    this.src    = src;
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

  public void add_argument(Expression a) {
    args.add(a);
  }

  public ReadOnlyList<Expression> get_arguments() {
    return new ReadOnlyList<Expression>(args);
  }
}
