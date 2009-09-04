/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public abstract class Iko.AST.ExpressionTransformer : Visitor {
  internal Queue<Expression> q;

  public ExpressionTransformer() {
    q = new Queue<Expression>();
  }

  public Expression transform(Expression e) {
    e.accept(this);
    return q.pop_head();
  }

  public ArrayList<Expression> transform_list(ArrayList<Expression> operands) {
    var op_list = new ArrayList<Expression>();
    foreach(var op in operands)
      op_list.add(transform(op));
    return op_list;
  }

  public override void visit_additive_expression(AdditiveExpression ae) {
    q.push_head(new AdditiveExpression.list(transform_list(ae.operands)));
  }

  public override void visit_division_expression(DivisionExpression de) {
    q.push_head(new DivisionExpression(transform(de.num), transform(de.den)));
  }

  public override void visit_equality_expression(EqualityExpression ee) {
    q.push_head(new EqualityExpression(transform(ee.left), transform(ee.right)));
  }

  public override void visit_multiplicative_expression(MultiplicativeExpression me) {
    q.push_head(new MultiplicativeExpression.list(transform_list(me.operands)));
  }

  public override void visit_power_expression(PowerExpression pe) {
    q.push_head(new PowerExpression(transform(pe.bais), transform(pe.exp)));
  }

  public override void visit_simple_expression(SimpleExpression se) {
    q.push_head(se);
  }
}
