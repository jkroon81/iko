/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.CAS.Expression : Node {
	public Kind kind { get; construct; }

	public Expression constant() {
		if(kind == Kind.SYMBOL ||
		   kind == Kind.PLUS ||
		   kind == Kind.POWER ||
		   kind == Kind.FACTORIAL ||
		   kind == Kind.FUNCTION)
			return int_one();
		if(kind == Kind.MUL) {
			var p = this as CompoundExpression;
			if(p[0].kind == Kind.INTEGER || p[0].kind == Kind.FRACTION)
				return p[0];
			else
				return int_one();
		}
		if(kind == Kind.INTEGER || kind == Kind.FRACTION)
			return undefined();
		assert_not_reached();
	}

	public Expression exponent() {
		if(kind == Kind.SYMBOL ||
		   kind == Kind.PLUS ||
		   kind == Kind.MUL ||
		   kind == Kind.FACTORIAL ||
		   kind == Kind.FUNCTION)
			return int_one();
		if(kind == Kind.POWER)
			return (this as CompoundExpression)[1];
		if(kind == Kind.INTEGER || kind == Kind.FRACTION)
			return undefined();
		assert_not_reached();
	}

	public Expression radix() {
		if(kind == Kind.SYMBOL ||
		   kind == Kind.PLUS ||
		   kind == Kind.MUL ||
		   kind == Kind.FACTORIAL ||
		   kind == Kind.FUNCTION)
			return this;
		if(kind == Kind.POWER)
			return (this as CompoundExpression)[0];
		if(kind == Kind.INTEGER || kind == Kind.FRACTION)
			return undefined();
		assert_not_reached();
	}

	public Expression term() {
		if(kind == Kind.SYMBOL ||
		   kind == Kind.PLUS ||
		   kind == Kind.POWER ||
		   kind == Kind.FACTORIAL ||
		   kind == Kind.FUNCTION)
			return new CompoundExpression.from_unary(Kind.MUL, this);
		if(kind == Kind.MUL) {
			var p = this as CompoundExpression;
			if(p[0].kind == Kind.INTEGER || p[0].kind == Kind.FRACTION)
				return new CompoundExpression.from_list(Kind.MUL, p.to_list().tail());
			else
				return p;
		}
		if(kind == Kind.INTEGER || kind == Kind.FRACTION)
			return undefined();
		assert_not_reached();
	}

	public string to_polish() {
		return new Iko.CAS.Polish().generate_string(this);
	}

	public string to_string() {
		return new Iko.CAS.Writer().generate_string(this);
	}
}
