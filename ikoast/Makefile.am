lib_LTLIBRARIES = libikoast.la

CLEANFILES = \
	ikoast.gir \
	ikoast.h \
	ikoast.vapi \
	*~

libikoast_la_SOURCES = \
	iko-ast-constant.vala \
	iko-ast-data-symbol.vala \
	iko-ast-data-type.vala \
	iko-ast-float-type.vala \
	iko-ast-generator.vala \
	iko-ast-independent-variable.vala \
	iko-ast-node.vala \
	iko-ast-real-type.vala \
	iko-ast-state.vala \
	iko-ast-symbol.vala \
	iko-ast-system.vala \
	iko-ast-visitor.vala \
	iko-ast-writer.vala

libikoast_la_VALAFLAGS = \
	--library=ikoast \
	--vapidir=$(top_builddir)/iko \
	--vapidir=$(top_builddir)/ikocas \
	--pkg=iko \
	--pkg=ikocas \
	-H ikoast.h

libikoast_la_CFLAGS = \
	@GOBJECT_CFLAGS@ \
	-I$(top_srcdir)/iko \
	-I$(top_srcdir)/ikocas

libikoast_la_LIBADD = \
	$(top_builddir)/iko/libiko.la \
	$(top_builddir)/ikocas/libikocas.la

