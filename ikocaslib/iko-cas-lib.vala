/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using GI;

namespace Iko.CAS.Library {
	const string[] black_list = {
		"get_functions",
		"init"
	};

	public bool init() {
		var repo = Repository.get_default();

		try {
			var typelib = Typelib.new_from_const_memory(Data.ikocaslib_1_0_typelib);
			repo.load_typelib(typelib, RepositoryLoadFlags.LAZY);
		} catch(RepositoryError e) {
			stdout.printf("Repository error: %s\n", e.message);
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
}
