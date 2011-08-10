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
		if(u is Constant && v is Constant) {
			float u_val;
			float v_val;

			if(u is Integer)
				u_val = (u as Integer).ival;
			else
				u_val = (u as Fraction).num.ival / (u as Fraction).den.ival;

			if(v is Integer)
				v_val = (v as Integer).ival;
			else
				v_val = (v as Fraction).num.ival / (v as Fraction).den.ival;

			return (u_val < v_val);
		}

		if(u is Symbol && v is Symbol)
			return ((u as Symbol).name < (v as Symbol).name);

		if((u is Product && v is Product) ||
		   (u is Sum && v is Sum)) {
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

		if(u is Power && v is Power) {
			if(u.radix().to_polish() != v.radix().to_polish())
				return bae_compare(u.radix(), v.radix());
			else
				return bae_compare(u.exponent(), v.exponent());
		}

		if(u is Factorial && v is Factorial)
			return bae_compare((u as Factorial)[0], (v as Factorial)[0]);

		if(u is FunctionCall && v is FunctionCall) {
			var f1 = (u as FunctionCall);
			var f2 = (v as FunctionCall);

			if(f1.symbol.name != f2.symbol.name)
				return f1.symbol.name < f2.symbol.name;

			for(var i = 0; i < f1.size && i < f2.size; i++)
				if(f1[i].to_polish() != f2[i].to_polish())
					return bae_compare(f1[i], f2[i]);

			return (f1.size < f2.size);
		}

		if(u is Constant)
			return true;

		if(u is Product)
			if(v is Power || v is Sum || v is Factorial || v is FunctionCall || v is Symbol)
				return bae_compare(u, new Product.from_unary(v));

		if(u is Power)
			if(v is Sum || v is Factorial || v is FunctionCall || v is Symbol)
				return bae_compare(u, new Power.from_binary(v, one()));

		if(u is Sum)
			if(v is Factorial || v is FunctionCall || v is Symbol)
				return bae_compare(u, new Sum.from_unary(v));

		if(u is Factorial)
			if(v is FunctionCall || v is Symbol) {
				if((u as Factorial)[0].to_polish() == v.to_polish())
					return false;
				else
					return bae_compare(u, new Factorial.from_unary(v));
			}

		if(u is FunctionCall && v is Symbol) {
			if((u as FunctionCall).symbol.name == (v as Symbol).name)
				return false;
			else
				return (u as FunctionCall).symbol.name < (v as Symbol).name;
		}

		return !bae_compare(v, u);
	}

	public Expression bae_simplify(Expression e) {
		if(e is Integer || e is Symbol )
			return e;
		else if(e is Fraction)
			return rne_simplify(e);
		else {
			var x = new Symbol("bae_simplify").map(e);
			if(x is Power)
				return bae_simplify_power(x as Power);
			else if(x is Product)
				return bae_simplify_product(x as Product);
			else if(x is Sum)
				return bae_simplify_sum(x as Sum);
			else if(x is Factorial)
				return bae_simplify_factorial(x as Factorial);
			else if(x is FunctionCall)
				return bae_simplify_function_call(x as FunctionCall);
			assert_not_reached();
		}
	}

	Expression bae_simplify_factorial(Factorial f) {
		if(f[0] is Integer)
			return bae_simplify_integer_factorial((f[0] as Integer));

		if(f[0] is Undefined)
			return f[0];

		return f;
	}

	Expression bae_simplify_function_call(FunctionCall fc) {
		foreach(var arg in fc)
			if(arg is Undefined)
				return arg;

		return fc;
	}

	Expression bae_simplify_integer_factorial(Integer f) {
		int s = f.ival;

		if(s < 0)
			return undefined();

		if(s == 0)
			return one();

		int r = s;

		while(--s > 0)
			r *= s;

		return new Integer.from_int(r);
	}

	public Expression bae_simplify_integer_power(Expression radix, Integer exp) {
		if(radix is Constant)
			return rne_simplify(new Power.from_binary(radix, exp));

		if(exp.ival == 0)
			return one();

		if(exp.ival == 1)
			return radix;

		if(radix is Power) {
			var radix_inner = (radix as Power)[0];
			var exp_inner = (radix as Power)[1];
			var exp_new = bae_simplify_product(new Product.from_binary(exp_inner, exp));

			if(exp_new is Integer)
				return bae_simplify_integer_power(radix_inner, exp_new as Integer);
			else
				return new Power.from_binary(radix_inner, exp_new);
		}

		if(radix is Product) {
			var p_new = new Symbol("bae_simplify_integer_power").map(radix, exp);
			return bae_simplify_product(p_new as Product);
		}

		return new Power.from_binary(radix, exp);
	}

	Expression bae_simplify_power(Power p) {
		var radix = p[0];
		var exp = p[1];

		if(radix is Undefined || exp is Undefined)
			return undefined();

		if(radix is Integer && (radix as Integer).ival == 0) {
			if((exp is Integer && (exp as Integer).ival > 0) ||
			   (exp is Fraction && (exp as Fraction).num.ival > 0))
				return zero();
			else
				return undefined();
		}

		if(radix is Integer && (radix as Integer).ival == 1)
			return one();

		if(exp is Integer)
			return bae_simplify_integer_power(radix, exp as Integer);

		return p;
	}

	Expression bae_simplify_product(Product p) {
		foreach(var f in p) {
			if(f is Undefined)
				return f;
			if(f is Integer && (f as Integer).ival == 0)
				return f;
		}

		if(p.size == 1)
			return p[0];

		var v = bae_simplify_product_rec(p.to_list());

		if(v.size == 0)
			return one();
		else if(v.size == 1)
			return v[0];
		else
			return new Product.from_list(v);
	}

	List bae_simplify_product_rec(List l) {
		if(l.size == 2) {
			var u1 = l[0];
			var u2 = l[1];

			if(!(u1 is Product) && !(u2 is Product)) {
				if(u1 is Constant && u2 is Constant) {
					var p = rne_simplify(new Product.from_binary(u1, u2));
					if(p is Integer && (p as Integer).ival == 1)
						return new List();
					else
						return new List.from_unary(p);
				}

				if(u1 is Integer && (u1 as Integer).ival == 1)
					return new List.from_unary(u2);

				if(u2 is Integer && (u2 as Integer).ival == 1)
					return new List.from_unary(u1);

				if(u1.radix().to_polish() == u2.radix().to_polish()) {
					var s = bae_simplify_sum(
						new Sum.from_binary(u1.exponent(), u2.exponent())
					);
					var p = bae_simplify_power(new Power.from_binary(u1.radix(), s));

					if(p is Integer && (p as Integer).ival == 1)
						return new List();
					else
						return new List.from_unary(p);
				}

				if(bae_compare(u2, u1))
					return new List.from_binary(u2, u1);

				return l;
			} else {
				if(u1 is Product && u2 is Product)
					return bae_merge_products(
						(u1 as Product).to_list(),
						(u2 as Product).to_list()
					);

				if(u1 is Product)
					return bae_merge_products(
						(u1 as Product).to_list(),
						new List.from_unary(u2)
					);

				if(u2 is Product)
					return bae_merge_products(
						new List.from_unary(u1),
						(u2 as Product).to_list()
					);

				assert_not_reached();
			}
		} else {
			var w = bae_simplify_product_rec(l.tail());
			if(l[0] is Product)
				return bae_merge_products((l[0] as Product).to_list(), w);
			else
				return bae_merge_products(new List.from_unary(l[0]), w);
		}
	}

	Expression bae_simplify_sum(Sum s) {
		foreach(var t in s)
			if(t is Undefined)
				return t;

		if(s.size == 1)
			return s[0];

		var v = bae_simplify_sum_rec(s.to_list());

		if(v.size == 0)
			return zero();
		else if(v.size == 1)
			return v[0];
		else
			return new Sum.from_list(v);
	}

	List bae_simplify_sum_rec(List l) {
		if(l.size == 2) {
			var u1 = l[0];
			var u2 = l[1];

			if(!(u1 is Sum) && !(u2 is Sum)) {
				if(u1 is Constant && u2 is Constant) {
					var p = rne_simplify(new Sum.from_binary(u1, u2));
					if(p is Integer && (p as Integer).ival == 0)
						return new List();
					else
						return new List.from_unary(p);
				}

				if(u1 is Integer && (u1 as Integer).ival == 0)
					return new List.from_unary(u2);

				if(u2 is Integer && (u2 as Integer).ival == 0)
					return new List.from_unary(u1);

				if(u1.term().to_polish() == u2.term().to_polish()) {
					var s = bae_simplify_sum(
						new Sum.from_binary(u1.constant(), u2.constant())
					);
					var p = bae_simplify_product(new Product.from_binary(s, u1.term()));

					if(p is Integer && (p as Integer).ival == 0)
						return new List();
					else
						return new List.from_unary(p);
				}

				if(bae_compare(u2, u1))
					return new List.from_binary(u2, u1);

				return l;
			} else {
				if(u1 is Sum && u2 is Sum)
					return bae_merge_sums(
						(u1 as Sum).to_list(),
						(u2 as Sum).to_list()
					);

				if(u1 is Sum)
					return bae_merge_sums(
						(u1 as Sum).to_list(),
						new List.from_unary(u2)
					);

				if(u2 is Sum)
					return bae_merge_sums(
						new List.from_unary(u1),
						(u2 as Sum).to_list()
					);

				assert_not_reached();
			}
		} else {
			var w = bae_simplify_sum_rec(l.tail());
			if(l[0] is Sum)
				return bae_merge_sums((l[0] as Sum).to_list(), w);
			else
				return bae_merge_sums(new List.from_unary(l[0]), w);
		}
	}
}
