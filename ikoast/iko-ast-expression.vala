/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.AST.Expression : Node {
	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_expression(this);
	}

	public int compare_to(Expression expr) {
		return strcmp(to_string(), expr.to_string());
	}

	public string to_string() {
		return new Writer().generate_string(this);
	}
}
