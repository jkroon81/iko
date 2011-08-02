/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Fraction : Expression {
	public Integer num { get; construct; }
	public Integer den { get; construct; }

	public Fraction.from_binary(Integer num, Integer den) {
		Object(num : num, den : den);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_fraction(this);
	}

	public override void accept_children(Visitor v) {
		base.accept_children(v);
		num.accept(v);
		den.accept(v);
	}

	public override Expression eval() {
		return this;
	}
}
