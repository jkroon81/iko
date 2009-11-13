/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.AST.Visitor : Object {
	public virtual void visit_constant(Constant c) {}
	public virtual void visit_data_symbol(DataSymbol ds) {}
	public virtual void visit_data_type(DataType data_type) {}
	public virtual void visit_float_type(FloatType f) {}
	public virtual void visit_independent_variable(IndependentVariable iv) {}
	public virtual void visit_real_type(RealType r) {}
	public virtual void visit_state(State s) {}
	public virtual void visit_symbol(Symbol symbol) {}
	public virtual void visit_system(System system) {}
}
