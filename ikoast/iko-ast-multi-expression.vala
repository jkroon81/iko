/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public abstract class Iko.AST.MultiExpression : Expression {
  public ArrayList<Expression> operands { get; private set; }

  public Operator op { get; construct; }

  construct {
    operands = new ArrayList<Expression>();
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_multi_expression(this);
  }

  public override void accept_children(Visitor v) {
    base.accept_children(v);
    foreach(var o in operands)
      o.accept(v);
  }
}
