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
		case Kind.FACTORIAL:
			return bae_simplify(x);
		case Kind.FRACTION:
			return rne_simplify(x);
		case Kind.FUNCTION:
			return simplify_function_call(x);
		case Kind.INTEGER:
			return x;
		case Kind.MUL:
			return bae_simplify(x);
		case Kind.PLUS:
			return bae_simplify(x);
		case Kind.POWER:
			return bae_simplify(x);
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
}
