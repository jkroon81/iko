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
			if(Integer.cmp(exp, int_zero()) > 0) {
				var s = rne_eval_power(
					new CompoundExpression.from_binary(
						Kind.POWER,
						radix,
						Integer.sub(exp, int_one())
					)
				);
				return rne_eval_product(
					new CompoundExpression.from_binary(Kind.MUL, s, radix)
				);
			} else if(Integer.cmp(exp, int_zero()) == 0)
				return int_one();
			else if(Integer.cmp(exp, int_neg_one()) == 0) {
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
							Integer.neg(exp)
						)
					);
				} else {
					var s = new Fraction((radix as Fraction).den, (radix as Fraction).num);
					return rne_eval_power(
						new CompoundExpression.from_binary(
							Kind.POWER,
							s,
							Integer.neg(exp)
						)
					);
				}
			}
		} else
			return p;
	}

	Expression rne_eval_product(CompoundExpression p) {
		var rn = int_one();
		var rd = int_one();

		foreach(var f in p) {
			if(f.kind == Kind.INTEGER)
				rn = Integer.mul(rn, f as Integer);
			else if(f.kind == Kind.FRACTION) {
				rn = Integer.mul(rn, (f as Fraction).num);
				rd = Integer.mul(rd, (f as Fraction).den);
			} else
				return p;
		}

		return new Fraction(rn, rd);
	}

	Expression rne_eval_sum(CompoundExpression s) {
		var rn = int_zero();
		var rd = int_one();

		foreach(var t in s) {
			if(t.kind == Kind.INTEGER)
				rn = Integer.add(rn, Integer.mul(rd, t as Integer));
			else if(t.kind == Kind.FRACTION) {
				var n = (t as Fraction).num;
				var d = (t as Fraction).den;

				var lcm = Integer.lcm(rd, d);
				rn = Integer.add(Integer.quote(Integer.mul(rn, lcm), rd), Integer.quote(Integer.mul(n, lcm), d));
				rd = lcm;
			} else
				return s;
		}

		return new Fraction(rn, rd);
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

			try {
				if(Integer.cmp(i_rem(n, d) as Integer, int_zero()) == 0)
					return i_quot(n, d);
				else {
					var g = i_gcd(n, d);
					if(Integer.cmp(d, int_zero()) > 0)
						return new Fraction(i_quot(n, g) as Integer, i_quot(d, g) as Integer);
					else if(Integer.cmp(d, int_zero()) < 0) {
						return new Fraction(
							i_quot(Integer.neg(n),g) as Integer,
							i_quot(Integer.neg(d),g) as Integer
						);
					} else
						return e;
				}
			} catch(Error e) {
				assert_not_reached();
			}
		} else
			return e;
	}

	Expression rne_simplify_rec(Expression e) {
		if(e.kind == Kind.INTEGER)
			return e;
		else if(e.kind == Kind.FRACTION) {
			var f = e as Fraction;

			if(Integer.cmp(f.den, int_zero()) == 0)
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
