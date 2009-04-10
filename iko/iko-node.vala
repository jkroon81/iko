/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.Node : Object {
  public bool visible { get; construct; default = true; }

  public SourceReference? src { get; construct; }

  public virtual void accept(Visitor v) {}
  public virtual void accept_children(Visitor v) {}
}
