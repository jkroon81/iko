/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.CAS.Visitor : Object {
	public virtual void visit_atomic_expression(AtomicExpression ae) {}
	public virtual void visit_compound_expression(CompoundExpression ce) {}
	public virtual void visit_equality(Equality e) {}
	public virtual void visit_expression(Expression e) {}
	public virtual void visit_function_call(FunctionCall fc) {}
	public virtual void visit_integer(Integer i) {}
	public virtual void visit_list(List l) {}
	public virtual void visit_power(Power p) {}
	public virtual void visit_product(Product p) {}
	public virtual void visit_real(Real r) {}
	public virtual void visit_sum(Sum s) {}
	public virtual void visit_symbol(Symbol s) {}
	public virtual void visit_undefined(Undefined u) {}
}
