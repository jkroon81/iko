/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.ValaBlock : Statement {
	public string text { get; construct; }

	public ValaBlock(string text) {
		Object(text : text);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_vala_block(this);
	}
}
