/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

namespace Iko.CAS {
	static Boolean _bool_false = null;
	static Boolean _bool_true = null;
	static Symbol _infinity = null;
	static Integer _int_neg_one = null;
	static Integer _int_one = null;
	static Integer _int_zero = null;
	static Undefined _undefined = null;

	public Boolean bool_false() {
		if(_bool_false == null)
			_bool_false = new Boolean.from_bool(false);
		return _bool_false;
	}

	public Boolean bool_true() {
		if(_bool_true == null)
			_bool_true = new Boolean.from_bool(true);
		return _bool_true;
	}

	public Symbol infinity() {
		if(_infinity == null)
			_infinity = new Symbol("Infinity");
		return _infinity;
	}

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
