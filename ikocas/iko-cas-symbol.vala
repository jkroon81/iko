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
		Object(
			kind : Kind.SYMBOL,
			name : name
		);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_symbol(this);
	}

	public Expression invoke(List args) throws Error {
		var repo = Repository.get_default();
		var info = repo.find_by_name("ikocaslib", "cas_library_" + name);
		if(info == null)
			throw new Error.RUNTIME("Function '%s' not found\n", name);
		if(info.get_type() != InfoType.FUNCTION)
			throw new Error.RUNTIME("Symbol '%s' is not a function\n", name);

		Argument[] arg_in = new Argument[args.size];
		Argument retval;

		for(var i = 0; i < args.size; i++)
			arg_in[i].pointer = args[i];

		try {
			((FunctionInfo)info).invoke(arg_in, null, out retval);
		} catch (InvokeError e) {
			throw new Error.RUNTIME("Invalid arguments to function '%s'\n", name);
		}

		return (retval.pointer as Expression);
	}

	public Expression map(Expression e, List? args) throws Error {
		var c = e as List;

		if(c == null)
			return undefined();

		List l;

		if(args != null)
			l = args.copy();
		else
			l = new List.from_empty(Kind.LIST);

		l.prepend(e);

		List x = new List.from_empty(c.kind);

		foreach(var op in c) {
			l[0] = op;
			x.append(invoke(l));
		}

		return x;
	}
}
