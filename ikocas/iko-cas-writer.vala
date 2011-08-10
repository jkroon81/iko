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
		foreach(var e in eq) {
			e.accept(this);
			buffer.append(" = ");
		}
		buffer.erase(buffer.len - 3, 3);
	}

	public override void visit_factorial(Factorial f) {
		bool guard = true;

		if((f[0] is Integer && (f[0] as Integer).ival >= 0) ||
		   f[0] is Symbol || f[0] is FunctionCall || f[0] is List)
			guard = false;

		if(guard)
			buffer.append("(");
		f[0].accept(this);
		if(guard)
			buffer.append(")");
		buffer.append("!");
	}

	public override void visit_fraction(Fraction f) {
		f.num.accept(this);
		buffer.append("/");
		f.den.accept(this);
	}

	public override void visit_function_call(FunctionCall fc) {
		buffer.append(fc.name);
		buffer.append("(");
		if(fc.size > 0) {
			foreach(Expression arg in fc) {
				arg.accept(this);
				buffer.append(", ");
			}
			buffer.erase(buffer.len - 2, 2);
		}
		buffer.append(")");
	}

	public override void visit_integer(Integer i) {
		buffer.append(i.sval);
	}

	public override void visit_list(List l) {
		if(l.size == 0)
			buffer.append("[]");
		else {
			buffer.append("[ ");
			foreach(Expression e in l) {
				e.accept(this);
				buffer.append(" ");
			}
			buffer.append("]");
		}
	}

	public override void visit_power(Power p) {
		bool guard = true;

		if((p[0] is Integer && (p[0] as Integer).ival >= 0) ||
		   p[0] is FunctionCall || p[0] is Symbol || p[0] is List)
			guard = false;

		if(guard)
			buffer.append("(");
		p[0].accept(this);
		if(guard)
			buffer.append(")");

		buffer.append("^");

		guard = true;

		if(p[1] is Integer || p[1] is Factorial || p[1] is FunctionCall ||
		   p[1] is Symbol || p[1] is List)
			guard = false;

		if(guard)
			buffer.append("(");
		p[1].accept(this);
		if(guard)
			buffer.append(")");
	}

	public override void visit_product(Product p) {
		assert(p.size > 0);

		foreach(var f in p) {
			bool guard = false;

			if(f is Sum || f is Equality)
				guard = true;

			if(guard)
				buffer.append("(");
			f.accept(this);
			if(guard)
				buffer.append(")");
			buffer.append("*");
		}
		buffer.erase(buffer.len - 1, 1);
	}

	public override void visit_sum(Sum s) {
		assert(s.size > 0);

		foreach(var t in s) {
			t.accept(this);
			buffer.append(" + ");
		}
		buffer.erase(buffer.len - 3, 3);
	}

	public override void visit_symbol(Symbol s) {
		buffer.append(s.name);
	}
}
