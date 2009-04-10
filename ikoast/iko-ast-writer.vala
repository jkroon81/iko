/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.Writer : Visitor {
  bool newline;
  int  indent;

  public unowned FileStream file { get; set; default = stdout; }

  public int indent_size { private get; set; default = 2; }

  construct {
    newline = true;
    indent  = 0;
  }

  public bool needs_paranthesis(Operator op, Expression e) {
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

    if(op == Operator.DIV)
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
    if(be.op == Operator.EQUAL)
      write(";");
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
    var args = mc.get_arguments();
    foreach(var a in args) {
      a.accept(this);
      if(a != args[args.size - 1])
        write(",");
    }
    write(")");
  }

  public override void visit_multi_expression(MultiExpression me) {
    var op_list = me.get_operands();
    foreach(var op in op_list) {
      var protect = needs_paranthesis(me.op, op);
      if(protect)
        write("(");
      op.accept(this);
      if(protect)
        write(")");
      if(op != op_list[op_list.size - 1])
        write(me.op.to_string());
    }
    if(me.op == Operator.EQUAL)
      write(";");
  }

  public override void visit_state(State s) {
    write(s.name);
    write(" {");
    write("derivative {");
    foreach(var p in s.get_parameters()) {
      var expr = s.get_derivative(p);
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
    var constants = s.get_constants();
    if(constants.size > 0) {
      write("constant {");
      foreach(var c in constants)
        c.accept(this);
      write("}");
    }
    var ivars = s.get_independent_variables();
    if(ivars.size > 0) {
      write("independent variable {");
      foreach(var iv in ivars)
        iv.accept(this);
      write("}");
    }
    var states = s.get_states();
    if(states.size > 0) {
      write("state {");
      foreach(var st in states)
        st.accept(this);
      write("}");
    }
    var methods = s.get_methods();
    if(methods.size > 0) {
      write("methods {");
      foreach(var m in methods)
        m.accept(this);
      write("}");
    }
    var equations = s.get_equations();
    if(equations.size > 0) {
      write("equation {");
      foreach(var eq in equations)
        eq.accept(this);
      write("}");
    }
    write("}");
  }

  public override void visit_unary_expression(UnaryExpression ue) {
    write(ue.op.to_string());
    ue.expr.accept(this);
  }
}
