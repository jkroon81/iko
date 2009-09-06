/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.AST.ExpressionTransformer : Visitor {
  internal Queue<Expression> q;

  public ExpressionTransformer() {
    q = new Queue<Expression>();
  }

  public Expression transform(Expression e) {
    e.accept(this);
    return q.pop_head();
  }

  public override void visit_additive_expression(AdditiveExpression ae) {
    var ae_new = new AdditiveExpression();
    foreach(var op in ae.operands)
      ae_new.operands.add(transform(op));
    q.push_head(ae_new);
  }

  public override void visit_division_expression(DivisionExpression de) {
    q.push_head(new DivisionExpression(transform(de.num), transform(de.den)));
  }

  public override void visit_equality_expression(EqualityExpression ee) {
    q.push_head(new EqualityExpression(transform(ee.left), transform(ee.right)));
  }

  public override void visit_multiplicative_expression(MultiplicativeExpression me) {
    var me_new = new MultiplicativeExpression();
    foreach(var op in me.operands)
      me_new.operands.add(transform(op));
    q.push_head(me_new);
  }

  public override void visit_power_expression(PowerExpression pe) {
    q.push_head(new PowerExpression(transform(pe.bais), transform(pe.exp)));
  }

  public override void visit_simple_expression(SimpleExpression se) {
    q.push_head(se);
  }
}
