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
    for(int i = 0; i < ae.operands.size; i++) {
      ae.operands[i].accept(this);
      if(i != ae.operands.size - 1)
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
    for(int i = 0; i < mc.args.size; i++) {
      mc.args[i].accept(this);
      if(i != mc.args.size - 1)
        write(",");
    }
    write(")");
  }

  public override void visit_multiplicative_expression(MultiplicativeExpression me) {
    for(int i = 0; i < me.operands.size; i++) {
      if(me.operands[i] is AdditiveExpression)
        write("(");
      me.operands[i].accept(this);
      if(me.operands[i] is AdditiveExpression)
        write(")");
      if(i != me.operands.size - 1)
        write("*");
    }
  }

  public override void visit_power_expression(PowerExpression pe) {
    if(!(pe.bais is SimpleExpression))
      write("(");
    pe.bais.accept(this);
    if(!(pe.bais is SimpleExpression))
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
}
