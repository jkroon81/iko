/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

namespace Iko.CAS.Library {
	Expression rne_eval_power(Expression e) {
		var p = e as Power;

		if(p == null)
			return e;

		var radix = p.list[0];
		var exp = p.list[1] as Integer;

		if(exp == null)
			return e;

		if(radix is Integer || radix is Fraction) {
			if(exp.ival > 0) {
				var s = rne_eval_power(new Power(radix, new Integer.from_int(exp.ival - 1)));
				return rne_eval_product(new Product.from_binary(s, radix));
			} else if(exp.ival == 0)
				return one();
			else if(exp.ival == -1) {
				if(radix is Integer)
					return new Fraction.from_binary(one(), radix as Integer);
				else
					return new Fraction.from_binary((radix as Fraction).den, (radix as Fraction).num);
			} else {
				if(radix is Integer) {
					var s = new Fraction.from_binary(one(), radix as Integer);
					return rne_eval_power(new Power(s, new Integer.from_int(-exp.ival)));
				} else {
					var s = new Fraction.from_binary((radix as Fraction).den, (radix as Fraction).num);
					return rne_eval_power(new Power(s, new Integer.from_int(-exp.ival)));
				}
			}
		} else
			return e;
	}

	Expression rne_eval_product(Expression e) {
		var p = e as Product;

		if(p == null)
			return e;

		var rn = 1;
		var rd = 1;

		foreach(var f in p.list) {
			if(f is Integer)
				rn *= (f as Integer).ival;
			else if(f is Fraction) {
				rn *= (f as Fraction).num.ival;
				rd *= (f as Fraction).den.ival;
			} else
				return e;
		}

		return new Fraction.from_binary(
			new Integer.from_int(rn),
			new Integer.from_int(rd)
		);
	}

	Expression rne_eval_sum(Expression e) {
		var s = e as Sum;

		if(s == null)
			return e;

		var rn = 0;
		var rd = 1;

		foreach(var t in s.list) {
			if(t is Integer)
				rn += rd * (t as Integer).ival;
			else if(t is Fraction) {
				var n = (t as Fraction).num;
				var d = (t as Fraction).den;

				var lcm = rd * d.ival / (i_gcd(new Integer.from_int(rd), d) as Integer).ival;
				rn = rn * lcm / rd + n.ival * lcm / d.ival;
				rd = lcm;
			} else
				return e;
		}

		return new Fraction.from_binary(
			new Integer.from_int(rn),
			new Integer.from_int(rd)
		);
	}

	public Expression rne_simplify(Expression e) {
		var x = rne_simplify_rec(e);
		if(x is Undefined)
			return x;
		else
			return rne_simplify_fraction(x);
	}

	Expression rne_simplify_fraction(Expression e) {
		if(e is Integer)
			return e;
		else if(e is Fraction) {
			var f = e as Fraction;
			var n = f.num;
			var d = f.den;

			if((i_rem(n, d) as Integer).ival == 0)
				return i_quot(n, d);
			else {
				var g = i_gcd(n, d);
				if(d.ival > 0)
					return new Fraction.from_binary(
						i_quot(n, g) as Integer,
						i_quot(d, g) as Integer
					);
				else if(d.ival < 0) {
					return new Fraction.from_binary(
						i_quot(new Integer.from_int(-n.ival),g) as Integer,
						i_quot(new Integer.from_int(-d.ival),g) as Integer
					);
				} else
					return e;
			}
		} else
			return e;
	}

	Expression rne_simplify_rec(Expression e) {
		if(e is Integer)
			return e;
		else if(e is Fraction) {
			var f = e as Fraction;

			if(f.den.ival == 0)
				return undefined();
			else
				return e;
		} else if(e is Power) {
			var p = e as Power;
			var radix = rne_simplify_rec(p.list[0]);
			var exp = rne_simplify(p.list[1]);
			if(radix is Undefined)
				return radix;
			else
				return rne_eval_power(new Power(radix, exp));
		} else if(e is Product) {
			var p = e as Product;
			var p2 = new Product();
			foreach(var f in p.list) {
				f = rne_simplify_rec(f);
				if(f is Undefined)
					return f;
				p2.list.append(f);
			}
			return rne_eval_product(p2);
		} else if(e is Sum) {
			var s = e as Sum;
			var s2 = new Sum();
			foreach(var t in s.list) {
				t = rne_simplify_rec(t);
				if(t is Undefined)
					return t;
				s2.list.append(t);
			}
			return rne_eval_sum(s2);
		}
		return e;
	}
}
