/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

namespace Iko.CAS.Library {
	Expression rne_eval_power(CompoundExpression p) {
		var radix = p[0];
		var exp = p[1] as Integer;

		if(exp == null)
			return p;

		if(radix.kind == Kind.INTEGER || radix.kind == Kind.FRACTION) {
			if(exp.ival > 0) {
				var s = rne_eval_power(
					new CompoundExpression.from_binary(
						Kind.POWER,
						radix,
						new Integer.from_int(exp.ival - 1)
					)
				);
				return rne_eval_product(
					new CompoundExpression.from_binary(Kind.MUL, s, radix)
				);
			} else if(exp.ival == 0)
				return int_one();
			else if(exp.ival == -1) {
				if(radix.kind == Kind.INTEGER)
					return new Fraction(int_one(), radix as Integer);
				else
					return new Fraction((radix as Fraction).den, (radix as Fraction).num);
			} else {
				if(radix.kind == Kind.INTEGER) {
					var s = new Fraction(int_one(), radix as Integer);
					return rne_eval_power(
						new CompoundExpression.from_binary(
							Kind.POWER,
							s,
							new Integer.from_int(-exp.ival)
						)
					);
				} else {
					var s = new Fraction((radix as Fraction).den, (radix as Fraction).num);
					return rne_eval_power(
						new CompoundExpression.from_binary(
							Kind.POWER,
							s,
							new Integer.from_int(-exp.ival)
						)
					);
				}
			}
		} else
			return p;
	}

	Expression rne_eval_product(CompoundExpression p) {
		var rn = 1;
		var rd = 1;

		foreach(var f in p) {
			if(f.kind == Kind.INTEGER)
				rn *= (f as Integer).ival;
			else if(f.kind == Kind.FRACTION) {
				rn *= (f as Fraction).num.ival;
				rd *= (f as Fraction).den.ival;
			} else
				return p;
		}

		return new Fraction(new Integer.from_int(rn), new Integer.from_int(rd));
	}

	Expression rne_eval_sum(CompoundExpression s) {
		var rn = 0;
		var rd = 1;

		foreach(var t in s) {
			if(t.kind == Kind.INTEGER)
				rn += rd * (t as Integer).ival;
			else if(t.kind == Kind.FRACTION) {
				var n = (t as Fraction).num;
				var d = (t as Fraction).den;

				var lcm = rd * d.ival / (i_gcd(new Integer.from_int(rd), d) as Integer).ival;
				rn = rn * lcm / rd + n.ival * lcm / d.ival;
				rd = lcm;
			} else
				return s;
		}

		return new Fraction(new Integer.from_int(rn), new Integer.from_int(rd));
	}

	Expression rne_simplify(Expression e) {
		var x = rne_simplify_rec(e);
		if(x is Undefined)
			return x;
		else
			return rne_simplify_fraction(x);
	}

	Expression rne_simplify_fraction(Expression e) {
		if(e.kind == Kind.INTEGER)
			return e;
		else if(e.kind == Kind.FRACTION) {
			var f = e as Fraction;
			var n = f.num;
			var d = f.den;

			if((i_rem(n, d) as Integer).ival == 0)
				return i_quot(n, d);
			else {
				var g = i_gcd(n, d);
				if(d.ival > 0)
					return new Fraction(i_quot(n, g) as Integer, i_quot(d, g) as Integer);
				else if(d.ival < 0) {
					return new Fraction(
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
		if(e.kind == Kind.INTEGER)
			return e;
		else if(e.kind == Kind.FRACTION) {
			var f = e as Fraction;

			if(f.den.ival == 0)
				return undefined();
			else
				return e;
		} else if(e.kind == Kind.POWER) {
			var p = e as CompoundExpression;
			var radix = rne_simplify_rec(p[0]);
			var exp = rne_simplify(p[1]);
			if(radix is Undefined)
				return radix;
			else
				return rne_eval_power(
					new CompoundExpression.from_binary(Kind.POWER, radix, exp)
				);
		} else if(e.kind == Kind.MUL) {
			var p = e as CompoundExpression;
			var p2 = new CompoundExpression.from_empty(Kind.MUL);
			foreach(var f in p) {
				f = rne_simplify_rec(f);
				if(f is Undefined)
					return f;
				p2.append(f);
			}
			return rne_eval_product(p2);
		} else if(e.kind == Kind.PLUS) {
			var s = e as CompoundExpression;
			var s2 = new CompoundExpression.from_empty(Kind.PLUS);
			foreach(var t in s) {
				t = rne_simplify_rec(t);
				if(t is Undefined)
					return t;
				s2.append(t);
			}
			return rne_eval_sum(s2);
		}
		return e;
	}
}
