/*
 * Iko - Copyright (C) 2008-2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.SourceLocation : Object {
	public char *pos    { private get; construct; }
	public int   line   { private get; construct; }
	public int   column { private get; construct; }

	public SourceLocation(char *pos, int line, int column) {
		Object(pos : pos, line : line, column : column);
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
