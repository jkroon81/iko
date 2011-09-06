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

	public override void visit_boolean(Boolean b) {
		if(b.bval)
			buffer.append("true");
		else
			buffer.append("false");
	}

	public override void visit_fraction(Fraction f) {
		f.num.accept(this);
		buffer.append("/");
		f.den.accept(this);
	}

	public override void visit_integer(Integer i) {
		buffer.append(i.to_string());
	}

	public override void visit_list(List l) {
		if(l.kind == Kind.PLUS) {
			assert(l.size > 0);

			foreach(var t in l) {
				var c = t.constant();
				if(t != l[0] && c is Integer && Integer.cmp(c as Integer, int_zero()) < 0) {
					buffer.append(" - ");
					var c_new = Integer.abs(c as Integer);
					if(Integer.cmp(c_new, int_one()) != 0) {
						c_new.accept(this);
						buffer.append("*");
					}
					t.term().accept(this);
				} else if(t != l[0] && c is Fraction && Integer.cmp((c as Fraction).num, int_zero()) < 0) {
					var f = c as Fraction;
					buffer.append(" - ");
					var c_new = new Fraction(Integer.abs(f.num), f.den);
					c_new.accept(this);
					buffer.append("*");
					t.term().accept(this);
				} else {
					if(t != l[0])
						buffer.append(" + ");
					t.accept(this);
				}
			}
		} else if(l.kind == Kind.MUL) {
			assert(l.size > 0);
			var c = l.constant();

			if(c is Integer && Integer.cmp(c as Integer, int_neg_one()) == 0) {
				buffer.append("-");
				l.term().accept(this);
			} else {
				foreach(var f in l) {
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
			}
		} else if(l.kind == Kind.FACTORIAL) {
			bool guard = true;

			if((l[0].kind == Kind.INTEGER && Integer.cmp(l[0] as Integer, int_zero()) >= 0) ||
			   l[0].kind == Kind.SYMBOL ||
			   l[0].kind == Kind.FUNCTION ||
			   l[0].kind == Kind.LIST)
				guard = false;

			if(guard)
				buffer.append("(");
			l[0].accept(this);
			if(guard)
				buffer.append(")");
			buffer.append("!");
		} else if(l.kind == Kind.POWER) {
			bool guard = true;

			if((l[0].kind == Kind.INTEGER && Integer.cmp(l[0] as Integer, int_zero()) >= 0) ||
			   l[0].kind == Kind.FUNCTION ||
			   l[0].kind == Kind.SYMBOL ||
			   l[0].kind == Kind.LIST)
				guard = false;

			if(guard)
				buffer.append("(");
			l[0].accept(this);
			if(guard)
				buffer.append(")");

			buffer.append("^");

			guard = true;

			if(l[1].kind == Kind.INTEGER ||
			   l[1].kind == Kind.FACTORIAL ||
			   l[1].kind == Kind.FUNCTION ||
			   l[1].kind == Kind.SYMBOL ||
			   l[1].kind == Kind.LIST)
				guard = false;

			if(guard)
				buffer.append("(");
			l[1].accept(this);
			if(guard)
				buffer.append(")");
		} else if(l.kind == Kind.SET) {
			if(l.size == 0)
				buffer.append("{}");
			else {
				buffer.append("{ ");
				for(var i = 0; i < l.size; i++) {
					l[i].accept(this);
					if(i != l.size - 1)
						buffer.append(", ");
				}
				buffer.append(" }");
			}
		} else if(l.kind == Kind.FUNCTION) {
			l[0].accept(this);
			buffer.append("(");
			if(l.size > 1) {
				for(var i = 1; i < l.size; i++) {
					l[i].accept(this);
					buffer.append(", ");
				}
				buffer.erase(buffer.len - 2, 2);
			}
			buffer.append(")");
		} else if(l.kind == Kind.LIST) {
			if(l.size == 0)
				buffer.append("[]");
			else {
				buffer.append("[ ");
				foreach(var e in l) {
					e.accept(this);
					buffer.append(", ");
				}
				buffer.erase(buffer.len - 2, 2);
				buffer.append(" ]");
			}
		} else {
			error("%s: Unhandled kind '%s'\n", Log.METHOD, l.kind.to_string());
		}
	}

	public override void visit_symbol(Symbol s) {
		buffer.append(s.name);
	}
}
