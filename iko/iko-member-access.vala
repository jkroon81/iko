/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public class Iko.MemberAccess : Expression {
  public Expression? inner  { get; construct; }
  public Member      member { get; set construct; }

  public override DataType data_type { get { return member.data_type; } }

  public MemberAccess(SourceReference? src, Expression? inner, Member member) {
    this.src    = src;
    this.inner  = inner;
    this.member = member;
  }

  public override void accept(Visitor v) {
    base.accept(v);
    v.visit_member_access(this);
  }
}
