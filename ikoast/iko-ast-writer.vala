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

  public override void visit_additive_expression(AdditiveExpression ae) {
    for(unowned SList<Expression> node = ae.operands; node != null; node = node.next) {
      node.data.accept(this);
      if(node.next != null && !(node.next.data is NegativeExpression))
        write("+");
    }
  }

  public override void visit_constant(Constant c) {
    write(c.name);
    write(";");
  }

  public override void visit_division_expression(DivisionExpression de) {
    if(de.num is AdditiveExpression)
      write("(");
    de.num.accept(this);
    if(de.num is AdditiveExpression)
      write(")");
    write("/");
    if(de.den is AdditiveExpression ||
       de.den is MultiplicativeExpression ||
       de.den is DivisionExpression)
      write("(");
    de.den.accept(this);
    if(de.den is AdditiveExpression ||
       de.den is MultiplicativeExpression ||
       de.den is DivisionExpression)
      write(")");
  }

  public override void visit_equality_expression(EqualityExpression ee) {
    ee.left.accept(this);
    write("=");
    ee.right.accept(this);
  }

  public override void visit_independent_variable(IndependentVariable iv) {
    write(iv.name);
    write(";");
  }

  public override void visit_literal(Literal l) {
    write(l.value);
  }

  public override void visit_matrix_expression(MatrixExpression me) {
    var m = me.matrix;
    write("[");
    for(int i = 0; i < m.n_rows; i++) {
      for(int j = 0; j < m.n_columns; j++) {
        m.get(i, j).accept(this);
        if(j != m.n_columns - 1)
          write(",");
      }
      if(i != m.n_rows - 1)
        write(":");
    }
    write("]");
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
    for(unowned SList<Expression> node = mc.args; node != null; node = node.next) {
      node.data.accept(this);
      if(node.next != null)
        write(",");
    }
    write(")");
  }

  public override void visit_multiplicative_expression(MultiplicativeExpression me) {
    for(unowned SList<Expression> node = me.operands; node != null; node = node.next) {
      if(node.data is AdditiveExpression)
        write("(");
      node.data.accept(this);
      if(node.data is AdditiveExpression)
        write(")");
      if(node.next != null)
        write("*");
    }
  }

  public override void visit_negative_expression(NegativeExpression ne) {
    write("-");
    if(ne.expr is AdditiveExpression)
      write("(");
    ne.expr.accept(this);
    if(ne.expr is AdditiveExpression)
      write(")");
  }

  public override void visit_power_expression(PowerExpression pe) {
    if(!(pe.radix is SimpleExpression))
      write("(");
    pe.radix.accept(this);
    if(!(pe.radix is SimpleExpression))
      write(")");
    write("^");
    if(!(pe.exp is SimpleExpression))
      write("(");
    pe.exp.accept(this);
    if(!(pe.exp is SimpleExpression))
      write(")");
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
    if(s.constants.length() > 0) {
      write("constant {");
      foreach(var c in s.constants)
        c.accept(this);
      write("}");
    }
    if(s.ivars.length() > 0) {
      write("independent variable {");
      foreach(var iv in s.ivars)
        iv.accept(this);
      write("}");
    }
    if(s.states.length() > 0) {
      write("state {");
      foreach(var st in s.states)
        st.accept(this);
      write("}");
    }
    if(s.methods.length() > 0) {
      write("methods {");
      foreach(var m in s.methods)
        m.accept(this);
      write("}");
    }
    if(s.equations.length() > 0) {
      write("equation {");
      foreach(var eq in s.equations) {
        eq.accept(this);
        write(";");
      }
      write("}");
    }
    write("}");
  }
}
