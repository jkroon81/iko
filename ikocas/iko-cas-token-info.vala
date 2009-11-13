/*
 * Iko - Copyright (C) 2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.TokenInfo : Object {
	public TokenType      token { get; construct; }
	public SourceLocation begin { get; construct; }
	public SourceLocation end   { get; construct; }

	public TokenInfo(TokenType token, SourceLocation begin, SourceLocation end) {
		Object(token : token, begin : begin, end : end);
	}
}
