/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.Node : Object {
	public bool visible { get; construct; default = true; }

	public SourceReference? src { get; construct; default = null; }

	public virtual void accept(Visitor v) {
		v.visit_node(this);
	}

	public virtual void accept_children(Visitor v) {}
}
