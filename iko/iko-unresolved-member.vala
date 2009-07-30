/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.UnresolvedMember : Member {
  public string id { get; construct; }

  public UnresolvedMember(SourceReference? src, string id) {
    this.src  = src;
    this.id   = id;
    this.name = "<null>";
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_unresolved_member(this);
  }
}
