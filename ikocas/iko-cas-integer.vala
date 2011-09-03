/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using GMP;

public class Iko.CAS.Integer : AtomicExpression {
	VarInt z;

	public Integer() {
		Object(kind : Kind.INTEGER);

		z = VarInt.long(0);
	}

	public Integer.from_int(int ival) {
		Object(kind : Kind.INTEGER);

		z = VarInt.long(ival);
	}

	public Integer.from_string(string sval) {
		Object(kind : Kind.INTEGER);

		z = VarInt.string(sval);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_integer(this);
	}

	public int to_int() {
		return (int) z.get_long();
	}

	public new string to_string() {
		return z.to_string();
	}

	public static Integer abs(Integer a) {
		var r = new Integer();
		r.z.abs(a.z);
		return r;
	}

	public static Integer add(Integer a, Integer b) {
		var r = new Integer();
		r.z.add(a.z, b.z);
		return r;
	}

	public static int cmp(Integer a, Integer b) {
		return VarInt.cmp(a.z, b.z);
	}

	public static Integer gcd(Integer a, Integer b) {
		var r = new Integer();
		r.z.gcd(a.z, b.z);
		return r;
	}

	public static Integer lcm(Integer a, Integer b) {
		var r = new Integer();
		r.z.lcm(a.z, b.z);
		return r;
	}

	public static Integer mul(Integer a, Integer b) {
		var r = new Integer();
		r.z.mul(a.z, b.z);
		return r;
	}

	public static Integer neg(Integer a) {
		var r = new Integer();
		r.z.neg(a.z);
		return r;
	}

	public static Integer quote(Integer a, Integer b) {
		var r = new Integer();
		r.z.tdiv_quot(a.z, b.z);
		return r;
	}

	public static Integer rem(Integer a, Integer b) {
		var r = new Integer();
		r.z.tdiv_rem(a.z, b.z);
		return r;
	}

	public static Integer sub(Integer a, Integer b) {
		var r = new Integer();
		r.z.sub(a.z, b.z);
		return r;
	}
}
