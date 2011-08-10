/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using GI;

public class Iko.CAS.Symbol : AtomicExpression {
	public string name { get; construct; }

	public Symbol(string name) {
		Object(name : name);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_symbol(this);
	}

	public override Expression eval() {
		return this;
	}

	public Expression invoke(List args) {
		var repo = Repository.get_default();
		var info = repo.find_by_name("ikocaslib", "cas_library_" + name);
		if(info == null)
			return undefined();
		if(info.get_type() != InfoType.FUNCTION)
			return undefined();

		Argument[] arg_in = new Argument[args.size];
		Argument retval;

		for(var i = 0; i < args.size; i++)
			arg_in[i].pointer = args[i];

		try {
			((FunctionInfo)info).invoke(arg_in, null, out retval);
		} catch (InvokeError e) {
			return undefined();
		}

		return (retval.pointer as Expression);
	}
}
