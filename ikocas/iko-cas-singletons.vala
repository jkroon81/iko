/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

namespace Iko.CAS {
	static Integer _int_neg_one = null;
	static Integer _int_one = null;
	static Integer _int_zero = null;
	static Undefined _undefined = null;

	public Integer int_neg_one() {
		if(_int_neg_one == null)
			_int_neg_one = new Integer.from_int(-1);
		return _int_neg_one;
	}

	public Integer int_one() {
		if(_int_one == null)
			_int_one = new Integer.from_int(1);
		return _int_one;
	}

	public Integer int_zero() {
		if(_int_zero == null)
			_int_zero = new Integer.from_int(0);
		return _int_zero;
	}

	public Undefined undefined() {
		if(_undefined == null)
			_undefined = new Undefined();
		return _undefined;
	}
}
