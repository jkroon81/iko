/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.CAS.Visitor : Object {
	public virtual void visit_compound_expression(CompoundExpression ce) {}
	public virtual void visit_fraction(Fraction f) {}
	public virtual void visit_integer(Integer i) {}
	public virtual void visit_symbol(Symbol s) {}
}
