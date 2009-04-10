/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.Writer : Visitor {
  Namespace root;
  bool      newline;
  int       indent;

  public unowned FileStream file { get; set; default = stdout; }

  public int indent_size { private get; set; default = 2; }

  construct {
    newline = true;
    indent  = 0;
  }

  void write(string str) {
    char *c = (char*) str;

    while(*c != 0) {
      switch(*c) {
      case '{':
        file.printf("{\n");
        newline = true;
        indent += indent_size;
        break;
      case '}':
        indent -= indent_size;
        file.printf("%s}\n", string.nfill(indent, ' '));
        newline = true;
        break;
      case ';':
        file.printf(";\n");
        newline = true;
        break;
      default:
        if(newline)
          file.printf("%s", string.nfill(indent, ' '));
        file.printf("%c", *c);
        newline = false;
        break;
      }
      c++;
    }
  }

  public override void visit_array(Array a) {
    a.element_type.accept(this);
    write("[");
    a.length.accept(this);
    write("]");
  }

  public override void visit_array_access(ArrayAccess aa) {
    aa.array.accept(this);
    write("[");
    aa.index.accept(this);
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

  public override void visit_block(Block b) {
    write("{");
    b.accept_children(this);
    write("}");
  }

  public override void visit_class(Class c) {
    if(!c.visible)
      return;
    write("class %s {".printf(c.name));
    foreach(var t in c.get_types())
      t.accept(this);
    foreach(var f in c.get_fields())
      f.accept(this);
    if(c.get_model() != null)
      c.get_model().accept(this);
    foreach(var m in c.get_methods())
      m.accept(this);
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
    var params = f.get_parameters();
    if(params.size > 0) {
      write("[");
      foreach(var p in params) {
        p.accept(this);
        if(p != params[params.size - 1])
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
    var params = m.get_parameters();
    foreach(var p in params) {
      p.data_type.accept(this);
      write(" %s".printf(p.name));
      if(p != params[params.size - 1])
        write(",");
    }
    write(");");
  }

  public override void visit_method_call(MethodCall mc) {
    mc.method.accept(this);
    write("(");
    var args = mc.get_arguments();
    foreach(var a in args) {
      a.accept(this);
      if(a != args[args.size - 1])
        write(",");
    }
    write(")");
  }

  public override void visit_model(Model m) {
    write("model ");
    m.accept_children(this);
  }

  public override void visit_namespace(Namespace ns) {
    if(ns != root)
      write("namespace %s {".printf(ns.name));
    foreach(var n in ns.get_namespaces())
      n.accept(this);
    foreach(var t in ns.get_types())
      t.accept(this);
    foreach(var m in ns.get_methods())
      m.accept(this);
    foreach(var f in ns.get_fields())
      f.accept(this);
    if(ns.get_model() != null)
      ns.get_model().accept(this);
    if(ns != root)
      write("}");
  }

  public override void visit_source_file(SourceFile sf) {
    sf.accept_children(this);
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
