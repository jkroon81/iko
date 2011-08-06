lib_LTLIBRARIES = libikoast.la

libikoast_la_CFLAGS = \
	@GOBJECT_CFLAGS@ \
	-I$(top_srcdir)/iko \
	-I$(top_srcdir)/ikocas

libikoast_la_LIBADD = \
	@GOBJECT_LIBS@ \
	$(top_builddir)/iko/libiko.la \
	$(top_builddir)/ikocas/libikocas.la

libikoast_la_SOURCES = \
	iko-ast-constant.vala \
	iko-ast-data-symbol.vala \
	iko-ast-data-type.vala \
	iko-ast-float-type.vala \
	iko-ast-generator.vala \
	iko-ast-node.vala \
	iko-ast-real-type.vala \
	iko-ast-symbol.vala \
	iko-ast-system.vala \
	iko-ast-variable.vala \
	iko-ast-visitor.vala \
	iko-ast-writer.vala

libikoast_la_VALAFLAGS = \
	--header=ikoast.h \
	--library=ikoast \
	--pkg=iko \
	--pkg=ikocas \
	--vapidir=$(top_srcdir)/iko \
	--vapidir=$(top_srcdir)/ikocas

CLEANFILES = *~

