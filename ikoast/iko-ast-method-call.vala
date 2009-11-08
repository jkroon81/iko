/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.MethodCall : SimpleExpression {
	public SList<Expression> args;

	public Expression method { get; construct; }

	public MethodCall(Expression method) {
		this.method = method;
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_method_call(this);
	}

	public override void accept_children(Visitor v) {
		base.accept_children(v);
		method.accept(v);
		foreach(var a in args)
			a.accept(v);
	}
}
