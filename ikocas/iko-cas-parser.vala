/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public errordomain Iko.CAS.ParseError {
	SYNTAX
}

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

	void expect(TokenType token) throws ParseError {
		if(accept(token))
			return;
		else
			throw new ParseError.SYNTAX(
				"expected '%s' not '%s'".printf(
					token.to_string(),
					current().to_string()
				)
			);
	}

	string get_prev_string() {
		int prev_index = (index + TOKEN_BUFFER_SIZE - 1) % TOKEN_BUFFER_SIZE;
		return SourceLocation.extract_string(tokens[prev_index]);
	}

	Expression parse_expression() throws ParseError {
		return parse_expression_additive();
	}

	Expression parse_expression_additive() throws ParseError {
		var left = parse_expression_multiplicative();
		var loop = true;
		while(loop) {
			switch(current()) {
			case TokenType.MINUS:
				next();
				var right = parse_expression_multiplicative();
				left = new AlgebraicExpression.from_binary(
					Operator.PLUS,
					left,
					new AlgebraicExpression.from_binary(
						Operator.MUL,
						new Integer("-1"),
						right
					)
				);
				break;
			case TokenType.PLUS:
				next();
				var right = parse_expression_multiplicative();
				left = new AlgebraicExpression.from_binary(Operator.PLUS, left, right);
				break;
			default:
				loop = false;
				break;
			}
		}
		return left;
	}

	Expression parse_expression_multiplicative() throws ParseError {
		var left = parse_expression_power();
		var loop = true;
		while(loop) {
			switch(current()) {
			case TokenType.SLASH:
				next();
				var right = parse_expression_power();
				left = new AlgebraicExpression.from_binary(Operator.DIV, left, right);
				break;
			case TokenType.STAR:
				next();
				var right = parse_expression_power();
				left = new AlgebraicExpression.from_binary(Operator.MUL, left, right);
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
		var left = parse_expression_unary();
		var loop = true;
		while(loop) {
			if(accept(TokenType.CARET)) {
				var right = parse_expression_unary();
				left = new AlgebraicExpression.from_binary(Operator.POWER, left, right);
			} else
				loop = false;
		}
		return left;
	}

	Expression parse_expression_primary() throws ParseError {
		Expression expr = null;

		switch(current()) {
		case TokenType.FLOAT:       expr = parse_literal_float();            break;
		case TokenType.IDENTIFIER:  expr = parse_symbol();                   break;
		case TokenType.INTEGER:     expr = parse_literal_integer();          break;
		case TokenType.OPEN_PARENS: expr = parse_expression_parenthesized(); break;
		default:
			throw new ParseError.SYNTAX("expected expression");
		}
		return expr;
	}

	Expression parse_expression_unary() throws ParseError {
		if(current() == TokenType.MINUS) {
			next();
			return new AlgebraicExpression.from_binary(
				Operator.MUL,
				new Integer("-1"),
				parse_expression_primary()
			);
		}
		if(current() == TokenType.PLUS)
			next();
		return parse_expression_primary();
	}

	FunctionCall parse_function_call(string name) throws ParseError {
		expect(TokenType.OPEN_PARENS);
		var mc = new FunctionCall(name);
		do {
			mc.list.append(parse_expression());
		} while(accept(TokenType.COMMA));
		expect(TokenType.CLOSE_PARENS);
		return mc;
	}

	Real parse_literal_float() throws ParseError {
		expect(TokenType.FLOAT);
		var value = get_prev_string();
		return new Real(value);
	}

	Integer parse_literal_integer() throws ParseError {
		expect(TokenType.INTEGER);
		var value = get_prev_string();
		return new Integer(value);
	}

	public Expression? parse_source_string(string text) {
		scanner = new Scanner(text);
		index = -1;
		size = 0;
		next();
		try {
			return parse_expression();
		} catch(ParseError e) {
			return null;
		}
	}

	Expression parse_symbol() throws ParseError {
		expect(TokenType.IDENTIFIER);
		var name = get_prev_string();
		switch(current()) {
		case TokenType.OPEN_PARENS:
			return parse_function_call(name);
		default:
			return new Iko.CAS.Symbol(name);
		}
	}
}
