/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.Writer : Visitor {
	StringBuilder buffer;
	bool          newline;
	int           indent;

	public int indent_size { private get; set; default = 2; }

	construct {
		buffer  = new StringBuilder();
		newline = true;
		indent  = 0;
	}

	void write(string str) {
		char *c = (char*) str;

		while(*c != 0) {
			switch(*c) {
			case '{':
				buffer.append("{\n");
				newline = true;
				indent += indent_size;
				break;
			case '}':
				indent -= indent_size;
				buffer.append_printf("%s}\n", string.nfill(indent, ' '));
				newline = true;
				break;
			case ';':
				buffer.append(";\n");
				newline = true;
				break;
			default:
				if(newline)
					buffer.append(string.nfill(indent, ' '));
				buffer.append_c(*c);
				newline = false;
				break;
			}
			c++;
		}
	}

	public string generate_string(Node n) {
		buffer.truncate(0);
		n.accept(this);
		return buffer.str;
	}

	public override void visit_constant(Constant c) {
		write(c.name);
		write(";");
	}

	public override void visit_system(System s) {
		write("system {");
		if(s.constants.length() > 0) {
			write("constant {");
			foreach(var c in s.constants)
				c.accept(this);
			write("}");
		}
		if(s.equations.length() > 0) {
			write("equation {");
			foreach(var eq in s.equations) {
				write(new Iko.CAS.Writer().generate_string(eq));
				write(";");
			}
			write("}");
		}
		if(s.variables.length() > 0) {
			write("variable {");
			foreach(var v in s.variables)
				v.accept(this);
			write("}");
		}
		write("}");
	}

	public override void visit_variable(Variable v) {
		write(v.name);
		write(" {");
		write("derivative {");
		foreach(var p in v.params) {
			var expr = v.der.lookup(p);
			write(p.name);
			write(" = ");
			if(expr != null)
				write(new Iko.CAS.Writer().generate_string(expr));
			else
				write("(null)");
			write(";");
		}
		write("}");
		write("}");
	}
}
