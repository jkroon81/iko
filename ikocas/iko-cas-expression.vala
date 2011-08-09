/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.CAS.Expression : Node {
	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_expression(this);
	}

	public abstract Expression eval();

	public string to_polish() {
		return new Iko.CAS.Polish().generate_string(this);
	}

	public string to_string() {
		return new Iko.CAS.Writer().generate_string(this);
	}
}
