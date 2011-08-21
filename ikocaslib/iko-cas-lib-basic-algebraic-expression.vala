/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

namespace Iko.CAS.Library {
	List bae_merge_products(List p, List q) {
		if(q.size == 0)
			return p;

		if(p.size == 0)
			return q;

		var h = bae_simplify_product_rec(
			new List.from_binary(p[0], q[0])
		);

		if(h.size == 0)
			return bae_merge_products(p.tail(), q.tail());

		if(h.size == 1) {
			var r = bae_merge_products(p.tail(), q.tail());
			r.prepend(h[0]);
			return r;
		}

		if(h.to_polish() == new List.from_binary(p[0], q[0]).to_polish()) {
			var r = bae_merge_products(p.tail(), q);
			r.prepend(p[0]);
			return r;
		}

		if(h.to_polish() == new List.from_binary(q[0], p[0]).to_polish()) {
			var r = bae_merge_products(p, q.tail());
			r.prepend(q[0]);
			return r;
		}

		assert_not_reached();
	}

	List bae_merge_sums(List p, List q) {
		if(q.size == 0)
			return p;

		if(p.size == 0)
			return q;

		var h = bae_simplify_sum_rec(
			new List.from_binary(p[0], q[0])
		);

		if(h.size == 0)
			return bae_merge_sums(p.tail(), q.tail());

		if(h.size == 1) {
			var r = bae_merge_sums(p.tail(), q.tail());
			r.prepend(h[0]);
			return r;
		}

		if(h.to_polish() == new List.from_binary(p[0], q[0]).to_polish()) {
			var r = bae_merge_sums(p.tail(), q);
			r.prepend(p[0]);
			return r;
		}

		if(h.to_polish() == new List.from_binary(q[0], p[0]).to_polish()) {
			var r = bae_merge_sums(p, q.tail());
			r.prepend(q[0]);
			return r;
		}

		assert_not_reached();
	}

	bool bae_compare(Expression u, Expression v) {
		if((u.kind == Kind.INTEGER || u.kind == Kind.FRACTION) &&
		   (v.kind == Kind.INTEGER || v.kind == Kind.FRACTION)) {
			float u_val;
			float v_val;

			if(u.kind == Kind.INTEGER)
				u_val = (u as Integer).ival;
			else
				u_val = (u as Fraction).num.ival / (u as Fraction).den.ival;

			if(v.kind == Kind.INTEGER)
				v_val = (v as Integer).ival;
			else
				v_val = (v as Fraction).num.ival / (v as Fraction).den.ival;

			return (u_val < v_val);
		}

		if(u.kind == Kind.SYMBOL && v.kind == Kind.SYMBOL)
			return ((u as Symbol).name < (v as Symbol).name);

		if((u.kind == Kind.MUL && v.kind == Kind.MUL) ||
		   (u.kind == Kind.PLUS && v.kind == Kind.PLUS)) {
			var c1 = u as CompoundExpression;
			var c2 = v as CompoundExpression;
			var i = c1.size - 1;
			var j = c2.size - 1;

			while(i >= 0 && j >= 0) {
				if(c1[i].to_polish() != c2[j].to_polish())
					return bae_compare(c1[i], c2[j]);
				i--;
				j--;
			}
			return (c1.size < c2.size);
		}

		if(u.kind == Kind.POWER && v.kind == Kind.POWER) {
			if(u.radix().to_polish() != v.radix().to_polish())
				return bae_compare(u.radix(), v.radix());
			else
				return bae_compare(u.exponent(), v.exponent());
		}

		if(u.kind == Kind.FACTORIAL && v.kind == Kind.FACTORIAL)
			return bae_compare((u as CompoundExpression)[0], (v as CompoundExpression)[0]);

		if(u.kind == Kind.FUNCTION && v.kind == Kind.FUNCTION) {
			var f1 = (u as CompoundExpression);
			var f2 = (v as CompoundExpression);

			if((f1[0] as Symbol).name != (f2[0] as Symbol).name)
				return (f1[0] as Symbol).name < (f2[0] as Symbol).name;

			for(var i = 1; i < f1.size && i < f2.size; i++)
				if(f1[i].to_polish() != f2[i].to_polish())
					return bae_compare(f1[i], f2[i]);

			return (f1.size < f2.size);
		}

		if(u.kind == Kind.INTEGER || u.kind == Kind.FRACTION)
			return true;

		if(u.kind == Kind.MUL)
			if(v.kind == Kind.POWER ||
			   v.kind == Kind.PLUS ||
			   v.kind == Kind.FACTORIAL ||
			   v.kind == Kind.FUNCTION ||
			   v.kind == Kind.SYMBOL)
				return bae_compare(u, new CompoundExpression.from_unary(Kind.MUL, v));

		if(u.kind == Kind.POWER)
			if(v.kind == Kind.PLUS ||
			   v.kind == Kind.FACTORIAL ||
			   v.kind == Kind.FUNCTION ||
			   v.kind == Kind.SYMBOL)
				return bae_compare(
					u,
					new CompoundExpression.from_binary(Kind.POWER, v, int_one())
				);

		if(u.kind == Kind.PLUS)
			if(v.kind == Kind.FACTORIAL ||
			   v.kind == Kind.FUNCTION ||
			   v.kind == Kind.SYMBOL)
				return bae_compare(u, new CompoundExpression.from_unary(Kind.PLUS, v));

		if(u.kind == Kind.FACTORIAL)
			if(v.kind == Kind.FUNCTION || v.kind == Kind.SYMBOL) {
				if((u as CompoundExpression)[0].to_polish() == v.to_polish())
					return false;
				else
					return bae_compare(
						u,
						new CompoundExpression.from_unary(Kind.FACTORIAL, v)
					);
			}

		if(u.kind == Kind.FUNCTION && v.kind == Kind.SYMBOL) {
			if(((u as CompoundExpression)[0] as Symbol).name == (v as Symbol).name)
				return false;
			else
				return ((u as CompoundExpression)[0] as Symbol).name < (v as Symbol).name;
		}

		return !bae_compare(v, u);
	}

	Expression bae_simplify(Expression e) {
		switch(e.kind) {
		case Kind.FACTORIAL:
			return bae_simplify_factorial(e as CompoundExpression);
		case Kind.MUL:
			return bae_simplify_product(e as CompoundExpression);
		case Kind.PLUS:
			return bae_simplify_sum(e as CompoundExpression);
		case Kind.POWER:
			return bae_simplify_power(e as CompoundExpression);
		default:
			error("%s: Unhandled kind '%s'", Log.METHOD, e.kind.to_string());
		}
	}

	Expression bae_simplify_factorial(CompoundExpression f) {
		if(f[0].kind == Kind.INTEGER)
			return bae_simplify_integer_factorial((f[0] as Integer));

		if(f[0] is Undefined)
			return f[0];

		return f;
	}

	Expression bae_simplify_integer_factorial(Integer f) {
		int s = f.ival;

		if(s < 0)
			return undefined();

		if(s == 0)
			return int_one();

		int r = s;

		while(--s > 0)
			r *= s;

		return new Integer.from_int(r);
	}

	public Expression bae_simplify_integer_power(Expression radix, Integer exp) {
		if(radix.kind == Kind.INTEGER || radix.kind == Kind.FRACTION)
			return rne_simplify(
				new CompoundExpression.from_binary(Kind.POWER, radix, exp)
			);

		if(exp.ival == 0)
			return int_one();

		if(exp.ival == 1)
			return radix;

		if(radix.kind == Kind.POWER) {
			var radix_inner = (radix as CompoundExpression)[0];
			var exp_inner = (radix as CompoundExpression)[1];
			var exp_new = bae_simplify_product(
				new CompoundExpression.from_binary(Kind.MUL, exp_inner, exp)
			);

			if(exp_new.kind == Kind.INTEGER)
				return bae_simplify_integer_power(radix_inner, exp_new as Integer);
			else
				return new CompoundExpression.from_binary(
					Kind.POWER,
					radix_inner,
					exp_new
				);
		}

		if(radix.kind == Kind.MUL) {
			var p_new = new Symbol("bae_simplify_integer_power").map(radix, exp);
			return bae_simplify_product(p_new as CompoundExpression);
		}

		return new CompoundExpression.from_binary(Kind.POWER, radix, exp);
	}

	Expression bae_simplify_power(CompoundExpression p) {
		var radix = p[0];
		var exp = p[1];

		if(radix is Undefined || exp is Undefined)
			return undefined();

		if(radix.kind == Kind.INTEGER && (radix as Integer).ival == 0) {
			if((exp.kind == Kind.INTEGER && (exp as Integer).ival > 0) ||
			   (exp.kind == Kind.FRACTION && (exp as Fraction).num.ival > 0))
				return int_zero();
			else
				return undefined();
		}

		if(radix.kind == Kind.INTEGER && (radix as Integer).ival == 1)
			return int_one();

		if(exp.kind == Kind.INTEGER)
			return bae_simplify_integer_power(radix, exp as Integer);

		return p;
	}

	Expression bae_simplify_product(CompoundExpression p) {
		foreach(var f in p) {
			if(f is Undefined)
				return f;
			if(f.kind == Kind.INTEGER && (f as Integer).ival == 0)
				return f;
		}

		if(p.size == 1)
			return p[0];

		var v = bae_simplify_product_rec(p.to_list());

		if(v.size == 0)
			return int_one();
		else if(v.size == 1)
			return v[0];
		else
			return new CompoundExpression.from_list(Kind.MUL, v);
	}

	List bae_simplify_product_rec(List l) {
		if(l.size == 2) {
			var u1 = l[0];
			var u2 = l[1];

			if(u1.kind != Kind.MUL && u2.kind != Kind.MUL) {
				if((u1.kind == Kind.INTEGER || u1.kind == Kind.FRACTION) &&
				   (u2.kind == Kind.INTEGER || u2.kind == Kind.FRACTION)) {
					var p = rne_simplify(
						new CompoundExpression.from_binary(Kind.MUL, u1, u2)
					);
					if(p.kind == Kind.INTEGER && (p as Integer).ival == 1)
						return new List();
					else
						return new List.from_unary(p);
				}

				if(u1.kind == Kind.INTEGER && (u1 as Integer).ival == 1)
					return new List.from_unary(u2);

				if(u2.kind == Kind.INTEGER && (u2 as Integer).ival == 1)
					return new List.from_unary(u1);

				if(u1.radix().to_polish() == u2.radix().to_polish()) {
					var s = bae_simplify_sum(
						new CompoundExpression.from_binary(
							Kind.PLUS,
							u1.exponent(),
							u2.exponent()
						)
					);
					var p = bae_simplify_power(
						new CompoundExpression.from_binary(Kind.POWER, u1.radix(), s)
					);

					if(p.kind == Kind.INTEGER && (p as Integer).ival == 1)
						return new List();
					else
						return new List.from_unary(p);
				}

				if(bae_compare(u2, u1))
					return new List.from_binary(u2, u1);

				return l;
			} else {
				if(u1.kind == Kind.MUL && u2.kind == Kind.MUL)
					return bae_merge_products(
						(u1 as CompoundExpression).to_list(),
						(u2 as CompoundExpression).to_list()
					);

				if(u1.kind == Kind.MUL)
					return bae_merge_products(
						(u1 as CompoundExpression).to_list(),
						new List.from_unary(u2)
					);

				if(u2.kind == Kind.MUL)
					return bae_merge_products(
						new List.from_unary(u1),
						(u2 as CompoundExpression).to_list()
					);

				assert_not_reached();
			}
		} else {
			var w = bae_simplify_product_rec(l.tail());
			if(l[0].kind == Kind.MUL)
				return bae_merge_products((l[0] as CompoundExpression).to_list(), w);
			else
				return bae_merge_products(new List.from_unary(l[0]), w);
		}
	}

	Expression bae_simplify_sum(CompoundExpression s) {
		foreach(var t in s)
			if(t is Undefined)
				return t;

		if(s.size == 1)
			return s[0];

		var v = bae_simplify_sum_rec(s.to_list());

		if(v.size == 0)
			return int_zero();
		else if(v.size == 1)
			return v[0];
		else
			return new CompoundExpression.from_list(Kind.PLUS, v);
	}

	List bae_simplify_sum_rec(List l) {
		if(l.size == 2) {
			var u1 = l[0];
			var u2 = l[1];

			if(u1.kind != Kind.PLUS && u2.kind != Kind.PLUS) {
				if((u1.kind == Kind.INTEGER || u1.kind == Kind.FRACTION) &&
				   (u2.kind == Kind.INTEGER || u2.kind == Kind.FRACTION)) {
					var p = rne_simplify(
						new CompoundExpression.from_binary(Kind.PLUS, u1, u2)
					);
					if(p.kind == Kind.INTEGER && (p as Integer).ival == 0)
						return new List();
					else
						return new List.from_unary(p);
				}

				if(u1.kind == Kind.INTEGER && (u1 as Integer).ival == 0)
					return new List.from_unary(u2);

				if(u2.kind == Kind.INTEGER && (u2 as Integer).ival == 0)
					return new List.from_unary(u1);

				if(u1.term().to_polish() == u2.term().to_polish()) {
					var s = bae_simplify_sum(
						new CompoundExpression.from_binary(
							Kind.PLUS,
							u1.constant(),
							u2.constant()
						)
					);
					var p = bae_simplify_product(
						new CompoundExpression.from_binary(Kind.MUL, s, u1.term())
					);

					if(p.kind == Kind.INTEGER && (p as Integer).ival == 0)
						return new List();
					else
						return new List.from_unary(p);
				}

				if(bae_compare(u2, u1))
					return new List.from_binary(u2, u1);

				return l;
			} else {
				if(u1.kind == Kind.PLUS && u2.kind == Kind.PLUS)
					return bae_merge_sums(
						(u1 as CompoundExpression).to_list(),
						(u2 as CompoundExpression).to_list()
					);

				if(u1.kind == Kind.PLUS)
					return bae_merge_sums(
						(u1 as CompoundExpression).to_list(),
						new List.from_unary(u2)
					);

				if(u2.kind == Kind.PLUS)
					return bae_merge_sums(
						new List.from_unary(u1),
						(u2 as CompoundExpression).to_list()
					);

				assert_not_reached();
			}
		} else {
			var w = bae_simplify_sum_rec(l.tail());
			if(l[0].kind == Kind.PLUS)
				return bae_merge_sums((l[0] as CompoundExpression).to_list(), w);
			else
				return bae_merge_sums(new List.from_unary(l[0]), w);
		}
	}
}
