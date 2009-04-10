/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

using Gee;

public class Iko.AST.Generator : Iko.Visitor {
  Namespace root;
  Queue<string> prefix;
  Expression expr;
  FloatType float_type;
  RealType real_type;

  public System system { private get; construct; }

  public Generator(System system) {
    this.system = system;
    prefix = new Queue<string>();
    float_type = new FloatType();
    real_type = new RealType();
  }

  string expression_to_string(Iko.Expression expr) {
    if(expr is Iko.MemberAccess) {
      var ma = expr as Iko.MemberAccess;
      var buffer = new StringBuilder();

      if(ma.inner != null) {
        buffer.append(expression_to_string(ma.inner) + ".");
        buffer.append(ma.member.name);
      } else {
        buffer.append(ma.member.get_full_name());
        buffer.erase(0, 5);
      }
      return buffer.str;
    } else if(expr is Iko.ArrayAccess) {
      var aa = expr as Iko.ArrayAccess;
      var array = expression_to_string(aa.array);
      var index = (aa.index as Iko.IntegerLiteral).value;
      return array + "[" + index + "]";
    } else
      assert_not_reached();
  }

  void generate_instance(Iko.DataType data_type, string name, ReadOnlyList<Iko.Expression> params) {
    if(data_type is Iko.TypeAccess) {
      prefix.push_tail(name);
      var buffer = new StringBuilder();
      foreach(var n in prefix.head)
        buffer.append(n);
      var type_symbol = (data_type as Iko.TypeAccess).type_symbol;
      if(type_symbol is Iko.RealType) {
        if(params.size > 0) {
          var s = new State(buffer.str, real_type);
          foreach(var p in params)
            s.add_parameter(system.lookup(expression_to_string(p)) as IndependentVariable);
          system.add_state(s);
        } else {
          var iv = new IndependentVariable(buffer.str, real_type);
          system.add_independent_variable(iv);
        }
      } else if(type_symbol is Iko.FloatType)
        system.add_constant(new Constant(buffer.str, float_type));
      if(type_symbol is Class)
        foreach(var f in (type_symbol as Class).get_fields())
          if(f.binding == Iko.Member.Binding.INSTANCE)
            generate_instance(f.data_type, "." + f.name, f.get_parameters());
      prefix.pop_tail();
    } else if(data_type is Iko.Array) {
      var length = ((data_type as Iko.Array).length as Iko.IntegerLiteral).value.to_int();
      for(var i = 0; i < length; i++)
        generate_instance((data_type as Iko.Array).element_type, name + "[" + i.to_string() + "]", params);
    } else
      assert_not_reached();
  }

  Operator get_binary_operator(Iko.BinaryExpression.Operator op) {
    switch(op) {
    case Iko.BinaryExpression.Operator.MINUS: return Operator.MINUS;
    case Iko.BinaryExpression.Operator.PLUS:  return Operator.PLUS;
    case Iko.BinaryExpression.Operator.POWER: return Operator.POWER;
    case Iko.BinaryExpression.Operator.DIV:   return Operator.DIV;
    case Iko.BinaryExpression.Operator.MUL:   return Operator.MUL;
    default:                                  return Operator.NONE;
    }
  }

  Operator get_unary_operator(Iko.UnaryExpression.Operator op) {
    switch(op) {
    case Iko.UnaryExpression.Operator.MINUS: return Operator.MINUS;
    case Iko.UnaryExpression.Operator.PLUS:  return Operator.PLUS;
    default:                                 return Operator.NONE;
    }
  }

  public override void visit_array_access(ArrayAccess aa) {
    expr = new SymbolAccess(system.lookup(expression_to_string(aa)));
  }

  public override void visit_binary_expression(Iko.BinaryExpression be) {
    be.left.accept(this);
    var left = expr;
    be.right.accept(this);
    var right = expr;
    expr = new BinaryExpression(get_binary_operator(be.op), left, right);
  }

  public override void visit_block(Block b) {
    b.accept_children(this);
  }

  public override void visit_class(Class c) {
    if(!c.visible)
      return;
    prefix.push_tail(c.name + ".");
    foreach(var t in c.get_types())
      t.accept(this);
    foreach(var f in c.get_fields())
      f.accept(this);
    foreach(var m in c.get_methods())
      m.accept(this);
    if(c.get_model() != null)
      c.get_model().accept(this);
    prefix.pop_tail();
  }

  public override void visit_context(Context c) {
    root = c.root;
    c.accept_children(this);
    root = null;
  }

  public override void visit_equation(Iko.Equation eq) {
    eq.left.accept(this);
    var left = expr;
    eq.right.accept(this);
    var right = expr;
    system.add_equation(new BinaryExpression(Operator.EQUAL, left, right));
  }

  public override void visit_field(Field f) {
    if(f.binding == Iko.Member.Binding.STATIC)
      generate_instance(f.data_type, f.name, f.get_parameters());
  }

  public override void visit_float_literal(Iko.FloatLiteral fl) {
    expr = new FloatLiteral(fl.value);
  }

  public override void visit_integer_literal(Iko.IntegerLiteral il) {
    expr = new IntegerLiteral(il.value);
  }

  public override void visit_member_access(MemberAccess ma) {
    expr = new SymbolAccess(system.lookup(expression_to_string(ma)));
  }

  public override void visit_method_call(Iko.MethodCall mc) {
    mc.method.accept(this);
    var expr_tmp = new MethodCall(expr);
    foreach(var a in mc.get_arguments()) {
      a.accept(this);
      expr_tmp.add_argument(expr);
    }
    expr = expr_tmp;
  }

  public override void visit_model(Model m) {
    m.accept_children(this);
  }

  public override void visit_namespace(Namespace ns) {
    if(ns != root)
      prefix.push_tail(ns.name + ".");
    foreach(var sub_ns in ns.get_namespaces())
      sub_ns.accept(this);
    foreach(var t in ns.get_types())
      t.accept(this);
    foreach(var f in ns.get_fields())
      f.accept(this);
    foreach(var m in ns.get_methods())
      m.accept(this);
    if(ns.get_model() != null)
      ns.get_model().accept(this);
    if(ns != root)
      prefix.pop_tail();
  }

  public override void visit_unary_expression(Iko.UnaryExpression ue) {
    ue.expr.accept(this);
    expr = new UnaryExpression(get_unary_operator(ue.op), expr);
  }
}
