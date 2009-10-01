/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.CollectSymbols : ExpressionTransformer {
  MultiplicativeExpression factorize(Expression e) {
    if(e is MultiplicativeExpression)
      return e as MultiplicativeExpression;
    else {
      var me = new MultiplicativeExpression();
      me.operands.prepend(e);
      return me;
    }
  }

  bool is_pure_literal(Expression expr) {
    if(expr is Literal)
      return true;
    else if(expr is PowerExpression) {
      var pe = expr as PowerExpression;
      return is_pure_literal(pe.radix) && is_pure_literal(pe.exp);
    } else if(expr is AdditiveExpression) {
      var ae = expr as AdditiveExpression;
      foreach(var op in ae.operands)
        if(!is_pure_literal(op))
          return false;
      return true;
    } else
      return false;
  }

  void powerize(Expression e, out Expression radix, out Expression exp) {
    if(e is PowerExpression) {
      radix = (e as PowerExpression).radix;
      exp = (e as PowerExpression).exp;
    } else {
      radix = e;
      exp = IntegerLiteral.ONE;
    }
  }

  void separate(Expression expr, out Expression bais, out Expression factor) {
    if(expr is MultiplicativeExpression) {
      var me = expr as MultiplicativeExpression;
      var f = new MultiplicativeExpression();
      var b = new MultiplicativeExpression();
      foreach(var op in me.operands)
        if(is_pure_literal(op))
          f.operands.prepend(op);
        else
          b.operands.prepend(op);
      f.operands.reverse();
      b.operands.reverse();
      factor = trim(f);
      bais = trim(b);
    } else {
      bais = expr;
      factor = IntegerLiteral.ONE;
    }
  }

  Expression trim(MultiplicativeExpression me) {
    switch(me.operands.length()) {
    case 0:
      return IntegerLiteral.ONE;
    case 1:
      return me.operands.nth_data(0);
    default:
      return me;
    }
  }

  static int key_compare_func(void *a, void *b) {
    return (a as Expression).compare_to(b as Expression);
  }

  public override void visit_additive_expression(AdditiveExpression ae_in) {
    base.visit_additive_expression(ae_in);
    var ae = q.pop_head() as AdditiveExpression;

    var tree = new Tree<Expression,Expression>((CompareFunc)key_compare_func);
    foreach(var op in ae.operands) {
      Expression factor;
      Expression bais;
      separate(op, out bais, out factor);
      if(tree.lookup(bais) != null) {
        var f = tree.lookup(bais);
        if(f is AdditiveExpression)
          (f as AdditiveExpression).operands.append(factor);
        else {
          f = new AdditiveExpression.binary(f, factor);
          tree.insert(bais, f);
        }
      } else
        tree.insert(bais, factor);
    }
    var ae_new = new AdditiveExpression();
    tree.foreach(
      (k, v) => {
        var key = k as Expression;
        var val = v as Expression;
        if(val.compare_to(IntegerLiteral.ONE) == 0)
          ae_new.operands.prepend(key);
        else
          ae_new.operands.prepend(new MultiplicativeExpression.binary(val, key));
      }
    );
    ae_new.operands.reverse();
    q.push_head(ae_new);
  }

  public override void visit_division_expression(DivisionExpression de_in) {
    base.visit_division_expression(de_in);
    var de = q.pop_head() as DivisionExpression;

    var num = factorize(de.num);
    var den = factorize(de.den);
    var tree_num = new Tree<Expression,Expression>((CompareFunc)key_compare_func);
    foreach(var op in num.operands) {
      Expression radix;
      Expression exp;
      powerize(op, out radix, out exp);
      tree_num.insert(radix, exp);
    }
    var tree_den = new Tree<Expression,Expression>((CompareFunc)key_compare_func);
    foreach(var op in den.operands) {
      Expression radix;
      Expression exp;
      powerize(op, out radix, out exp);
      if(tree_num.lookup(radix) != null) {
        var exp_inv = new MultiplicativeExpression.binary(IntegerLiteral.MINUS_ONE, exp);
        var e = tree_num.lookup(radix);
        if(e is AdditiveExpression)
          (e as AdditiveExpression).operands.append(exp_inv);
        else {
          exp = new AdditiveExpression.binary(e, exp_inv);
          tree_num.insert(radix, exp);
        }
      } else
        tree_den.insert(radix, exp);
    }
    var num_new = new MultiplicativeExpression();
    var den_new = new MultiplicativeExpression();
    tree_num.foreach(
      (k, v) => {
        var key = k as Expression;
        var val = v as Expression;
        if(val.compare_to(IntegerLiteral.ONE) == 0)
          num_new.operands.prepend(key);
        else
          num_new.operands.prepend(new PowerExpression(key, val));
      }
    );
    num_new.operands.reverse();
    tree_den.foreach(
      (k, v) => {
        var key = k as Expression;
        var val = v as Expression;
        if(val.compare_to(IntegerLiteral.ONE) == 0)
          den_new.operands.prepend(key);
        else
          den_new.operands.prepend(new PowerExpression(key, val));
      }
    );
    den_new.operands.reverse();
    q.push_head(new DivisionExpression(trim(num_new), trim(den_new)));
  }

  public override void visit_multiplicative_expression(MultiplicativeExpression me_in) {
    base.visit_multiplicative_expression(me_in);
    var me = q.pop_head() as MultiplicativeExpression;

    var tree = new Tree<Expression,Expression>((CompareFunc)key_compare_func);
    foreach(var op in me.operands) {
      Expression radix;
      Expression exp;
      powerize(op, out radix, out exp);
      if(tree.lookup(radix) != null) {
        var e = tree.lookup(radix);
        if(e is AdditiveExpression)
          (e as AdditiveExpression).operands.append(exp);
        else {
          e = new AdditiveExpression.binary(e, exp);
          tree.insert(radix, e);
        }
      } else
        tree.insert(radix, exp);
    }
    var me_new = new MultiplicativeExpression();
    tree.foreach(
      (k, v) => {
        var key = k as Expression;
        var val = v as Expression;
        if(val.compare_to(IntegerLiteral.ONE) == 0)
          me_new.operands.prepend(key);
        else
          me_new.operands.prepend(new PowerExpression(key, val));
      }
    );
    me_new.operands.reverse();
    q.push_head(me_new);
  }
}
