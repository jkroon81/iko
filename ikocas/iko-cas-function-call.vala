/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using GI;

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

	public override Expression eval() {
		var repo = Repository.get_default();
		var base_info = repo.find_by_name("ikocaslib", "cas_library_" + name);
		if(base_info == null)
			return this;
		if(base_info.get_type() != InfoType.FUNCTION)
			return this;

		Argument[] arg_in = new Argument[list.size];
		Argument retval;

		for(var i = 0; i < list.size; i++)
			arg_in[i].pointer = list[i];

		try {
			((FunctionInfo)base_info).invoke(arg_in, null, out retval);
		} catch (InvokeError e) {
			stdout.printf("Error invoking\n");
			return this;
		}

		return (retval.pointer as Expression);
	}
}
