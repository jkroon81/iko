/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.AST.Visitor : Object {
  public virtual void visit_additive_expression(AdditiveExpression ae) {}
  public virtual void visit_arithmetic_expression(ArithmeticExpression ae) {}
  public virtual void visit_constant(Constant c) {}
  public virtual void visit_data_symbol(DataSymbol ds) {}
  public virtual void visit_data_type(DataType data_type) {}
  public virtual void visit_derivative_method(DerivativeMethod der) {}
  public virtual void visit_division_expression(DivisionExpression de) {}
  public virtual void visit_equality_expression(EqualityExpression ee) {}
  public virtual void visit_expression(Expression expr) {}
  public virtual void visit_float_literal(FloatLiteral fl) {}
  public virtual void visit_float_type(FloatType f) {}
  public virtual void visit_independent_variable(IndependentVariable iv) {}
  public virtual void visit_integer_literal(IntegerLiteral il) {}
  public virtual void visit_literal(Literal l) {}
  public virtual void visit_method(Method m) {}
  public virtual void visit_method_call(MethodCall mc) {}
  public virtual void visit_multiplicative_expression(MultiplicativeExpression me) {}
  public virtual void visit_negative_expression(NegativeExpression ne) {}
  public virtual void visit_power_expression(PowerExpression pe) {}
  public virtual void visit_real_type(RealType r) {}
  public virtual void visit_simple_expression(SimpleExpression se) {}
  public virtual void visit_square_root_method(SquareRootMethod sqrt) {}
  public virtual void visit_state(State s) {}
  public virtual void visit_symbol(Symbol symbol) {}
  public virtual void visit_symbol_access(SymbolAccess sa) {}
  public virtual void visit_system(System system) {}
}
