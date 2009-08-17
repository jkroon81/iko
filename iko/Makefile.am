lib_LTLIBRARIES = libiko.la

CLEANFILES = \
	iko.gir \
	iko.h \
	iko.vapi \
	*~

libiko_la_SOURCES = \
	iko-array-access.vala \
	iko-array-type.vala \
	iko-binary-expression.vala \
	iko-block.vala \
	iko-class.vala \
	iko-context.vala \
	iko-data-symbol.vala \
	iko-data-type.vala \
	iko-derivative-method.vala \
	iko-equation.vala \
	iko-expression.vala \
	iko-field.vala \
	iko-float-literal.vala \
	iko-float-type.vala \
	iko-integer-literal.vala \
	iko-integer-type.vala \
	iko-literal.vala \
	iko-member.vala \
	iko-member-access.vala \
	iko-member-resolver.vala \
	iko-method.vala \
	iko-method-call.vala \
	iko-model.vala \
	iko-namespace.vala \
	iko-node.vala \
	iko-parameter.vala \
	iko-parser.vala \
	iko-real-type.vala \
	iko-report.vala \
	iko-scanner.vala \
	iko-scope.vala \
	iko-source-location.vala \
	iko-source-reference.vala \
	iko-square-root-method.vala \
	iko-statement.vala \
	iko-symbol.vala \
	iko-token-info.vala \
	iko-token-type.vala \
	iko-type-access.vala \
	iko-type-resolver.vala \
	iko-type-symbol.vala \
	iko-unary-expression.vala \
	iko-unresolved-member.vala \
	iko-unresolved-type.vala \
	iko-visitor.vala \
	iko-writer.vala

libiko_la_VALAFLAGS = \
	--library=iko \
	--vapidir=$(top_srcdir)/gee \
	--pkg=gee \
	-C -H iko.h

libiko_la_CFLAGS = \
	@GOBJECT_CFLAGS@ \
	-I$(top_srcdir)/gee

libiko_la_LIBADD = \
	@GOBJECT_LIBS@ \
	$(top_builddir)/gee/libgee.la

