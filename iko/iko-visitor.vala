/*
 * Iko - Copyright (C) 2008-2009 Jacob Kroon
 *
 * Contributor(s):
 *   Jacob Kroon <jacob.kroon@gmail.com>
 */

public abstract class Iko.Visitor : Object {
	public virtual void visit_array_access(ArrayAccess access) {}
	public virtual void visit_array_type(ArrayType type) {}
	public virtual void visit_binary_expression(BinaryExpression expr) {}
	public virtual void visit_class(Class klass) {}
	public virtual void visit_context(Context context) {}
	public virtual void visit_data_symbol(DataSymbol symbol) {}
	public virtual void visit_data_type(DataType data_type) {}
	public virtual void visit_derivative_method(DerivativeMethod der) {}
	public virtual void visit_equation(Equation eq) {}
	public virtual void visit_expression(Expression expr) {}
	public virtual void visit_field(Field field) {}
	public virtual void visit_float_literal(FloatLiteral literal) {}
	public virtual void visit_float_type(FloatType type) {}
	public virtual void visit_integer_literal(IntegerLiteral literal) {}
	public virtual void visit_integer_type(IntegerType type) {}
	public virtual void visit_literal(Literal literal) {}
	public virtual void visit_member(Member member) {}
	public virtual void visit_member_access(MemberAccess member) {}
	public virtual void visit_method(Method method) {}
	public virtual void visit_method_call(MethodCall method) {}
	public virtual void visit_namespace(Namespace nspace) {}
	public virtual void visit_node(Node n) {}
	public virtual void visit_parameter(Parameter param) {}
	public virtual void visit_real_type(RealType type) {}
	public virtual void visit_square_root_method(SquareRootMethod sqrt) {}
	public virtual void visit_symbol(Symbol symbol) {}
	public virtual void visit_type_access(TypeAccess type) {}
	public virtual void visit_type_symbol(TypeSymbol type) {}
	public virtual void visit_unary_expression(UnaryExpression expr) {}
	public virtual void visit_unresolved_member(UnresolvedMember member) {}
	public virtual void visit_unresolved_type(UnresolvedType type_symbol) {}
}
