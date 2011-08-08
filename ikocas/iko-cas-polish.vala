/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Polish : Visitor {
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
		buffer.append("(= ");
		foreach(var e in eq) {
			e.accept(this);
			buffer.append(" ");
		}
		buffer.erase(buffer.len - 1, 1);
		buffer.append(")");
	}

	public override void visit_factorial(Factorial f) {
		buffer.append("(! ");
		f[0].accept(this);
		buffer.append(")");
	}

	public override void visit_fraction(Fraction f) {
		buffer.append("(/ ");
		f.num.accept(this);
		buffer.append(" ");
		f.den.accept(this);
		buffer.append(")");
	}

	public override void visit_function_call(FunctionCall fc) {
		buffer.append("(" + fc.name + " ");
		foreach(Expression arg in fc) {
			arg.accept(this);
			buffer.append(" ");
		}
		buffer.erase(buffer.len - 1, 1);
		buffer.append(")");
	}

	public override void visit_integer(Integer i) {
		buffer.append(i.sval);
	}

	public override void visit_list(List l) {
		buffer.append("(list ");
		foreach(Expression e in l) {
			e.accept(this);
			buffer.append(" ");
		}
		buffer.erase(buffer.len - 1, 1);
		buffer.append(")");
	}

	public override void visit_power(Power p) {
		buffer.append("(^ ");
		p[0].accept(this);
		buffer.append(" ");
		p[1].accept(this);
		buffer.append(")");
	}

	public override void visit_product(Product p) {
		buffer.append("(* ");
		foreach(var f in p) {
			f.accept(this);
			buffer.append(" ");
		}
		buffer.erase(buffer.len - 1, 1);
		buffer.append(")");
	}

	public override void visit_sum(Sum s) {
		buffer.append("(+ ");
		foreach(var t in s) {
			t.accept(this);
			buffer.append(" ");
		}
		buffer.erase(buffer.len - 1, 1);
		buffer.append(")");
	}

	public override void visit_symbol(Symbol s) {
		buffer.append(s.name);
	}

	public override void visit_undefined(Undefined u) {
		buffer.append("Undefined");
	}
}
