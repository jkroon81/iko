/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

namespace Iko.CAS.Library {
	public Expression i_ext_euc_alg(Expression x1, Expression x2) throws Error {
		var a = x1 as Integer;
		var b = x2 as Integer;

		if(a == null || b == null)
			throw new Error.RUNTIME("%s:line %d: Arguments must be integers", Log.FILE, Log.LINE);

		var mpp = int_one();
		var mp = int_zero();
		Integer m;
		var npp = int_zero();
		var np = int_one();
		Integer n;
		var A = a;
		var B = b;

		while(Integer.cmp(B, int_zero()) != 0) {
			var Q = Integer.quote(A, B);
			var R = Integer.rem(A, B);
			A = B;
			B = R;
			m = Integer.sub(mpp, Integer.mul(Q, mp));
			n = Integer.sub(npp, Integer.mul(Q, np));
			mpp = mp;
			mp = m;
			npp = np;
			np = n;
		}
		var l = new List();
		if(Integer.cmp(A, int_zero()) >= 0) {
			l.append(A);
			l.append(mpp);
			l.append(npp);
		} else {
			l.append(Integer.neg(A));
			l.append(Integer.neg(mpp));
			l.append(Integer.neg(npp));
		}
		return l;
	}

	public Expression i_gcd(Expression x1, Expression x2) throws Error {
		var a = x1 as Integer;
		var b = x2 as Integer;

		if(a == null || b == null)
			throw new Error.RUNTIME("%s:line %d: Arguments must be integers", Log.FILE, Log.LINE);

		return Integer.gcd(a, b);
	}

	public Expression i_lcm(Expression x1, Expression x2) throws Error {
		var a = x1 as Integer;
		var b = x2 as Integer;

		if(a == null || b == null)
			throw new Error.RUNTIME("%s:line %d: Arguments must be integers", Log.FILE, Log.LINE);

		return Integer.lcm(a, b);
	}

	public Expression i_quot(Expression x1, Expression x2) throws Error {
		var a = x1 as Integer;
		var b = x2 as Integer;

		if(a == null || b == null)
			throw new Error.RUNTIME("%s:line %d: Arguments must be integers", Log.FILE, Log.LINE);

		if(Integer.cmp(b, int_zero()) == 0)
			return undefined();

		return Integer.quote(a, b);
	}

	public Expression i_rem(Expression x1, Expression x2) throws Error {
		var a = x1 as Integer;
		var b = x2 as Integer;

		if(a == null || b == null)
			throw new Error.RUNTIME("%s:line %d: Arguments must be integers", Log.FILE, Log.LINE);

		if(Integer.cmp(b, int_zero()) == 0)
			return undefined();

		return Integer.rem(a, b);
	}
}
