/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.AST.Generator : Iko.Visitor {
  Namespace root;
  Queue<string> prefix;
  Queue<Expression> q;
  FloatType float_type;
  RealType real_type;

  public System system { private get; construct; }

  public Generator(System system) {
    this.system = system;
    prefix = new Queue<string>();
    q = new Queue<Expression>();
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

  Expression generate_expression(Iko.Expression e) {
    e.accept(this);
    return q.pop_head();
  }

  void generate_instance(Iko.DataType data_type, string name, SList<Iko.Expression> params) {
    if(data_type is Iko.TypeAccess) {
      prefix.push_tail(name);
      var buffer = new StringBuilder();
      foreach(var n in prefix.head)
        buffer.append(n);
      var type_symbol = (data_type as Iko.TypeAccess).type_symbol;
      if(type_symbol is Iko.RealType) {
        if(params != null) {
          var s = new State(buffer.str, real_type);
          foreach(var p in params)
            s.params.prepend(system.map.lookup(expression_to_string(p)) as IndependentVariable);
          s.params.reverse();
          system.add_state(s);
        } else {
          var iv = new IndependentVariable(buffer.str, real_type);
          system.add_independent_variable(iv);
        }
      } else if(type_symbol is Iko.FloatType)
        system.add_constant(new Constant(buffer.str, float_type));
      if(type_symbol is Class)
        foreach(var f in (type_symbol as Class).fields)
          if(f.binding == Iko.Member.Binding.INSTANCE)
            generate_instance(f.data_type, "." + f.name, f.params);
      prefix.pop_tail();
    } else if(data_type is Iko.ArrayType) {
      var length = ((data_type as Iko.ArrayType).length as Iko.IntegerLiteral).value.to_int();
      for(var i = 0; i < length; i++)
        generate_instance((data_type as Iko.ArrayType).element_type,
                          name + "[" + i.to_string() + "]",
                          params);
    } else
      assert_not_reached();
  }

  public override void visit_array_access(ArrayAccess aa) {
    q.push_head(new SymbolAccess(system.map.lookup(expression_to_string(aa))));
  }

  public override void visit_binary_expression(Iko.BinaryExpression be) {
    switch(be.op) {
    case Iko.BinaryExpression.Operator.DIV:
      q.push_head(new DivisionExpression(generate_expression(be.left),
                                         generate_expression(be.right)));
      break;
    case Iko.BinaryExpression.Operator.MINUS:
      q.push_head(
        new AdditiveExpression.binary(
          generate_expression(be.left),
          new NegativeExpression(generate_expression(be.right))
        )
      );
      break;
    case Iko.BinaryExpression.Operator.MUL:
      q.push_head(new MultiplicativeExpression.binary(generate_expression(be.left),
                                                      generate_expression(be.right)));
      break;
    case Iko.BinaryExpression.Operator.PLUS:
      q.push_head(new AdditiveExpression.binary(generate_expression(be.left),
                                                generate_expression(be.right)));
      break;
    case Iko.BinaryExpression.Operator.POWER:
      q.push_head(new PowerExpression(generate_expression(be.left),
                                      generate_expression(be.right)));
      break;
    default:
      assert_not_reached();
    }
  }

  public override void visit_block(Block b) {
    b.accept_children(this);
  }

  public override void visit_class(Class c) {
    if(!c.visible)
      return;
    prefix.push_tail(c.name + ".");
    foreach(var t in c.types)
      t.accept(this);
    foreach(var f in c.fields)
      f.accept(this);
    foreach(var m in c.methods)
      m.accept(this);
    if(c.model != null)
      c.model.accept(this);
    prefix.pop_tail();
  }

  public override void visit_context(Context c) {
    root = c.root;
    c.accept_children(this);
    system.constants.reverse();
    system.equations.reverse();
    system.ivars.reverse();
    system.methods.reverse();
    system.states.reverse();
    root = null;
  }

  public override void visit_equation(Iko.Equation eq) {
    system.add_equation(new EqualityExpression(generate_expression(eq.left),
                                               generate_expression(eq.right)));
  }

  public override void visit_field(Field f) {
    if(f.binding == Iko.Member.Binding.STATIC)
      generate_instance(f.data_type, f.name, f.params);
  }

  public override void visit_float_literal(Iko.FloatLiteral fl) {
    q.push_head(new FloatLiteral(fl.value));
  }

  public override void visit_integer_literal(Iko.IntegerLiteral il) {
    q.push_head(new IntegerLiteral(il.value));
  }

  public override void visit_member_access(MemberAccess ma) {
    q.push_head(new SymbolAccess(system.map.lookup(expression_to_string(ma))));
  }

  public override void visit_method_call(Iko.MethodCall mc) {
    var expr = new MethodCall(generate_expression(mc.method));
    foreach(var a in mc.args)
      expr.args.prepend(generate_expression(a));
    expr.args.reverse();
    q.push_head(expr);
  }

  public override void visit_model(Model m) {
    m.accept_children(this);
  }

  public override void visit_namespace(Namespace ns) {
    if(ns != root)
      prefix.push_tail(ns.name + ".");
    foreach(var sub_ns in ns.namespaces)
      sub_ns.accept(this);
    foreach(var t in ns.types)
      t.accept(this);
    foreach(var f in ns.fields)
      f.accept(this);
    foreach(var m in ns.methods)
      m.accept(this);
    if(ns.model != null)
      ns.model.accept(this);
    if(ns != root)
      prefix.pop_tail();
  }

  public override void visit_unary_expression(Iko.UnaryExpression ue) {
    switch(ue.op) {
    case Iko.UnaryExpression.Operator.MINUS:
      q.push_head(new NegativeExpression(generate_expression(ue.expr)));
      break;
    case Iko.UnaryExpression.Operator.PLUS:
      q.push_head(generate_expression(ue.expr));
      break;
    default:
      assert_not_reached();
    }
  }
}
