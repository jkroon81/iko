/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public errordomain Iko.ParseError {
  SYNTAX
}

public class Iko.Parser : Object {
  const int TOKEN_BUFFER_SIZE = 16;

  Scanner scanner;
  TokenInfo[] tokens;
  int index;
  int size;

  construct {
    tokens = new TokenInfo[TOKEN_BUFFER_SIZE];
  }

  void next() {
    index = (index + 1) % TOKEN_BUFFER_SIZE;
    size--;
    if(size <= 0) {
      tokens[index] = scanner.read_token();
      size = 1;
    }
  }

  void prev() {
    index = (index - 1 + TOKEN_BUFFER_SIZE) % TOKEN_BUFFER_SIZE;
    size++;
    assert(size <= TOKEN_BUFFER_SIZE);
  }

  TokenType current() {
    return tokens[index].token;
  }

  bool accept(TokenType token) {
    if(current() == token) {
      next();
      return true;
    } else
      return false;
  }

  void expect(TokenType token) throws ParseError {
    if(accept(token))
      return;
    else
      throw new ParseError.SYNTAX("%s:expected '%s' not '%s'".printf(get_src(get_location()).to_string(),
                                                                     token.to_string(),
                                                                     current().to_string()));
  }

  SourceLocation get_location() {
    return tokens[index].begin;
  }

  SourceReference get_src(SourceLocation begin) {
    return new SourceReference(scanner.filename, begin, tokens[index].end);
  }

  string get_prev_string () {
    int prev_index = (index + TOKEN_BUFFER_SIZE - 1) % TOKEN_BUFFER_SIZE;
    return SourceLocation.extract_string(tokens[prev_index]);
  }

  BinaryExpression.Operator get_binary_operator(TokenType token) {
    switch(token) {
    case TokenType.CARET: return BinaryExpression.Operator.POWER;
    case TokenType.MINUS: return BinaryExpression.Operator.MINUS;
    case TokenType.PLUS:  return BinaryExpression.Operator.PLUS;
    case TokenType.SLASH: return BinaryExpression.Operator.DIV;
    case TokenType.STAR:  return BinaryExpression.Operator.MUL;
    default:              return BinaryExpression.Operator.NONE;
    }
  }

  UnaryExpression.Operator get_unary_operator(TokenType token) {
    switch(token) {
    case TokenType.MINUS: return UnaryExpression.Operator.MINUS;
    case TokenType.PLUS:  return UnaryExpression.Operator.PLUS;
    default:              return UnaryExpression.Operator.NONE;
    }
  }

  void rollback(SourceLocation location) {
    while(!tokens[index].begin.matches(location))
      prev();
  }

  Symbol parse_class_declaration() throws ParseError {
    Symbol result = null;
    Namespace parent = null;

    var begin = get_location();
    expect(TokenType.CLASS);
    var id = parse_identifier();
    while(accept(TokenType.DOT)) {
      var ns = new Namespace(get_src(begin), id);
      if(parent != null)
        parent.add_namespace(ns);
      else
        result = ns;
      parent = ns;
      id = parse_identifier();
    }
    var cl = new Class(get_src(begin), id);
    if(parent != null)
      parent.add_type(cl);
    else
      result = cl;
    expect(TokenType.OPEN_BRACE);
    parse_declarations(cl);
    expect(TokenType.CLOSE_BRACE);
    return result;
  }

  void parse_class_member(Class cl) throws ParseError {
    var begin = get_location();
    switch(current()) {
    case TokenType.CLASS:
      var sym = parse_class_declaration();
      if(sym is TypeSymbol)
        cl.add_type(sym as TypeSymbol);
      else
        throw new ParseError.SYNTAX("%s:expected class member".printf(get_src(begin).to_string()));
      break;
    default:
      try {
        var binding = Member.Binding.INSTANCE;
        if(accept(TokenType.STATIC))
          binding = Member.Binding.STATIC;
        var data_type = parse_data_type();
        do {
          var id = parse_identifier();
          var node = parse_member_declaration(begin, binding, data_type, id);
          if(node is Field)
            cl.add_field((Field)node);
          else if(node is Method)
            cl.add_method((Method)node);
          else
            throw new ParseError.SYNTAX("%s:expected class member".printf(get_src(begin).to_string()));
        } while(accept(TokenType.COMMA));
        expect(TokenType.SEMICOLON);
      } catch(ParseError e) {
        rollback(begin);
        cl.equations.prepend(parse_equation());
      }
      break;
    }
  }

  DataType parse_data_type() throws ParseError {
    var begin = get_location();
    DataType data_type = null;

    do {
      var sym = parse_unresolved_type();
      data_type = new TypeAccess(get_src(begin), data_type, sym);
    } while(accept(TokenType.DOT));
    while(accept(TokenType.OPEN_BRACKET)) {
      var length = parse_expression();
      expect(TokenType.CLOSE_BRACKET);
      data_type = new ArrayType(get_src(begin), data_type, length);
    }
    return data_type;
  }

  void parse_declarations(Symbol parent) throws ParseError {
    if(parent is Class) {
      var cl = parent as Class;
      cl.equations.reverse();
      cl.fields.reverse();
      cl.methods.reverse();
      cl.types.reverse();
    } else {
      var ns = parent as Namespace;
      ns.equations.reverse();
      ns.fields.reverse();
      ns.methods.reverse();
      ns.namespaces.reverse();
      ns.types.reverse();
    }
    while(current() != TokenType.CLOSE_BRACE && current() != TokenType.EOF) {
      if(parent is Namespace)
        parse_namespace_member((Namespace)parent);
      else if(parent is Class)
        parse_class_member((Class)parent);
    }
    if(parent is Class) {
      var cl = parent as Class;
      cl.equations.reverse();
      cl.fields.reverse();
      cl.methods.reverse();
      cl.types.reverse();
    } else {
      var ns = parent as Namespace;
      ns.equations.reverse();
      ns.fields.reverse();
      ns.methods.reverse();
      ns.namespaces.reverse();
      ns.types.reverse();
    }
  }

  Equation parse_equation() throws ParseError {
    var begin = get_location();
    var left = parse_expression();
    expect(TokenType.EQ);
    var right = parse_expression();
    expect(TokenType.SEMICOLON);
    return new Equation(get_src(begin), left, right);
  }

  Expression parse_expression() throws ParseError {
    return parse_expression_additive();
  }

  Expression parse_expression_additive() throws ParseError {
    var begin = get_location();
    var left = parse_expression_multiplicative();
    var loop = true;
    while(loop) {
      var op = get_binary_operator(current());
      switch(op) {
      case BinaryExpression.Operator.MINUS:
      case BinaryExpression.Operator.PLUS:
        next();
        var right = parse_expression_multiplicative();
        left = new BinaryExpression(get_src(begin), op, left, right);
        break;
      default:
        loop = false;
        break;
      }
    }
    return left;
  }

  Expression parse_expression_multiplicative() throws ParseError {
    var begin = get_location();
    var left = parse_expression_power();
    var loop = true;
    while(loop) {
      var op = get_binary_operator(current());
      switch(op) {
      case BinaryExpression.Operator.DIV:
      case BinaryExpression.Operator.MUL:
        next();
        var right = parse_expression_power();
        left = new BinaryExpression(get_src(begin), op, left, right);
        break;
      default:
        loop = false;
        break;
      }
    }
    return left;
  }

  Expression parse_expression_parenthesized() throws ParseError {
    expect(TokenType.OPEN_PARENS);
    var expr = parse_expression();
    expect(TokenType.CLOSE_PARENS);
    return expr;
  }

  Expression parse_expression_power() throws ParseError {
    var begin = get_location();
    var left = parse_expression_unary();
    var loop = true;
    while(loop) {
      var op = get_binary_operator(current());
      switch(op) {
      case BinaryExpression.Operator.POWER:
        next();
        var right = parse_expression_unary();
        left = new BinaryExpression(get_src(begin), op, left, right);
        break;
      default:
        loop = false;
        break;
      }
    }
    return left;
  }

  Expression parse_expression_primary() throws ParseError {
    var begin = get_location();
    Expression expr = null;

    switch(current()) {
    case TokenType.FLOAT:       expr = parse_literal_float();            break;
    case TokenType.IDENTIFIER:  expr = parse_member_expression();        break;
    case TokenType.INTEGER:     expr = parse_literal_integer();          break;
    case TokenType.OPEN_PARENS: expr = parse_expression_parenthesized(); break;
    default:
      throw new ParseError.SYNTAX("%s:expected expression".printf(get_src(begin).to_string()));
    }
    return expr;
  }

  Expression parse_expression_unary() throws ParseError {
    var op = get_unary_operator(current());
    if(op != UnaryExpression.Operator.NONE) {
      var begin = get_location();
      next();
      var expr = parse_expression_primary();
      return new UnaryExpression(get_src(begin), op, expr);
    }
    return parse_expression_primary();
  }

  Field parse_field_declaration(SourceLocation begin,
                                Member.Binding binding,
                                DataType       data_type,
                                string         id)
  throws ParseError
  {
    var field = new Field(get_src(begin), binding, data_type, id);
    if(accept(TokenType.OPEN_BRACKET)) {
      do {
        field.params.prepend(parse_member_expression());
      } while(accept(TokenType.COMMA));
      expect(TokenType.CLOSE_BRACKET);
    }
    return field;
  }

  string parse_identifier() throws ParseError {
    expect(TokenType.IDENTIFIER);
    return get_prev_string();
  }

  Literal parse_literal_float() throws ParseError {
    var begin = get_location();
    expect(TokenType.FLOAT);
    var value = get_prev_string();
    return new FloatLiteral(get_src(begin), value);
  }

  Literal parse_literal_integer() throws ParseError {
    var begin = get_location();
    expect(TokenType.INTEGER);
    var value = get_prev_string();
    return new IntegerLiteral(get_src(begin), value);
  }

  Member parse_member_declaration(SourceLocation begin,
                                  Member.Binding binding,
                                  DataType       data_type,
                                  string         id)
  throws ParseError
  {
    switch(current()) {
    case TokenType.OPEN_PARENS:
      return parse_method_declaration(begin, binding, data_type, id);
    case TokenType.COMMA:
    case TokenType.OPEN_BRACKET:
    case TokenType.SEMICOLON:
      return parse_field_declaration(begin, binding, data_type, id);
    default:
      throw new ParseError.SYNTAX("%s:expected member declaration".printf(get_src(begin).to_string()));
    }
  }

  Expression parse_member_expression() throws ParseError {
    var begin = get_location();
    var loop = true;
    Expression inner = null;
    Expression expr = null;

    do {
      switch(current()) {
      case TokenType.DOT:
        next();
        expect(TokenType.IDENTIFIER);
        prev();
        break;
      case TokenType.IDENTIFIER:
        var sym = parse_unresolved_member();
        expr = new MemberAccess(get_src(begin), inner, sym);
        break;
      case TokenType.OPEN_BRACKET:
        next();
        var index = parse_expression();
        expr = new ArrayAccess(get_src(begin), inner, index);
        expect(TokenType.CLOSE_BRACKET);
        break;
      case TokenType.OPEN_PARENS:
        next();
        var method_call = new MethodCall(get_src(begin), inner);
        do {
          method_call.args.prepend(parse_expression());
        } while(accept(TokenType.COMMA));
        method_call.args.reverse();
        expect(TokenType.CLOSE_PARENS);
        expr = method_call;
        break;
      default:
        loop = false;
        break;
      }
      inner = expr;
    } while(loop);
    return expr;
  }

  Method parse_method_declaration(SourceLocation begin,
                                  Member.Binding binding,
                                  DataType       data_type,
                                  string         id)
  throws ParseError
  {
    var method = new Method(get_src(begin), binding, data_type, id);
    expect(TokenType.OPEN_PARENS);
    if(current() != TokenType.CLOSE_PARENS)
      do {
        method.add_parameter(parse_parameter());
      } while(accept(TokenType.COMMA));
      method.params.reverse();
    expect(TokenType.CLOSE_PARENS);
    return method;
  }

  Namespace parse_namespace_declaration() throws ParseError {
    var begin = get_location();
    expect(TokenType.NAMESPACE);
    var id = parse_identifier();
    var ns = new Namespace(get_src(begin), id);
    var result = ns;
    while(accept(TokenType.DOT)) {
      id = parse_identifier();
      var child = new Namespace(get_src(begin), id);
      ns.add_namespace(child);
      ns = child;
    }
    expect(TokenType.OPEN_BRACE);
    parse_declarations(ns);
    expect(TokenType.CLOSE_BRACE);
    return result;
  }

  void parse_namespace_member(Namespace ns) throws ParseError {
    var begin = get_location();
    switch(current()) {
    case TokenType.CLASS:
      var sym = parse_class_declaration();
      if(sym is TypeSymbol)
        ns.add_type(sym as TypeSymbol);
      else if(sym is Namespace)
        ns.add_namespace(sym as Namespace);
      else
        throw new ParseError.SYNTAX("%s:expected namespace member", get_src(begin).to_string());
      break;
    case TokenType.NAMESPACE:
      ns.add_namespace(parse_namespace_declaration());
      break;
    default:
      try {
        var binding = Member.Binding.STATIC;
        var data_type = parse_data_type();
        do {
          var id = parse_identifier();
          var node = parse_member_declaration(begin, binding, data_type, id);
          if(node is Field)
            ns.add_field((Field)node);
          else if(node is Method)
            ns.add_method((Method)node);
          else
            throw new ParseError.SYNTAX("%s:expected namespace member", get_src(begin).to_string());
        } while(accept(TokenType.COMMA));
        expect(TokenType.SEMICOLON);
      } catch(ParseError e) {
        rollback(begin);
        ns.equations.prepend(parse_equation());
      }
      break;
    }
  }

  Parameter parse_parameter() throws ParseError {
    var begin = get_location();
    var data_type = parse_data_type();
    var id = parse_identifier();
    return new Parameter(get_src(begin), data_type, id);
  }

  public void parse_source_file(Context context, string filename) {
    try {
      scanner = new Scanner.from_file(filename);
      index = -1;
      size = 0;
      next();

      try {
        parse_declarations(context.root);
      } catch (ParseError e) {
        Report.error(e.message);
      }
    } catch(FileError e) {
      Report.error("error opening file '%s'".printf(filename));
    }
  }

  public void parse_source_string(Context context, string code) {
    scanner = new Scanner.from_string(code);
    index = -1;
    size = 0;
    next();

    try {
      parse_declarations(context.root);
    } catch (ParseError e) {
      Report.error(e.message);
    }
  }

  UnresolvedMember parse_unresolved_member() throws ParseError {
    var begin = get_location();
    var id = parse_identifier();
    return new UnresolvedMember(get_src(begin), id);
  }

  UnresolvedType parse_unresolved_type() throws ParseError {
    var begin = get_location();
    var id = parse_identifier();
    return new UnresolvedType(get_src(begin), id);
  }
}
