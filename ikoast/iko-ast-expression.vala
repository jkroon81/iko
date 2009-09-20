/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.AST.Expression : Node, Gee.Comparable<Expression> {
  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_expression(this);
  }

  public int compare_to(Expression expr) {
    return strcmp(to_string(), expr.to_string());
  }

  public Expression simplify() {
    var expr = this;
    expr = new TransformNegatives().transform(expr);
    expr = new SimplifyPowers().transform(expr);
    expr = new SimplifyRationals().transform(expr);
    expr = new ExpandSymbols().transform(expr);
    expr = new LevelOperators().transform(expr);
    expr = new CollectSymbols().transform(expr);
    expr = new FoldConstants().transform(expr);
    return expr;
  }

  public string to_string() {
    return new Writer().generate_string(this);
  }
}
