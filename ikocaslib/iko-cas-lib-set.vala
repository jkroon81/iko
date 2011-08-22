/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

namespace Iko.CAS.Library {
	Expression set_member(Expression u, Expression S) {
		if(S.kind != Kind.SET)
			return bool_false();

		foreach(var e in S as CompoundExpression)
			if(e.to_polish() == u.to_polish())
				return bool_true();

		return bool_false();
	}

	List set_merge(List p, List q) {
		if(q.size == 0)
			return p;

		if(p.size == 0)
			return q;

		var h = set_simplify_rec(
			new List.from_binary(p[0], q[0])
		);

		if(h.size == 1) {
			var r = set_merge(p.tail(), q.tail());
			r.prepend(h[0]);
			return r;
		}

		if(bae_compare(p[0], q[0])) {
			var r = set_merge(p.tail(), q);
			r.prepend(p[0]);
			return r;
		} else {
			var r = set_merge(p, q.tail());
			r.prepend(q[0]);
			return r;
		}
	}

	Expression set_simplify(Expression e) {
		if(e.kind != Kind.SET)
			return e;

		var s = e as CompoundExpression;

		if(s.size == 0 || s.size == 1)
			return s;

		var v = set_simplify_rec(s.to_list());

		return new CompoundExpression.from_list(Kind.SET, v);
	}

	List set_simplify_rec(List l) {
		if(l.size == 2) {
			var u1 = l[0];
			var u2 = l[1];

			if(u1.to_polish() == u2.to_polish())
				return new List.from_unary(u1);

			if(bae_compare(u2, u1))
				return new List.from_binary(u2, u1);

			return l;
		} else {
			var w = set_simplify_rec(l.tail());
			return set_merge(new List.from_unary(l[0]), w);
		}
	}
}
