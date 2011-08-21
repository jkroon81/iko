/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Fraction : AtomicExpression {
	public Integer num { get; construct; }
	public Integer den { get; construct; }

	public Fraction(Integer num, Integer den) {
		Object(
			kind : Kind.FRACTION,
			num : num,
			den : den
		);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_fraction(this);
	}
}
