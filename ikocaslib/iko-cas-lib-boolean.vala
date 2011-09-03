/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

namespace Iko.CAS.Library {
	Expression b_simplify(Expression x) {
		switch(x.kind) {
		case Kind.AND:
			var ae = x as CompoundExpression;
			foreach(var b in ae)
				if(!(b_simplify(b) as Boolean).bval)
					return bool_false();
			return bool_true();
		case Kind.BOOLEAN:
			return x;
		case Kind.EQ:
			var eq = x as CompoundExpression;
			return b_simplify_eq(eq[0], eq[1]);
		case Kind.GE:
			var ge = x as CompoundExpression;
			return b_simplify_ge(ge[0], ge[1]);
		case Kind.GT:
			var gt = x as CompoundExpression;
			return b_simplify_gt(gt[0], gt[1]);
		case Kind.LE:
			var le = x as CompoundExpression;
			return b_simplify_le(le[0], le[1]);
		case Kind.LT:
			var lt = x as CompoundExpression;
			return b_simplify_lt(lt[0], lt[1]);
		case Kind.NE:
			var ne = x as CompoundExpression;
			if(ne[0].to_polish() != ne[1].to_polish())
				return bool_true();
			else
				return bool_false();
		case Kind.NOT:
			var n = x as CompoundExpression;
			return b_simplify_not(n[0]);
		case Kind.OR:
			var oe = x as CompoundExpression;
			return b_simplify_or(oe[0], oe[1]);
		default:
			assert_not_reached();
		}
	}

	Expression b_simplify_eq(Expression a, Expression b) {
		if(a.to_polish() == b.to_polish())
			return bool_true();
		else
			return bool_false();
	}

	Expression b_simplify_ge(Expression a, Expression b) {
		return b_simplify_or(b_simplify_gt(a, b), b_simplify_eq(a, b));
	}

	Expression b_simplify_gt(Expression a, Expression b) {
		if(a.kind == Kind.INTEGER && b.kind == Kind.INTEGER) {
			if(Integer.cmp(a as Integer, b as Integer) > 0)
				return bool_true();
			else
				return bool_false();
		}

		if(a.kind == Kind.INTEGER && b.kind == Kind.SYMBOL) {
			var s = b as Symbol;
			switch(s.name) {
			case "Infinity":
				return bool_false();
			default:
				assert_not_reached();
			}
		}

		if(a.kind == Kind.SYMBOL && b.kind == Kind.INTEGER)
			return b_simplify_not(b_simplify_ge(b, a));

		if(a.kind == Kind.MUL && b.kind == Kind.INTEGER) {
			var ca = a.constant();
			if(ca.to_polish() == int_neg_one().to_polish()) {
				var inv = new CompoundExpression.from_binary(
					Kind.POWER, ca, int_neg_one()
				);
				try {
					var an = simplify(new CompoundExpression.from_binary(Kind.MUL, a, inv));
					var bn = simplify(new CompoundExpression.from_binary(Kind.MUL, b, inv));
					return b_simplify_lt(an, bn);
				} catch(Error r) {
					assert_not_reached();
				}
			} else
				assert_not_reached();
		}

		if(a.kind == Kind.INTEGER && b.kind == Kind.MUL)
			return b_simplify_not(b_simplify_ge(b, a));

		assert_not_reached();
	}

	Expression b_simplify_le(Expression a, Expression b) {
		return b_simplify_or(b_simplify_lt(a, b), b_simplify_eq(a, b));
	}

	Expression b_simplify_lt(Expression a, Expression b) {
		return b_simplify_not(b_simplify_ge(a, b));
	}

	Expression b_simplify_not(Expression a) {
		if((a as Boolean).bval)
			return bool_false();
		else
			return bool_true();
	}

	Expression b_simplify_or(Expression a, Expression b) {
		if((a as Boolean).bval || (b as Boolean).bval)
			return bool_true();
		else
			return bool_false();
	}
}
