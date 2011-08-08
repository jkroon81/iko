/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

namespace Iko.CAS.Library {
	public Expression i_ext_euc_alg(Expression x1, Expression x2) {
		var a = x1 as Integer;
		var b = x2 as Integer;

		if(a == null || b == null)
			return undefined();

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
			l.append(new Integer.from_int(A));
			l.append(new Integer.from_int(mpp));
			l.append(new Integer.from_int(npp));
		} else {
			l.append(new Integer.from_int(-A));
			l.append(new Integer.from_int(-mpp));
			l.append(new Integer.from_int(-npp));
		}
		return l;
	}

	public Expression i_gcd(Expression x1, Expression x2) {
		var a = x1 as Integer;
		var b = x2 as Integer;

		if(a == null || b == null)
			return undefined();

		var A = a.ival;
		var B = b.ival;

		while(B != 0) {
			var R = A % B;
			A = B;
			B = R;
		}
		return new Integer.from_int(A.abs());
	}

	public Expression i_quot(Expression x1, Expression x2) {
		var a = x1 as Integer;
		var b = x2 as Integer;

		if(a == null || b == null)
			return undefined();

		return new Integer.from_int(a.ival / b.ival);
	}

	public Expression i_rem(Expression x1, Expression x2) {
		var a = x1 as Integer;
		var b = x2 as Integer;

		if(a == null || b == null)
			return undefined();

		return new Integer.from_int(a.ival % b.ival);
	}
}
