/*
 * Iko - Copyright (C) 2011 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.CAS.SourceReference : Object {
	public string         filename { private get; construct; }
	public SourceLocation begin    { private get; construct; }
	public SourceLocation end      { private get; construct; }

	public SourceReference(string filename, SourceLocation begin, SourceLocation end) {
		Object(filename : filename, begin : begin, end : end);
	}

	public string to_string() {
		return "%s:%s-%s".printf(filename, begin.to_string(), end.to_string());
	}
}
