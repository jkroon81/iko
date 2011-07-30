/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.FunctionCall : CompoundExpression {
	public string name { get; construct; }

	public FunctionCall(string name) {
		Object(name : name, op : Operator.FUNCTION);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_function_call(this);
	}

	public override void accept_children(Visitor v) {
		base.accept_children(v);
		foreach(var arg in list)
			arg.accept(v);
	}
}
