/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.AST.SimpleExpression : Expression {
	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_simple_expression(this);
	}
}
