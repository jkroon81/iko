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

	public Expression map(Expression e, ...) {
		var c = e as CompoundExpression;

		if(c == null)
			return undefined();

		var l = new List();
		l.append(e);

		var args = va_list();
		var arg = args.arg<Expression?>();

		while(arg != null) {
			l.append(arg);
			arg = args.arg<Expression?>();
		}

		CompoundExpression x = new CompoundExpression.from_empty(c.kind);

		foreach(var op in c) {
			l[0] = op;
			x.append(invoke(l));
		}

		return x;
	}
}
