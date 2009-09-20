lib_LTLIBRARIES = libikoast.la

CLEANFILES = \
	ikoast.gir \
	ikoast.h \
	ikoast.vapi \
	*~

libikoast_la_SOURCES = \
	iko-ast-additive-expression.vala \
	iko-ast-arithmetic-expression.vala \
	iko-ast-collect-symbols.vala \
	iko-ast-constant.vala \
	iko-ast-data-symbol.vala \
	iko-ast-data-type.vala \
	iko-ast-derivative-method.vala \
	iko-ast-derivative-solver.vala \
	iko-ast-division-expression.vala \
	iko-ast-equality-expression.vala \
	iko-ast-expand-symbols.vala \
	iko-ast-expression-transformer.vala \
	iko-ast-expression.vala \
	iko-ast-float-literal.vala \
	iko-ast-float-type.vala \
	iko-ast-fold-constants.vala \
	iko-ast-generator.vala \
	iko-ast-independent-variable.vala \
	iko-ast-integer-literal.vala \
	iko-ast-level-operators.vala \
	iko-ast-literal.vala \
	iko-ast-method-call.vala \
	iko-ast-method.vala \
	iko-ast-multiplicative-expression.vala \
	iko-ast-negative-expression.vala \
	iko-ast-node.vala \
	iko-ast-power-expression.vala \
	iko-ast-real-type.vala \
	iko-ast-simple-expression.vala \
	iko-ast-simplify-powers.vala \
	iko-ast-simplify-rationals.vala \
	iko-ast-square-root-method.vala \
	iko-ast-state.vala \
	iko-ast-symbol-access.vala \
	iko-ast-symbol.vala \
	iko-ast-system.vala \
	iko-ast-transform-negatives.vala \
	iko-ast-visitor.vala \
	iko-ast-writer.vala

libikoast_la_VALAFLAGS = \
	--library=ikoast \
	--vapidir=$(top_builddir)/gee \
	--vapidir=$(top_builddir)/iko \
	--pkg=gee \
	--pkg=iko \
	-H ikoast.h

libikoast_la_CFLAGS = \
	@GOBJECT_CFLAGS@ \
	-I$(top_srcdir)/gee \
	-I$(top_srcdir)/iko

libikoast_la_LIBADD = \
	$(top_builddir)/gee/libgee.la \
	$(top_builddir)/iko/libiko.la

