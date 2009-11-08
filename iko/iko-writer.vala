/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.Writer : Visitor {
	StringBuilder buffer;
	Namespace     root;
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

	public override void visit_array_access(ArrayAccess aa) {
		aa.array.accept(this);
		write("[");
		aa.index.accept(this);
		write("]");
	}

	public override void visit_array_type(ArrayType at) {
		at.element_type.accept(this);
		write("[");
		at.length.accept(this);
		write("]");
	}

	public override void visit_binary_expression(BinaryExpression be) {
		if(be.left is BinaryExpression &&
			 (be.left as BinaryExpression).op.priority() < be.op.priority()) {
			write("(");
			be.left.accept(this);
			write(")");
		} else
			be.left.accept(this);
		write(be.op.to_string());
		if(be.right is BinaryExpression &&
			 (be.right as BinaryExpression).op.priority() < be.op.priority()) {
			write("(");
			be.right.accept(this);
			write(")");
		} else
			be.right.accept(this);
	}

	public override void visit_class(Class c) {
		if(!c.visible)
			return;
		write("class %s {".printf(c.name));
		foreach(var t in c.types)
			t.accept(this);
		foreach(var f in c.fields)
			f.accept(this);
		foreach(var m in c.methods)
			m.accept(this);
		foreach(var e in c.equations)
			e.accept(this);
		write("}");
	}

	public override void visit_context(Context c) {
		root = c.root;
		c.accept_children(this);
		root = null;
	}

	public override void visit_equation(Equation e) {
		e.left.accept(this);
		write("=");
		e.right.accept(this);
		write(";");
	}

	public override void visit_field(Field f) {
		if(f.binding == Member.Binding.STATIC)
			write("static ");
		f.data_type.accept(this);
		write(" %s".printf(f.name));
		if(f.params != null) {
			write("[");
			for(unowned SList<Expression> node = f.params; node != null; node = node.next) {
				node.data.accept(this);
				if(node.next != null)
					write(",");
			}
			write("]");
		}
		write(";");
	}

	public override void visit_literal(Literal l) {
		write(l.value);
	}

	public override void visit_member_access(MemberAccess ma) {
		if(ma.inner != null) {
			ma.inner.accept(this);
			write(".");
		}
		write(ma.member.name);
	}

	public override void visit_method(Method m) {
		if(!m.visible)
			return;
		if(m.binding == Member.Binding.STATIC)
			write("static ");
		m.data_type.accept(this);
		write(" %s(".printf(m.name));
		for(unowned SList<Parameter> node = m.params; node != null; node = node.next) {
			node.data.data_type.accept(this);
			write(" %s".printf(node.data.name));
			if(node.next != null)
				write(",");
		}
		write(");");
	}

	public override void visit_method_call(MethodCall mc) {
		mc.method.accept(this);
		write("(");
		for(unowned SList<Expression> node = mc.args; node != null; node = node.next) {
			node.data.accept(this);
			if(node.next != null)
				write(",");
		}
		write(")");
	}

	public override void visit_namespace(Namespace ns) {
		if(ns != root)
			write("namespace %s {".printf(ns.name));
		foreach(var n in ns.namespaces)
			n.accept(this);
		foreach(var t in ns.types)
			t.accept(this);
		foreach(var m in ns.methods)
			m.accept(this);
		foreach(var f in ns.fields)
			f.accept(this);
		foreach(var e in ns.equations)
			e.accept(this);
		if(ns != root)
			write("}");
	}

	public override void visit_type_access(TypeAccess ta) {
		if(ta.inner != null) {
			ta.inner.accept(this);
			write(".");
		}
		write(ta.type_symbol.name);
	}

	public override void visit_unary_expression(UnaryExpression ue) {
		write(ue.op.to_string());
		ue.expr.accept(this);
	}
}
