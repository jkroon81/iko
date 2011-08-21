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

	public override void visit_compound_expression(CompoundExpression ce) {
		if(ce.kind == Kind.PLUS) {
			assert(ce.size > 0);

			foreach(var t in ce) {
				t.accept(this);
				buffer.append(" + ");
			}
			buffer.erase(buffer.len - 3, 3);
		} else if(ce.kind == Kind.MUL) {
			assert(ce.size > 0);

			foreach(var f in ce) {
				bool guard = false;

				if(f.kind == Kind.EQ || f.kind == Kind.PLUS)
					guard = true;

				if(guard)
					buffer.append("(");
				f.accept(this);
				if(guard)
					buffer.append(")");
				buffer.append("*");
			}
			buffer.erase(buffer.len - 1, 1);
		} else if(ce.kind == Kind.FACTORIAL) {
			bool guard = true;

			if((ce[0].kind == Kind.INTEGER && (ce[0] as Integer).ival >= 0) ||
			   ce[0].kind == Kind.SYMBOL ||
			   ce[0].kind == Kind.FUNCTION ||
			   ce[0].kind == Kind.LIST)
				guard = false;

			if(guard)
				buffer.append("(");
			ce[0].accept(this);
			if(guard)
				buffer.append(")");
			buffer.append("!");
		} else if(ce.kind == Kind.POWER) {
			bool guard = true;

			if((ce[0].kind == Kind.INTEGER && (ce[0] as Integer).ival >= 0) ||
			   ce[0].kind == Kind.FUNCTION ||
			   ce[0].kind == Kind.SYMBOL ||
			   ce[0].kind == Kind.LIST)
				guard = false;

			if(guard)
				buffer.append("(");
			ce[0].accept(this);
			if(guard)
				buffer.append(")");

			buffer.append("^");

			guard = true;

			if(ce[1].kind == Kind.INTEGER ||
			   ce[1].kind == Kind.FACTORIAL ||
			   ce[1].kind == Kind.FUNCTION ||
			   ce[1].kind == Kind.SYMBOL ||
			   ce[1].kind == Kind.LIST)
				guard = false;

			if(guard)
				buffer.append("(");
			ce[1].accept(this);
			if(guard)
				buffer.append(")");
		} else if(ce.kind == Kind.FUNCTION) {
			ce[0].accept(this);
			buffer.append("(");
			if(ce.size > 1) {
				for(var i = 1; i < ce.size; i++) {
					ce[i].accept(this);
					buffer.append(", ");
				}
				buffer.erase(buffer.len - 2, 2);
			}
			buffer.append(")");
		} else if(ce.kind == Kind.LIST) {
			if(ce.size == 0)
				buffer.append("[]");
			else {
				buffer.append("[ ");
				foreach(var e in ce) {
					e.accept(this);
					buffer.append(" ");
				}
				buffer.append("]");
			}
		} else {
			error("%s: Unhandled kind '%s'\n", Log.METHOD, ce.kind.to_string());
		}
	}

	public override void visit_fraction(Fraction f) {
		f.num.accept(this);
		buffer.append("/");
		f.den.accept(this);
	}

	public override void visit_integer(Integer i) {
		buffer.append(i.sval);
	}

	public override void visit_symbol(Symbol s) {
		buffer.append(s.name);
	}
}
