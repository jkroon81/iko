/*
 * Iko - Copyright (C) 2009-2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.SourceLocation : Object {
	public int   line   { get; construct; }
	public int   column { get; construct; }
	public char *pos    { get; construct; }
	public char *src    { get; construct; }

	public SourceLocation(int line, int column, char *pos, char *src) {
		Object(
			line : line,
			column : column,
			pos : pos,
			src : src
		);
	}

	public bool matches(SourceLocation location) {
		return (location.pos == pos);
	}

	public static string extract_string(TokenInfo token) {
		var size = token.end.pos - token.begin.pos;
		assert(size > 0);
		return ((string)token.begin.pos).substring(0, (long)size);
	}

	public string to_string() {
		return "%d.%d".printf(line, column);
	}
}
