/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Scanner : Object {
	char *current;
	char *end;
	int line;
	int column;

	public Scanner(string text) {
		end = (char*)text + text.size();
		current = text;
		line = column = 1;
	}

	void whitespace() {
		while(current < end && current[0].isspace()) {
			if(current[0] == '\n') {
				line++;
				column = 0;
			}
			current++;
			column++;
		}
	}

	public TokenInfo read_token() {
		TokenType token;
		SourceLocation token_begin;
		SourceLocation token_end;
		char *begin;
		int len;

		whitespace();

		begin = current;
		token_begin = new SourceLocation(begin, line, column);

		if(current == end) {
			token = TokenType.EOF;
			current++;
		} else if(current[0].isalpha() || current[0] == '_') {
			len = 0;
			while(current < end && (current[0].isalnum() || current[0] == '_')) {
				current++;
				len++;
			}
			token = TokenType.IDENTIFIER;
		} else if(current[0].isdigit()) {
			while(current < end && current[0].isdigit())
				current++;
			token = TokenType.INTEGER;
			if(current < end && current[0] == '.') {
				current++;
				while(current < end && current[0].isdigit())
					current++;
				token = TokenType.FLOAT;
			}
		} else {
			switch(current[0]) {
			case '^': token = TokenType.CARET;         break;
			case '}': token = TokenType.CLOSE_BRACE;   break;
			case ']': token = TokenType.CLOSE_BRACKET; break;
			case ')': token = TokenType.CLOSE_PARENS;  break;
			case ',': token = TokenType.COMMA;         break;
			case '.': token = TokenType.DOT;           break;
			case '=': token = TokenType.EQ;            break;
			default : token = TokenType.INVALID;       break;
			case '-': token = TokenType.MINUS;         break;
			case '{': token = TokenType.OPEN_BRACE;    break;
			case '[': token = TokenType.OPEN_BRACKET;  break;
			case '(': token = TokenType.OPEN_PARENS;   break;
			case '+': token = TokenType.PLUS;          break;
			case ';': token = TokenType.SEMICOLON;     break;
			case '/': token = TokenType.SLASH;         break;
			case '*': token = TokenType.STAR;          break;
			}
			current++;
		}

		column += (int) (current - begin);
		token_end = new SourceLocation(current, line, column - 1);

		return new TokenInfo(token, token_begin, token_end);
	}
}
