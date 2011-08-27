/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Parser : Object {
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

	void expect(TokenType token) throws Error {
		if(accept(token))
			return;
		else
			throw new Error.SYNTAX(
				"%s:expected '%s' not '%s'".printf(
					get_src(get_location()).to_string(),
					token.to_string(),
					current().to_string()
				)
			);
	}

	string get_prev_string() {
		int prev_index = (index + TOKEN_BUFFER_SIZE - 1) % TOKEN_BUFFER_SIZE;
		return SourceLocation.extract_string(tokens[prev_index]);
	}

	SourceLocation get_location() {
		return tokens[index].begin;
	}

	SourceReference get_src(SourceLocation begin) {
		return new SourceReference(scanner.source, begin, tokens[index].end);
	}

	Expression parse_array_access(Symbol s) throws Error {
		var aa = new CompoundExpression.from_unary(Kind.ARRAY, s);
		expect(TokenType.OPEN_BRACKET);
		aa.append(parse_expression());
		expect(TokenType.CLOSE_BRACKET);
		return aa;
	}

	public Assignment parse_assignment() throws Error {
		var begin = get_location();
		var symbol = parse_symbol();
		Assignment a;

		switch(current()) {
		case TokenType.EQ:
			next();
			a = new Assignment(symbol, parse_expression());
			break;
		case TokenType.PLUS:
			next();
			expect(TokenType.EQ);
			a = new Assignment(
				symbol,
				new CompoundExpression.from_binary(
					Kind.PLUS,
					symbol,
					parse_expression()
				)
			);
			break;
		default:
			throw new Error.SYNTAX("%s: expected assignment", get_src(begin).to_string());
		}
		expect(TokenType.SEMICOLON);
		return a;
	}

	Expression parse_boolean() throws Error {
		if(accept(TokenType.FALSE))
			return bool_false();
		else if(accept(TokenType.TRUE))
			return bool_true();
		assert_not_reached();
	}

	public Expression parse_expression() throws Error {
		return parse_expression_logical();
	}

	Expression parse_expression_additive() throws Error {
		var left = parse_expression_multiplicative();
		var loop = true;
		while(loop) {
			switch(current()) {
			case TokenType.MINUS:
				next();
				var right = parse_expression_multiplicative();
				left = new CompoundExpression.from_binary(
					Kind.PLUS,
					left,
					new CompoundExpression.from_binary(Kind.MUL, int_neg_one(), right)
				);
				break;
			case TokenType.PLUS:
				next();
				var right = parse_expression_multiplicative();
				left = new CompoundExpression.from_binary(Kind.PLUS, left, right);
				break;
			default:
				loop = false;
				break;
			}
		}
		return left;
	}

	Expression parse_expression_conditional() throws Error {
		var left = parse_expression_additive();
		var loop = true;
		while(loop) {
			switch(current()) {
			case TokenType.EQ:
				next();
				expect(TokenType.EQ);
				var right = parse_expression_additive();
				left = new CompoundExpression.from_binary(Kind.EQ, left, right);
				break;
			case TokenType.GT:
				next();
				if(accept(TokenType.EQ)) {
					var right = parse_expression_additive();
					left = new CompoundExpression.from_binary(Kind.GE, left, right);
				} else {
					var right = parse_expression_additive();
					left = new CompoundExpression.from_binary(Kind.GT, left, right);
				}
				break;
			case TokenType.IS:
				next();
				var right = parse_symbol();
				left = new CompoundExpression.from_binary(Kind.IS, left, right);
				break;
			case TokenType.LT:
				next();
				if(accept(TokenType.EQ)) {
					var right = parse_expression_additive();
					left = new CompoundExpression.from_binary(Kind.LE, left, right);
				} else if(accept(TokenType.GT)) {
					var right = parse_expression_additive();
					left = new CompoundExpression.from_binary(Kind.NE, left, right);
				} else {
					var right = parse_expression_additive();
					left = new CompoundExpression.from_binary(Kind.LT, left, right);
				}
				break;
			default:
				loop = false;
				break;
			}
		}
		return left;
	}

	Expression parse_expression_logical() throws Error {
		var left = parse_expression_conditional();
		var loop = true;
		while(loop) {
			switch(current()) {
			case TokenType.AND:
				next();
				expect(TokenType.AND);
				var right = parse_expression_conditional();
				left = new CompoundExpression.from_binary(Kind.AND, left, right);
				break;
			case TokenType.OR:
				next();
				expect(TokenType.OR);
				var right = parse_expression_conditional();
				left = new CompoundExpression.from_binary(Kind.OR, left, right);
				break;
			default:
				loop = false;
				break;
			}
		}
		return left;
	}

	Expression parse_expression_multiplicative() throws Error {
		var left = parse_expression_power();
		var loop = true;
		while(loop) {
			switch(current()) {
			case TokenType.SLASH:
				next();
				var right = parse_expression_power();
				left = new CompoundExpression.from_binary(
					Kind.MUL,
					left,
					new CompoundExpression.from_binary(Kind.POWER, right, int_neg_one())
				);
				break;
			case TokenType.STAR:
				next();
				var right = parse_expression_power();
				left = new CompoundExpression.from_binary(Kind.MUL, left, right);
				break;
			default:
				loop = false;
				break;
			}
		}
		return left;
	}

	Expression parse_expression_not() throws Error {
		expect(TokenType.NOT);
		return new CompoundExpression.from_unary(Kind.NOT, parse_expression_logical());
	}

	Expression parse_expression_parenthesized() throws Error {
		expect(TokenType.OPEN_PARENS);
		var expr = parse_expression();
		expect(TokenType.CLOSE_PARENS);
		return expr;
	}

	Expression parse_expression_power() throws Error {
		var left = parse_expression_unary();
		var loop = true;
		while(loop) {
			if(accept(TokenType.CARET)) {
				var right = parse_expression_unary();
				left = new CompoundExpression.from_binary(Kind.POWER, left, right);
			} else
				loop = false;
		}
		return left;
	}

	Expression parse_expression_primary() throws Error {
		var begin = get_location();

		switch(current()) {
		case TokenType.DOT:
			return parse_numerical();
		case TokenType.FALSE:
			return parse_boolean();
		case TokenType.IDENTIFIER:
			var s = parse_symbol();
			switch(current()) {
			case TokenType.OPEN_BRACKET:
				return parse_array_access(s);
			case TokenType.OPEN_PARENS:
				return parse_function_call(s);
			default:
				return s;
			}
		case TokenType.INTEGER:
			return parse_numerical();
		case TokenType.NOT:
			return parse_expression_not();
		case TokenType.OPEN_BRACE:
			return parse_set();
		case TokenType.OPEN_BRACKET:
			return parse_list();
		case TokenType.OPEN_PARENS:
			return parse_expression_parenthesized();
		case TokenType.TRUE:
			return parse_boolean();
		default:
			throw new Error.SYNTAX("%s:expected expression", get_src(begin).to_string());
		}
	}

	Expression parse_expression_unary() throws Error {
		if(current() == TokenType.MINUS) {
			next();
			return new CompoundExpression.from_binary(
				Kind.MUL,
				int_neg_one(),
				parse_expression_primary()
			);
		}
		if(current() == TokenType.PLUS)
			next();
		var e = parse_expression_primary();
		if(accept(TokenType.NOT))
			e = new CompoundExpression.from_unary(Kind.FACTORIAL, e);
		return e;
	}

	ForStatement parse_for_statement() throws Error {
		expect(TokenType.FOR);
		expect(TokenType.OPEN_PARENS);
		var k = parse_symbol();
		expect(TokenType.EQ);
		var start = parse_expression();
		expect(TokenType.TO);
		var end = parse_expression();
		expect(TokenType.CLOSE_PARENS);
		var f = new ForStatement(k, start, end);
		if(accept(TokenType.OPEN_BRACE)) {
			while(!accept(TokenType.CLOSE_BRACE))
				f.body.append(parse_statement());
		} else
			f.body.append(parse_statement());
		return f;
	}

	ForEachStatement parse_foreach_statement() throws Error {
		expect(TokenType.FOREACH);
		expect(TokenType.OPEN_PARENS);
		var c = parse_symbol();
		expect(TokenType.IN);
		var p = parse_expression();
		expect(TokenType.CLOSE_PARENS);
		var f = new ForEachStatement(c, p);
		if(accept(TokenType.OPEN_BRACE)) {
			while(!accept(TokenType.CLOSE_BRACE))
				f.body.append(parse_statement());
		} else
			f.body.append(parse_statement());
		return f;
	}

	Function parse_function() throws Error {
		var is_public = false;
		if(accept(TokenType.PUBLIC))
			is_public = true;
		expect(TokenType.FUNCTION);
		var f = new Function(parse_identifier(), is_public);
		expect(TokenType.OPEN_PARENS);
		do {
			if(accept(TokenType.IDENTIFIER))
				f.arg.append(new Symbol(get_prev_string()));
		} while(accept(TokenType.COMMA));
		expect(TokenType.CLOSE_PARENS);
		expect(TokenType.OPEN_BRACE);
		while(!accept(TokenType.CLOSE_BRACE))
			f.body.append(parse_statement());
		return f;
	}

	Expression parse_function_call(Symbol s) throws Error {
		expect(TokenType.OPEN_PARENS);
		var fc = new CompoundExpression.from_unary(Kind.FUNCTION, s);
		if(!accept(TokenType.CLOSE_PARENS)) {
			do {
				fc.append(parse_expression());
			} while(accept(TokenType.COMMA));
			expect(TokenType.CLOSE_PARENS);
		}
		return fc;
	}

	string parse_identifier() throws Error {
		expect(TokenType.IDENTIFIER);
		return get_prev_string();
	}

	public IfStatement parse_if_statement() throws Error {
		expect(TokenType.IF);
		expect(TokenType.OPEN_PARENS);
		var cond = parse_expression();
		expect(TokenType.CLOSE_PARENS);
		var i = new IfStatement(cond);
		if(accept(TokenType.OPEN_BRACE))
			while(!accept(TokenType.CLOSE_BRACE))
				i.body_true.append(parse_statement());
		else
			i.body_true.append(parse_statement());
		if(accept(TokenType.ELSE)) {
			if(accept(TokenType.OPEN_BRACE))
				while(!accept(TokenType.CLOSE_BRACE))
					i.body_false.append(parse_statement());
			else
				i.body_false.append(parse_statement());
		}
		return i;
	}

	Expression parse_list() throws Error {
		expect(TokenType.OPEN_BRACKET);
		var l = new List();
		if(accept(TokenType.CLOSE_BRACKET))
			return l;
		do {
			l.append(parse_expression());
		} while(accept(TokenType.COMMA));
		expect(TokenType.CLOSE_BRACKET);
		return l;
	}

	public Expression parse_numerical() throws Error {
		var integer = "0";
		var fraction = "";

		if(accept(TokenType.INTEGER))
			integer = get_prev_string();
		if(accept(TokenType.DOT)) {
			expect(TokenType.INTEGER);
			fraction = get_prev_string();
		} else
			return new Integer.from_string(integer);

		StringBuilder buffer = new StringBuilder();
		buffer.append(integer);
		buffer.append(fraction);
		var num = int.parse(buffer.str).to_string();
		buffer.truncate(0);
		buffer.append("1");
		for(var i = 0; i < fraction.length; i++)
			buffer.append("0");
		var den = buffer.str;
		return new Fraction(
			new Integer.from_string(num),
			new Integer.from_string(den)
		);
	}

	public ReturnStatement parse_return_statement() throws Error {
		expect(TokenType.RETURN);
		var r = new ReturnStatement(parse_expression());
		expect(TokenType.SEMICOLON);
		return r;
	}

	public Namespace parse_root() throws Error {
		var root = new Namespace("root");
		while(current() != TokenType.EOF)
			root.function.append(parse_function());
		return root;
	}

	Expression parse_set() throws Error {
		expect(TokenType.OPEN_BRACE);
		var s = new CompoundExpression.from_empty(Kind.SET);
		if(accept(TokenType.CLOSE_BRACE))
			return s;
		do {
			s.append(parse_expression());
		} while(accept(TokenType.COMMA));
		expect(TokenType.CLOSE_BRACE);
		return s;
	}

	Statement parse_statement() throws Error {
		switch(current()) {
		case TokenType.FOR:
			return parse_for_statement();
		case TokenType.FOREACH:
			return parse_foreach_statement();
		case TokenType.IF:
			return parse_if_statement();
		case TokenType.RETURN:
			return parse_return_statement();
		case TokenType.VALA:
			return parse_vala_block();
		case TokenType.WHILE:
			return parse_while_statement();
		default:
			return parse_assignment();
		}
	}

	Symbol parse_symbol() throws Error {
		return new Symbol(parse_identifier());
	}

	ValaBlock parse_vala_block() throws Error {
		var begin = get_location();
		expect(TokenType.VALA);
		if(current() != TokenType.OPEN_BRACE)
			throw new Error.SYNTAX(
				"%s:expected Vala block",
				get_src(begin).to_string()
			);
		var vb = new ValaBlock(scanner.parse_block());
		next();
		next();
		return vb;
	}

	WhileStatement parse_while_statement() throws Error {
		expect(TokenType.WHILE);
		expect(TokenType.OPEN_PARENS);
		var cond = parse_expression();
		expect(TokenType.CLOSE_PARENS);
		var w = new WhileStatement(cond);
		if(accept(TokenType.OPEN_BRACE))
			while(!accept(TokenType.CLOSE_BRACE))
				w.body.append(parse_statement());
		else
			w.body.append(parse_statement());
		return w;
	}

	public void set_source_from_file(string filename) throws Error {
		try {
			scanner = new Scanner.from_file(filename);
			index = -1;
			size = 0;
			next();
		} catch(FileError e) {
			throw new Error.IO("error opening file '%s'", filename);
		}
	}

	public void set_source_from_text(string text) {
		scanner = new Scanner.from_string(text);
		index = -1;
		size = 0;
		next();
	}
}
