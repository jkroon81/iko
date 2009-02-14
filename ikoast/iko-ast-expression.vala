/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.AST.Expression : Node {
  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_expression(this);
  }

  public virtual bool equals(Expression expr) {
    return false;
  }

  public Expression simplify() {
    var expr = new TransformNegatives().transform_negatives(this);
    expr = new LevelOperators().level_operators(expr);
    expr = new SimplifyRationals().simplify_rationals(expr);
    expr = new ExpandTerms().expand_terms(expr);
    expr = new CollectTerms().collect_terms(expr);
    return expr;
  }
}
