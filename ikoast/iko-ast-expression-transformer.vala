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

  public override void visit_binary_expression(BinaryExpression be) {
    q.push_head(new BinaryExpression(be.op, transform(be.left), transform(be.right)));
  }

  public override void visit_multi_expression(MultiExpression me) {
    var op_list = new ArrayList<Expression>();
    foreach(var op in me.operands)
      op_list.add(transform(op));
    q.push_head(new MultiExpression(me.op, op_list));
  }

  public override void visit_simple_expression(SimpleExpression se) {
    q.push_head(se);
  }

  public override void visit_unary_expression(UnaryExpression ue) {
    q.push_head(new UnaryExpression(ue.op, transform(ue.expr)));
  }
}
