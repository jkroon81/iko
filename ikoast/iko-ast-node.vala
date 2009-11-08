/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.AST.Node : Object {
	public virtual void accept(Visitor v) {}
	public virtual void accept_children(Visitor v) {}
}
