/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

namespace Iko.CAS {
	static Integer _neg_one = null;
	static Integer _one = null;
	static Undefined _undefined = null;

	public Integer neg_one() {
		if(_neg_one == null)
			_neg_one = new Integer.from_int(-1);
		return _neg_one;
	}

	public Integer one() {
		if(_one == null)
			_one = new Integer.from_int(1);
		return _one;
	}

	public Undefined undefined() {
		if(_undefined == null)
			_undefined = new Undefined();
		return _undefined;
	}
}
