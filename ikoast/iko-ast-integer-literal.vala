/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.IntegerLiteral : Literal {
	public static IntegerLiteral ZERO      { owned get { return new IntegerLiteral("0"); } }
	public static IntegerLiteral ONE       { owned get { return new IntegerLiteral("1"); } }
	public static IntegerLiteral MINUS_ONE { owned get { return new IntegerLiteral("-1"); } }

	public IntegerLiteral(string value) {
		this.value = value;
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_integer_literal(this);
	}
}
