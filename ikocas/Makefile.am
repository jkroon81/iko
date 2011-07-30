lib_LTLIBRARIES = libikocas.la

CLEANFILES = \
	ikocas.gir \
	ikocas.h \
	ikocas.vapi \
	*~

libikocas_la_SOURCES = \
	iko-cas-algebraic-expression.vala \
	iko-cas-atomic-expression.vala \
	iko-cas-compound-expression.vala \
	iko-cas-expression.vala \
	iko-cas-function-call.vala \
	iko-cas-integer.vala \
	iko-cas-list.vala \
	iko-cas-node.vala \
	iko-cas-operator.vala \
	iko-cas-parser.vala \
	iko-cas-real.vala \
	iko-cas-scanner.vala \
	iko-cas-source-location.vala \
	iko-cas-symbol.vala \
	iko-cas-token-info.vala \
	iko-cas-token-type.vala \
	iko-cas-visitor.vala \
	iko-cas-writer.vala

libikocas_la_VALAFLAGS = \
	--library=ikocas \
	-H ikocas.h

libikocas_la_CFLAGS = \
	@GOBJECT_CFLAGS@

