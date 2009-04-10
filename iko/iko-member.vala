/*
 * Iko - Copyright (C) 2008 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.Member : DataSymbol {
  public enum Binding {
    INSTANCE,
    STATIC
  }

  public Binding binding { get; construct; }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_member(this);
  }
}
