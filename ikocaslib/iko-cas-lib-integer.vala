/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

namespace Iko.CAS.Library {
	public Integer igcd(Integer a, Integer b) {
		var A = a.ival;
		var B = b.ival;

		while(B != 0) {
			var R = A % B;
			A = B;
			B = R;
		}
		return new Integer.from_int(A.abs());
	}

	public Integer iquot(Integer a, Integer b) {
		return new Integer.from_int(a.ival / b.ival);
	}

	public Integer irem(Integer a, Integer b) {
		return new Integer.from_int(a.ival % b.ival);
	}
}
