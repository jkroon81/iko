/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.BinaryExpression : Expression {
	public enum Operator {
		DIV,
		MINUS,
		MUL,
		PLUS,
		POWER,
		NONE;

		public int priority() {
			switch(this) {
			case DIV:   return 2;
			case MINUS: return 1;
			case MUL:   return 2;
			case PLUS:  return 1;
			case POWER: return 3;
			default:    assert_not_reached();
			}
		}

		public string to_string() {
			switch(this) {
			case DIV:   return "/";
			case MINUS: return "-";
			case MUL:   return "*";
			case PLUS:  return "+";
			case POWER: return "^";
			default:    assert_not_reached();
			}
		}
	}

	public Operator   op    { get; construct; }
	public Expression left  { get; construct; }
	public Expression right { get; construct; }

	public override DataType data_type { get { return left.data_type; } }

	public BinaryExpression(SourceReference? src, Operator op, Expression left, Expression right) {
		this.src   = src;
		this.op    = op;
		this.left  = left;
		this.right = right;
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_binary_expression(this);
	}

	public override void accept_children(Visitor v) {
		base.accept_children(v);
		left.accept(v);
		right.accept(v);
	}
}
