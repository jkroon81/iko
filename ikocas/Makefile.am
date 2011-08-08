lib_LTLIBRARIES = libikocas.la

libikocas_la_CFLAGS = \
	@GOBJECT_CFLAGS@ \
	@GI_CFLAGS@ \
	-I$(top_srcdir)/vapi

libikocas_la_LIBADD = \
	@GOBJECT_LIBS@ \
	@GI_LIBS@

libikocas_la_SOURCES = \
	iko-cas-atomic-expression.vala \
	iko-cas-compound-expression.vala \
	iko-cas-equality.vala \
	iko-cas-expression.vala \
	iko-cas-factorial.vala \
	iko-cas-fraction.vala \
	iko-cas-function-call.vala \
	iko-cas-integer.vala \
	iko-cas-list.vala \
	iko-cas-node.vala \
	iko-cas-parser.vala \
	iko-cas-polish.vala \
	iko-cas-power.vala \
	iko-cas-product.vala \
	iko-cas-scanner.vala \
	iko-cas-singletons.vala \
	iko-cas-source-location.vala \
	iko-cas-sum.vala \
	iko-cas-symbol.vala \
	iko-cas-token-info.vala \
	iko-cas-token-type.vala \
	iko-cas-undefined.vala \
	iko-cas-visitor.vala \
	iko-cas-writer.vala

libikocas_la_VALAFLAGS = \
	--header=ikocas.h \
	--library=ikocas \
	--pkg=gi \
	--vapidir=$(top_srcdir)/vapi

CLEANFILES = *~

