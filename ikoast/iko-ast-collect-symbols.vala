/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.CollectSymbols : ExpressionTransformer {
  bool equals(Expression e1, Expression e2) {
    if(e1 is SymbolAccess && e2 is SymbolAccess)
      return (e1 as SymbolAccess).symbol == (e2 as SymbolAccess).symbol;
    else
      return false;
  }

  ArrayList<Expression> factorize(Expression e) {
    var f = new ArrayList<Expression>();
    if(e is MultiplicativeExpression)
      f.add_all((e as MultiplicativeExpression).operands);
    else
      f.add(e);
    return f;
  }

  void powerize(Expression e, out Expression bais, out Expression exp) {
    if(e is PowerExpression) {
      bais = (e as PowerExpression).bais;
      exp = (e as PowerExpression).exp;
    } else {
      bais = e;
      exp = IntegerLiteral.ONE;
    }
  }

  public override void visit_division_expression(DivisionExpression de_in) {
    base.visit_division_expression(de_in);
    var de = q.pop_head() as DivisionExpression;

    var f_num = factorize(de.num);
    var f_den = factorize(de.den);
    for(int i = 0; i < f_num.size; i++) {
      Expression num_bais, num_exp;
      powerize(f_num[i], out num_bais, out num_exp);
      for(int j = 0; j < f_den.size; j++) {
        Expression den_bais, den_exp;
        powerize(f_den[j], out den_bais, out den_exp);
        if(equals(num_bais, den_bais)) {
          var exp = new AdditiveExpression();
          exp.operands.add(num_exp);
          var inv = new MultiplicativeExpression.binary(IntegerLiteral.MINUS_ONE, den_exp);
          exp.operands.add(inv);
          f_num[i] = new PowerExpression(num_bais, exp);
          f_den.remove_at(j);
          j--;
        }
      }
    }
    if(f_num.size == 0)
      f_num.add(IntegerLiteral.ONE);
    if(f_den.size == 0)
      f_den.add(IntegerLiteral.ONE);
    q.push_head(
      new DivisionExpression(
        new MultiplicativeExpression.list(f_num),
        new MultiplicativeExpression.list(f_den)
      )
    );
  }

  public override void visit_multiplicative_expression(MultiplicativeExpression me_in) {
    base.visit_multiplicative_expression(me_in);
    var me = q.pop_head() as MultiplicativeExpression;

    var factors = new ArrayList<Expression>();
    for(int i = 0; i < me.operands.size; i++) {
      Expression bais_1, exp_1;
      powerize(me.operands[i], out bais_1, out exp_1);
      for(int j = i + 1; j < me.operands.size; j++) {
        Expression bais_2, exp_2;
        powerize(me.operands[j], out bais_2, out exp_2);
        if(equals(bais_1, bais_2)) {
          exp_1 = new AdditiveExpression.binary(exp_1, exp_2);
          me.operands.remove_at(j);
          j--;
        }
      }
      factors.add(new PowerExpression(bais_1, exp_1));
    }
    q.push_head(new MultiplicativeExpression.list(factors));
  }
}
