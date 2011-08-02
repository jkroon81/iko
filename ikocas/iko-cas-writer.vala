/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Writer : Visitor {
	StringBuilder buffer;

	construct {
		buffer  = new StringBuilder();
	}

	public string generate_string(Node n) {
		buffer.truncate(0);
		n.accept(this);
		return buffer.str;
	}

	public override void visit_equality(Equality eq) {
		foreach(var e in eq.list) {
			e.accept(this);
			buffer.append("=");
		}
		buffer.erase(buffer.len - 1, 1);
	}

	public override void visit_fraction(Fraction f) {
		f.num.accept(this);
		buffer.append("/");
		f.den.accept(this);
	}

	public override void visit_function_call(FunctionCall fc) {
		buffer.append(fc.name);
		buffer.append("(");
		foreach(Expression arg in fc.list) {
			arg.accept(this);
			buffer.append(",");
		}
		buffer.erase(buffer.len - 1, 1);
		buffer.append(")");
	}

	public override void visit_integer(Integer i) {
		buffer.append(i.sval);
	}

	public override void visit_list(List l) {
		buffer.append("[");
		foreach(Expression e in l.list) {
			e.accept(this);
			buffer.append(",");
		}
		buffer.erase(buffer.len - 1, 1);
		buffer.append("]");
	}

	public override void visit_power(Power p) {
		p.list[0].accept(this);
		buffer.append("^");
		p.list[1].accept(this);
	}

	public override void visit_product(Product p) {
		foreach(var f in p.list) {
			f.accept(this);
			buffer.append("*");
		}
		buffer.erase(buffer.len - 1, 1);
	}

	public override void visit_sum(Sum s) {
		foreach(var t in s.list) {
			t.accept(this);
			buffer.append("+");
		}
		buffer.erase(buffer.len - 1, 1);
	}

	public override void visit_symbol(Symbol s) {
		buffer.append(s.name);
	}

	public override void visit_undefined(Undefined u) {
		buffer.append("Undefined");
	}
}
