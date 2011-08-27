/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Namespace : Node {
	public string name { get; construct; }

	public SList<Function> function;

	public Namespace(string name) {
		Object(name : name);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_namespace(this);
	}
}
