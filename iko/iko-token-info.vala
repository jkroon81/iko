/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.TokenInfo : Object {
	public TokenType      token { get; construct; }
	public SourceLocation begin { get; construct; }
	public SourceLocation end   { get; construct; }

	public TokenInfo(TokenType token, SourceLocation begin, SourceLocation end) {
		this.token = token;
		this.begin = begin;
		this.end   = end;
	}
}
