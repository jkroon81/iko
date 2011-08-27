/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using GI;

namespace Iko.CAS.Library {
	static const string[] black_list = {
		"get_functions",
		"init"
	};

	public Expression free_of(Expression u, Expression t) {
		if(t.kind == Kind.SET) {
			foreach(var e in t as CompoundExpression)
				if(!(free_of(u, e) as Boolean).bval)
					return bool_false();
			return bool_true();
		} else {
			if(u.to_polish() == t.to_polish())
				return bool_false();
			else if(u.kind == Kind.SYMBOL ||
			        u.kind == Kind.INTEGER ||
			        u.kind == Kind.FRACTION)
				return bool_true();
			else {
				var ce = u as CompoundExpression;
				foreach(var e in ce)
					if(!(free_of(e, t) as Boolean).bval)
						return bool_false();
			}
			return bool_true();
		}
	}

	public bool init() {
		var repo = Repository.get_default();

		try {
			var typelib = Typelib.new_from_const_memory(Data.ikocaslib_1_0_typelib);
			repo.load_typelib(typelib, RepositoryLoadFlags.LAZY);
		} catch(RepositoryError e) {
			return false;
		}
		return true;
	}

	public string[] get_functions() {
		var repo = Repository.get_default();
		var n = repo.get_n_infos("ikocaslib");
		var func_array = new Array<string>(false, false, sizeof(string));

		for(var i = 0; i < n; i++) {
			var name = repo.get_info("ikocaslib", i).get_name().substring(12, -1);
			var show = true;
			foreach(var s in black_list)
				if(name == s) {
					show = false;
					break;
				}
			if(show)
				func_array.append_val(name);
		}

		var func = new string[func_array.length];
		for(var i = 0; i < func_array.length; i++)
			func[i] = func_array.index(i);

		return func;
	}

	public Expression simplify(Expression e) throws Error {
		var x = e;
		if(x is CompoundExpression)
			x = new Symbol("simplify").map(x, null);

		switch(x.kind) {
		case Kind.AND:
			return b_simplify(x);
		case Kind.BOOLEAN:
			return x;
		case Kind.EQ:
			return b_simplify(x);
		case Kind.FACTORIAL:
			return bae_simplify(x);
		case Kind.FRACTION:
			return rne_simplify(x);
		case Kind.FUNCTION:
			return simplify_function_call(x);
		case Kind.GE:
			return b_simplify(x);
		case Kind.GT:
			return b_simplify(x);
		case Kind.INTEGER:
			return x;
		case Kind.LIST:
			return x;
		case Kind.MUL:
			return bae_simplify(x);
		case Kind.NOT:
			return b_simplify(x);
		case Kind.OR:
			return b_simplify(x);
		case Kind.PLUS:
			return bae_simplify(x);
		case Kind.POWER:
			return bae_simplify(x);
		case Kind.SET:
			return set_simplify(x);
		case Kind.SYMBOL:
			return x;
		default:
			throw new Error.INTERNAL("%s: Unhandled kind '%s'", Log.METHOD, x.kind.to_string());
		}
	}

	Expression simplify_function_call(Expression e) throws Error {
		if(e.kind != Kind.FUNCTION)
			return e;

		var fc = e as CompoundExpression;

		foreach(var arg in fc)
			if(arg is Undefined)
				return arg;

		return simplify((fc[0] as Symbol).invoke(fc.to_list().tail()));
	}

	public Expression subs(Expression e, Expression u, Expression v) throws Error {
		if(e is CompoundExpression) {
			var r = new CompoundExpression.from_empty(e.kind);
			foreach(var op in e as CompoundExpression)
				r.append(subs(op, u, v));
			return r;
		} else if(e is Symbol) {
			if(u is Symbol && (e as Symbol).name == (u as Symbol).name)
				return v;
			else
				return e;
		} else if(e is Integer)
			return e;
		else
			throw new Error.INTERNAL("%s: Unhandled kind '%s'", Log.METHOD, e.kind.to_string());
	}
}
