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

	public override void visit_fraction(Fraction f) {
		buffer.append("(/ ");
		f.num.accept(this);
		buffer.append(" ");
		f.den.accept(this);
		buffer.append(")");
	}

	public override void visit_integer(Integer i) {
		buffer.append(i.to_string());
	}

	public override void visit_list(List l) {
		buffer.append("(%s ".printf(l.kind.to_string()));
		foreach(var x in l) {
			x.accept(this);
			buffer.append(" ");
		}
		buffer.erase(buffer.len - 1, 1);
		buffer.append(")");
	}

	public override void visit_string(String s) {
		buffer.append("\"" + s.value + "\"");
	}

	public override void visit_symbol(Symbol s) {
		buffer.append(s.name);
	}
}
