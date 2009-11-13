lib_LTLIBRARIES = libikocas.la

CLEANFILES = \
	ikocas.gir \
	ikocas.h \
	ikocas.vapi \
	*~

libikocas_la_SOURCES = \
	iko-cas-atomic-expression.vala \
	iko-cas-compound-expression.vala \
	iko-cas-expression.vala \
	iko-cas-integer.vala \
	iko-cas-list.vala \
	iko-cas-operator.vala \
	iko-cas-output.vala \
	iko-cas-parser.vala \
	iko-cas-real.vala \
	iko-cas-scanner.vala \
	iko-cas-source-location.vala \
	iko-cas-symbol.vala \
	iko-cas-token-info.vala \
	iko-cas-token-type.vala \
	iko-cas.vala

libikocas_la_VALAFLAGS = \
	--library=ikocas \
	-H ikocas.h

libikocas_la_CFLAGS = \
	@GOBJECT_CFLAGS@

