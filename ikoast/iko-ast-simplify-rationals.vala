/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.SimplifyRationals : ExpressionTransformer {
  public override void visit_division_expression(DivisionExpression de_in) {
    base.visit_division_expression(de_in);
    var de = q.pop_head() as DivisionExpression;

    if(de.left is DivisionExpression) {
      var de_left = de.left as DivisionExpression;
      var right_new = new MultiplicativeExpression(null);
      right_new.operands.add(de_left.right);
      right_new.operands.add(de.right);
      q.push_head(new DivisionExpression(de_left.left, right_new));
    } else if(de.right is DivisionExpression) {
      var de_right = de.right as DivisionExpression;
      var left_new = new MultiplicativeExpression(null);
      left_new.operands.add(de.left);
      left_new.operands.add(de_right.right);
      q.push_head(new DivisionExpression(left_new, de_right.left));
    } else
      q.push_head(de);
  }

  public override void visit_multiplicative_expression(MultiplicativeExpression me_in) {
    base.visit_multiplicative_expression(me_in);
    var me = q.pop_head() as MultiplicativeExpression;

    for(var i = 0; i < me.operands.size; i++) {
      var op = me.operands[i];
      if(op is DivisionExpression) {
        var de_sub = op as DivisionExpression;
        var left = new MultiplicativeExpression(null);
        for(var j = 0; j < me.operands.size; j++)
          if(j != i)
            left.operands.add(me.operands[j]);
        left.operands.add(de_sub.left);
        q.push_head(new DivisionExpression(left, de_sub.right));
        return;
      }
    }
    q.push_head(me);
  }
}
