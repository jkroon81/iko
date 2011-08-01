/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

namespace Iko.CAS.Library {
	public List iext_euc_alg(Integer a, Integer b) {
		int mpp = 1;
		int mp = 0;
		int m;
		int npp = 0;
		int np = 1;
		int n;
		int A = a.ival;
		int B = b.ival;

		while(B != 0) {
			int Q = A / B;
			int R = A % B;
			A = B;
			B = R;
			m = mpp - Q * mp;
			n = npp - Q * np;
			mpp = mp;
			mp = m;
			npp = np;
			np = n;
		}
		var l = new List();
		if(A >= 0) {
			l.list.append(new Integer.from_int(A));
			l.list.append(new Integer.from_int(mpp));
			l.list.append(new Integer.from_int(npp));
		} else {
			l.list.append(new Integer.from_int(-A));
			l.list.append(new Integer.from_int(-mpp));
			l.list.append(new Integer.from_int(-npp));
		}
		return l;
	}

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
