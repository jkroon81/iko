lib_LTLIBRARIES = libikocas.la

libikocas_la_CFLAGS = \
	@GOBJECT_CFLAGS@ \
	@GI_CFLAGS@ \
	-I$(top_srcdir)/vapi

libikocas_la_LIBADD = \
	@GOBJECT_LIBS@ \
	@GI_LIBS@

libikocas_la_SOURCES = \
	iko-cas-assignment.vala \
	iko-cas-atomic-expression.vala \
	iko-cas-boolean.vala \
	iko-cas-compound-expression.vala \
	iko-cas-error.vala \
	iko-cas-expression.vala \
	iko-cas-for-statement.vala \
	iko-cas-foreach-statement.vala \
	iko-cas-fraction.vala \
	iko-cas-function.vala \
	iko-cas-if-statement.vala \
	iko-cas-integer.vala \
	iko-cas-kind.vala \
	iko-cas-list.vala \
	iko-cas-namespace.vala \
	iko-cas-node.vala \
	iko-cas-parser.vala \
	iko-cas-polish.vala \
	iko-cas-return-statement.vala \
	iko-cas-scanner.vala \
	iko-cas-singletons.vala \
	iko-cas-source-location.vala \
	iko-cas-source-reference.vala \
	iko-cas-statement.vala \
	iko-cas-symbol.vala \
	iko-cas-token-info.vala \
	iko-cas-token-type.vala \
	iko-cas-undefined.vala \
	iko-cas-vala-block.vala \
	iko-cas-visitor.vala \
	iko-cas-while-statement.vala \
	iko-cas-writer.vala

libikocas_la_VALAFLAGS = \
	--header=ikocas.h \
	--library=ikocas \
	--pkg=gi \
	--vapidir=$(top_srcdir)/vapi

CLEANFILES = *~

