/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

namespace Iko.CAS.Library {
	double eval(Expression x) throws Error {
		switch(x.kind) {
		case Kind.INTEGER:
			return (x as Integer).ival;
		case Kind.MUL:
			double r = 1;
			foreach(var f in x as CompoundExpression)
				r *= eval(f);
			return r;
		case Kind.SYMBOL:
				switch((x as Symbol).name) {
				case "Infinity":
					return double.INFINITY;
				default:
					throw new Error.RUNTIME(
						"%s: Unknown symbol '%s'",
						Log.METHOD,
						(x as Symbol).name
					);
				}
		default:
			throw new Error.INTERNAL("%s: Unhandled kind '%s'", Log.METHOD, x.kind.to_string());
		}
	}

	Expression b_simplify(Expression x) throws Error {
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
			if(eq[0].to_polish() == eq[1].to_polish())
				return bool_true();
			else
				return bool_false();
		case Kind.GE:
			var ge = x as CompoundExpression;
			if(eval(ge[0]) >= eval(ge[1]))
				return bool_true();
			else
				return bool_false();
		case Kind.GT:
			var gt = x as CompoundExpression;
			if(eval(gt[0]) > eval(gt[1]))
				return bool_true();
			else
				return bool_false();
		case Kind.NOT:
			var n = x as CompoundExpression;
			if((b_simplify(n[0]) as Boolean).bval)
				return bool_false();
			else
				return bool_true();
		case Kind.OR:
			var oe = x as CompoundExpression;
			foreach(var b in oe)
				if((b_simplify(b) as Boolean).bval)
					return bool_true();
			return bool_false();
		default:
			throw new Error.INTERNAL("%s: Unhandled kind '%s'", Log.METHOD, x.kind.to_string());
		}
	}
}
