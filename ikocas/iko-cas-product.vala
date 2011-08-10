/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Product : CompoundExpression {
	public Product.from_binary(Expression x1, Expression x2) {
		append(x1);
		append(x2);
	}

	public Product.from_list(List l) {
		foreach(var f in l)
			append(f);
	}

	public Product.from_unary(Expression e) {
		append(e);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_product(this);
	}

	public override Expression eval() {
		return this;
	}
}
