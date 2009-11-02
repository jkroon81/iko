/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.UnresolvedMember : Member {
	public UnresolvedMember(SourceReference? src, string name) {
		Object(src : src, name : name);
	}

	public override void accept(Visitor v) {
		base.accept(v);
		v.visit_unresolved_member(this);
	}
}
