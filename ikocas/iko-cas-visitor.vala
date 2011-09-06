/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.CAS.Visitor : Object {
	public virtual void visit_assignment(Assignment a) {}
	public virtual void visit_boolean(Boolean b) {}
	public virtual void visit_error_statement(ErrorStatement e) {}
	public virtual void visit_for_statement(ForStatement f) {}
	public virtual void visit_foreach_statement(ForEachStatement f) {}
	public virtual void visit_fraction(Fraction f) {}
	public virtual void visit_function(Function f) {}
	public virtual void visit_if_statement(IfStatement i) {}
	public virtual void visit_integer(Integer i) {}
	public virtual void visit_list(List l) {}
	public virtual void visit_namespace(Namespace ns) {}
	public virtual void visit_return_statement(ReturnStatement r) {}
	public virtual void visit_statement(Statement stmt) {}
	public virtual void visit_string(String s) {}
	public virtual void visit_symbol(Symbol s) {}
	public virtual void visit_vala_block(ValaBlock vb) {}
	public virtual void visit_while_statement(WhileStatement w) {}
}
