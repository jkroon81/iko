/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using GI;

namespace Iko.CAS {
	public static bool init() {
		var repo = Repository.get_default();

		try {
			var typelib = Typelib.new_from_mapped_file(
				new MappedFile("ikocaslib/ikocaslib-1.0.typelib", false)
			);
			repo.load_typelib(typelib, RepositoryLoadFlags.LAZY);
		} catch(FileError e) {
			return false;
		} catch(RepositoryError e) {
			return false;
		}

		return true;
	}
}
