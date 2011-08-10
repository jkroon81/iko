/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.CAS.Expression : Node {
	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_expression(this);
	}

	public Expression constant() {
		if(this is Symbol || this is Sum || this is Power || this is Factorial || this is FunctionCall)
			return one();
		if(this is Product) {
			var p = this as Product;
			if(p[0] is Constant)
				return p[0];
			else
				return one();
		}
		if(this is Constant)
			return undefined();
		assert_not_reached();
	}

	public abstract Expression eval();

	public Expression exponent() {
		if(this is Symbol || this is Sum || this is Product || this is Factorial || this is FunctionCall)
			return one();
		if(this is Power)
			return (this as Power)[1];
		if(this is Constant)
			return undefined();
		assert_not_reached();
	}

	public Expression radix() {
		if(this is Symbol || this is Sum || this is Product || this is Factorial || this is FunctionCall)
			return this;
		if(this is Power)
			return (this as Power)[0];
		if(this is Constant)
			return undefined();
		assert_not_reached();
	}

	public Expression term() {
		if(this is Symbol || this is Sum || this is Power || this is Factorial || this is FunctionCall)
			return new Product.from_unary(this);
		if(this is Product) {
			var p = this as Product;
			if(p[0] is Constant)
				return new Product.from_list(p.to_list().tail());
			else
				return p;
		}
		if(this is Constant)
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
