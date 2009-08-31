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

  bool needs_paranthesis(Operator op, Expression e) {
    Operator op_child = Operator.NONE;

    if(e is SimpleExpression)
      return false;
    else if(e is BinaryExpression)
      op_child = (e as BinaryExpression).op;
    else if(e is MultiExpression)
      op_child = (e as MultiExpression).op;
    else if(e is UnaryExpression)
      op_child = (e as UnaryExpression).op;
    else
      assert_not_reached();

    if(op == Operator.MINUS && op_child == Operator.PLUS)
      return true;
    if(op_child.priority() < op.priority())
      return true;
    return false;
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

  public override void visit_binary_expression(BinaryExpression be) {
    var protect = needs_paranthesis(be.op, be.left);
    if(protect)
      write("(");
    be.left.accept(this);
    if(protect)
      write(")");
    write(be.op.to_string());
    protect = needs_paranthesis(be.op, be.right);
    if(protect)
      write("(");
    be.right.accept(this);
    if(protect)
      write(")");
  }

  public override void visit_constant(Constant c) {
    write(c.name);
    write(";");
  }

  public override void visit_independent_variable(IndependentVariable iv) {
    write(iv.name);
    write(";");
  }

  public override void visit_literal(Literal l) {
    write(l.value);
  }

  public override void visit_method(Method m) {
    write(m.data_type.name);
    write(" ");
    write(m.name);
    write("();");
  }

  public override void visit_method_call(MethodCall mc) {
    mc.method.accept(this);
    write("(");
    foreach(var a in mc.args) {
      a.accept(this);
      if(a != mc.args[mc.args.size - 1])
        write(",");
    }
    write(")");
  }

  public override void visit_multi_expression(MultiExpression me) {
    for(int i = 0; i < me.operands.size; i++) {
      var op = me.operands[i];
      var protect = needs_paranthesis(me.op, op);
      if(protect)
        write("(");
      op.accept(this);
      if(protect)
        write(")");
      if(i != me.operands.size - 1)
        write(me.op.to_string());
    }
  }

  public override void visit_state(State s) {
    write(s.name);
    write(" {");
    write("derivative {");
    foreach(var p in s.params) {
      var expr = s.der.lookup(p);
      write(p.name);
      write(" = ");
      if(expr != null)
        expr.accept(this);
      else
        write("(null)");
      write(";");
    }
    write("}");
    write("}");
  }

  public override void visit_symbol_access(SymbolAccess sa) {
    write(sa.symbol.name);
  }

  public override void visit_system(System s) {
    write("system {");
    if(s.constants.size > 0) {
      write("constant {");
      foreach(var c in s.constants)
        c.accept(this);
      write("}");
    }
    if(s.ivars.size > 0) {
      write("independent variable {");
      foreach(var iv in s.ivars)
        iv.accept(this);
      write("}");
    }
    if(s.states.size > 0) {
      write("state {");
      foreach(var st in s.states)
        st.accept(this);
      write("}");
    }
    if(s.methods.size > 0) {
      write("methods {");
      foreach(var m in s.methods)
        m.accept(this);
      write("}");
    }
    if(s.equations.size > 0) {
      write("equation {");
      foreach(var eq in s.equations) {
        eq.accept(this);
        write(";");
      }
      write("}");
    }
    write("}");
  }

  public override void visit_unary_expression(UnaryExpression ue) {
    write(ue.op.to_string());
    ue.expr.accept(this);
  }
}
