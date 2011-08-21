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

	Expression parse_expression_multiplicative() throws ParseError {
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
				left = new CompoundExpression.from_binary(Kind.POWER, left, right);
			} else
				loop = false;
		}
		return left;
	}

	Expression parse_expression_primary() throws ParseError {
		switch(current()) {
		case TokenType.DOT:
			return parse_numerical();
		case TokenType.IDENTIFIER:
			var s = parse_symbol();
			switch(current()) {
			case TokenType.OPEN_PARENS:
				return parse_function_call(s);
			default:
				return s;
			}
		case TokenType.INTEGER:
			return parse_numerical();
		case TokenType.OPEN_PARENS:
			return parse_expression_parenthesized();
		default:
			throw new ParseError.SYNTAX("expected expression");
		}
	}

	Expression parse_expression_unary() throws ParseError {
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

	Expression parse_function_call(Symbol s) throws ParseError {
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

	string parse_identifier() throws ParseError {
		expect(TokenType.IDENTIFIER);
		return get_prev_string();
	}

	Expression parse_numerical() throws ParseError {
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

	public Expression parse_source_string(string text) throws ParseError {
		scanner = new Scanner(text);
		index = -1;
		size = 0;
		next();
		var e = parse_expression();
		expect(TokenType.EOF);
		return e;
	}

	Symbol parse_symbol() throws ParseError {
		return new Symbol(parse_identifier());
	}
}
