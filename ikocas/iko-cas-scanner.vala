/*
 * Iko - Copyright (C) 2009-2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.Scanner : Object {
	char *current_line;
	char *current;
	char *end;
	int line;
	int column;
	string str;
	MappedFile mapped_file;

	public string? source { get; construct; }

	public Scanner.from_file(string filename) throws FileError {
		Object(source : filename);

		mapped_file = new MappedFile(filename, false);
		var begin = mapped_file.get_contents();
		end = begin + mapped_file.get_length();
		current_line = current = begin;
		line = column = 1;
	}

	public Scanner.from_string(string text) {
		Object(source : null);

		str = text.dup();
		end = (char*)str + str.length;
		current_line = current = str;
		line = column = 1;
	}

	bool matches(char *begin, string keyword) {
		long len = keyword.length;

		for(int i = 0; i < len; i++)
			if(begin[i] != ((char*)keyword)[i])
				return false;
		return true;
	}

	TokenType get_identifier_or_keyword(char *begin, int len) {
		switch(len) {
		case 2:
			if(matches(begin, "if")) return TokenType.IF;
			if(matches(begin, "in")) return TokenType.IN;
			if(matches(begin, "is")) return TokenType.IS;
			if(matches(begin, "to")) return TokenType.TO;
			break;
		case 3:
			if(matches(begin, "for")) return TokenType.FOR;
			break;
		case 4:
			if(matches(begin, "else")) return TokenType.ELSE;
			if(matches(begin, "true")) return TokenType.TRUE;
			if(matches(begin, "vala")) return TokenType.VALA;
			break;
		case 5:
			if(matches(begin, "false")) return TokenType.FALSE;
			if(matches(begin, "while")) return TokenType.WHILE;
			break;
		case 6:
			if(matches(begin, "public")) return TokenType.PUBLIC;
			if(matches(begin, "return")) return TokenType.RETURN;
			break;
		case 7:
			if(matches(begin, "foreach")) return TokenType.FOREACH;
			break;
		case 8:
			if(matches(begin, "function")) return TokenType.FUNCTION;
			break;
		}
		return TokenType.IDENTIFIER;
	}

	void whitespace() {
		while(current < end && current[0].isspace()) {
			if(current[0] == '\n') {
				line++;
				column = 0;
				current_line = current + 1;
			}
			current++;
			column++;
		}
	}

	public string parse_block() {
		var buffer = new StringBuilder();
		var depth = 1;

		while(current != end) {
			switch(current[0]) {
			case '{':
				depth++;
				break;
			case '}':
				depth--;
				if(depth == 0)
					return buffer.str;
				break;
			case '\n':
				line++;
				current_line = current + 1;
				column = 0;
				break;
			}
			buffer.append_c(current[0]);
			current++;
			column++;
		}
		return buffer.str;
	}

	public TokenInfo read_token() {
		TokenType token;
		SourceLocation token_begin;
		SourceLocation token_end;
		char *begin;
		int len;

		whitespace();

		begin = current;
		token_begin = new SourceLocation(line, column, begin, current_line);

		if(current == end) {
			token = TokenType.EOF;
			current++;
		} else if(current[0].isalpha() || current[0] == '_') {
			len = 0;
			while(current < end && (current[0].isalnum() || current[0] == '_')) {
				current++;
				len++;
			}
			token = get_identifier_or_keyword(current - len, len);
		} else if(current[0].isdigit()) {
			while(current < end && current[0].isdigit())
				current++;
			token = TokenType.INTEGER;
		} else {
			switch(current[0]) {
			case '&': token = TokenType.AND;           break;
			case '^': token = TokenType.CARET;         break;
			case '}': token = TokenType.CLOSE_BRACE;   break;
			case ']': token = TokenType.CLOSE_BRACKET; break;
			case ')': token = TokenType.CLOSE_PARENS;  break;
			case ',': token = TokenType.COMMA;         break;
			case '.': token = TokenType.DOT;           break;
			case '=': token = TokenType.EQ;            break;
			case '>': token = TokenType.GT;            break;
			default : token = TokenType.INVALID;       break;
			case '<': token = TokenType.LT;            break;
			case '-': token = TokenType.MINUS;         break;
			case '!': token = TokenType.NOT;           break;
			case '{': token = TokenType.OPEN_BRACE;    break;
			case '[': token = TokenType.OPEN_BRACKET;  break;
			case '(': token = TokenType.OPEN_PARENS;   break;
			case '|': token = TokenType.OR;            break;
			case '+': token = TokenType.PLUS;          break;
			case ';': token = TokenType.SEMICOLON;     break;
			case '/': token = TokenType.SLASH;         break;
			case '*': token = TokenType.STAR;          break;
			}
			current++;
		}

		column += (int) (current - begin);
		token_end = new SourceLocation(line, column - 1, current, current_line);

		return new TokenInfo(token, token_begin, token_end);
	}
}
