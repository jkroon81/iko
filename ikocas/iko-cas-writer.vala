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

	public override void visit_algebraic_expression(AlgebraicExpression ae) {
		var op = ae.op.to_string();
		foreach(Expression e in ae.list) {
			e.accept(this);
			buffer.append(op);
		}
		buffer.erase(buffer.len - op.length, op.length);
	}

	public override void visit_function_call(FunctionCall fc) {
		buffer.append(fc.name);
		buffer.append("(");
		foreach(Expression arg in fc.list) {
			arg.accept(this);
			buffer.append(",");
		}
		buffer.erase(buffer.len -1, 1);
		buffer.append(")");
	}

	public override void visit_integer(Integer i) {
		buffer.append(i.sval);
	}

	public override void visit_real(Real r) {
		buffer.append(r.value);
	}

	public override void visit_symbol(Symbol s) {
		buffer.append(s.name);
	}
}
