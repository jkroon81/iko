/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Iko.CAS;

class ValaWriter : Visitor {
	FileStream dst;
	bool newline;
	int indent;
	int parens_count;

	construct {
		indent = 0;
		parens_count = 0;
	}

	public void compile(Namespace ns, string outfile) throws Error {
		dst = FileStream.open(outfile, "w");
		if(dst == null)
			throw new Error.IO("Can't open file '%s' for writing", outfile);
		ns.accept(this);
		dst = null;
	}

	SList<unowned string> get_locals(SList<Statement> body) {
		var l = new SList<unowned string>();
		var locals = new HashTable<unowned string,int>(str_hash, str_equal);

		foreach(var s in body)
			if(s is Assignment) {
				var a = s as Assignment;
				locals[a.symbol.name] = 1;
			} else if(s is ForStatement) {
				var f = s as ForStatement;
				foreach(var t in get_locals(f.body))
					locals[t] = 1;
			} else if(s is ForEachStatement) {
				var fe = s as ForEachStatement;
				foreach(var t in get_locals(fe.body))
					locals[t] = 1;
			} else if(s is IfStatement) {
				var i = s as IfStatement;
				foreach(var t in get_locals(i.body_true))
					locals[t] = 1;
				foreach(var t in get_locals(i.body_false))
					locals[t] = 1;
			} else if(s is WhileStatement) {
				var w = s as WhileStatement;
				foreach(var t in get_locals(w.body))
					locals[t] = 1;
			}

		locals.for_each(
			(k, v) => {
				l.prepend(k);
			}
		);
		l.reverse();

		return l.copy();
	}

	string lookup_kind(string str) {
		switch(str) {
		case "integer":
			return "Kind.INTEGER";
		case "power":
			return "Kind.POWER";
		case "product":
			return "Kind.MUL";
		case "set":
			return "Kind.SET";
		case "sum":
			return "Kind.PLUS";
		default:
			stdout.printf("Unhandled kind '%s'\n", str);
			assert_not_reached();
		}
	}

	public override void visit_assignment(Assignment a) {
		write("%s = ".printf(a.symbol.name));
		a.expr.accept(this);
		write(";");
	}

	public override void visit_boolean(Boolean b) {
		if(b.bval)
			write("bool_true()");
		else
			write("bool_false()");
	}

	public override void visit_for_statement(ForStatement f) {
		write("for(int %s_ = (".printf(f.k.name));
		f.start.accept(this);
		write(" as Integer).to_int(); %s_ <= (".printf(f.k.name));
		f.end.accept(this);
		write(" as Integer).to_int(); %s_++) {".printf(f.k.name));
		write("Integer %s = new Integer.from_int(%s_);".printf(f.k.name, f.k.name));
		foreach(var s in f.body)
			s.accept(this);
		write("}");
	}

	public override void visit_foreach_statement(ForEachStatement f) {
		write("foreach(var %s in %s as List) {".printf(f.child.name, f.parent.to_string()));
		foreach(var s in f.body)
			s.accept(this);
		write("}");
	}

	public override void visit_function(Function f) {
		if(f.is_public)
			write("public ");
		write("Expression %s(".printf(f.name));
		for(unowned SList<Symbol> n = f.arg; n != null; n = n.next) {
			write("Expression %s".printf(n.data.name));
			if(n.next != null)
				write(", ");
		}
		write(") throws Error {");

		foreach(var l in get_locals(f.body))
			write("Expression %s;".printf(l));

		write("\n");

		foreach(var s in f.body)
			s.accept(this);
		write("}\n");
	}

	public override void visit_if_statement(IfStatement i) {
		write("if((simplify(");
		i.cond.accept(this);
		write(") as Boolean).bval) {");
		foreach(var s in i.body_true)
			s.accept(this);
		write("}");
		if(i.body_false.length() > 0) {
			write("else {");
			foreach(var s in i.body_false)
				s.accept(this);
			write("}");
		}
	}

	public override void visit_integer(Integer i) {
		switch(i.to_string()) {
		case "-1":
			write("int_neg_one()");
			break;
		case "0":
			write("int_zero()");
			break;
		case "1":
			write("int_one()");
			break;
		default:
			write("new Integer.from_string(\"%s\")".printf(i.to_string()));
			break;
		}
	}

	public override void visit_list(Iko.CAS.List l) {
		if(l.kind == Kind.ARRAY) {
			write("(");
			l[0].accept(this);
			write(" as List)[(");
			l[1].accept(this);
			write(" as Integer).to_int() - 1]");
		} else if(l.kind == Kind.FUNCTION) {
			l[0].accept(this);
			write("(");
			for(var i = 1; i < l.size; i++) {
				l[i].accept(this);
				if(i != l.size - 1)
					write(", ");
			}
			write(")");
		} else if(l.kind == Kind.IS) {
			write("new Boolean.from_bool(");
			l[0].accept(this);
			write(".kind == %s)".printf(lookup_kind(l[1].to_string())));
		} else {
			write("simplify(List.from_va(%s, %d, ".printf(
					l.kind.to_vala_string(),
					l.size
				)
			);
			for(var i = 0; i < l.size; i++) {
				l[i].accept(this);
				if(i != l.size - 1)
					write(", ");
			}
			write("))");
		}
	}

	public override void visit_namespace(Namespace ns) {
		write("namespace Iko.CAS.Library {");
		foreach(var f in ns.function)
			f.accept(this);
		write("}");
	}

	public override void visit_return_statement(ReturnStatement r) {
		write("return simplify(");
		r.expr.accept(this);
		write(");");
	}

	public override void visit_symbol(Symbol s) {
		switch(s.name) {
		case "Infinity":
			write("infinity()");
			break;
		case "Undefined":
			write("undefined()");
			break;
		default:
			write(s.name);
			break;
		}
	}

	public override void visit_vala_block(ValaBlock vb) {
		dst.puts(vb.text + "\n");
	}

	public override void visit_while_statement(WhileStatement w) {
		write("while((simplify(");
		w.cond.accept(this);
		write(") as Boolean).bval) {");
		foreach(var s in w.body)
			s.accept(this);
		write("}");
	}

	void write(string str) {
		char *c = (char*) str;

		while(*c != 0) {
			switch(*c) {
			case '{':
				dst.puts("{\n");
				newline = true;
				indent += 1;
				break;
			case '}':
				indent -= 1;
				dst.puts("%s}\n".printf(string.nfill(indent, '\t')));
				newline = true;
				break;
			case '(':
				dst.putc('(');
				parens_count++;
				break;
			case ')':
				dst.putc(')');
				parens_count--;
				break;
			case ';':
				dst.putc(';');
				if(parens_count == 0) {
					dst.putc('\n');
					newline = true;
				}
				break;
			case '\n':
				dst.putc('\n');
				newline = true;
				break;
			default:
				if(newline)
					dst.puts(string.nfill(indent, '\t'));
				dst.putc(*c);
				newline = false;
				break;
			}
			c++;
		}
	}
}
