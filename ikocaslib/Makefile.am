lib_LTLIBRARIES = libikocaslib.la

CLEANFILES = \
	ikocaslib-1.0.gir \
	ikocaslib-1.0.typelib \
	ikocaslib.h \
	ikocaslib.vapi \
	*~

libikocaslib_la_SOURCES = \
	iko-cas-lib-integer.vala

libikocaslib_la_VALAFLAGS = \
	--library=ikocaslib \
	--vapidir=$(top_builddir)/ikocas \
	--pkg=ikocas \
	--gir=ikocaslib-1.0.gir \
	-H ikocaslib.h

libikocaslib_la_CFLAGS = \
	@GOBJECT_CFLAGS@ \
	-I$(top_builddir)/ikocas

libikocaslib_la_LIBADD = \
	@GOBJECT_LIBS@ \
	$(top_builddir)/ikocas/libikocas.la

girdir = $(datadir)/gir-1.0
gir_DATA = ikocaslib-1.0.gir

typelibdir = $(libdir)/girepository-1.0
typelib_DATA = ikocaslib-1.0.typelib

ikocaslib-1.0.typelib : ikocaslib-1.0.gir
	g-ir-compiler $< -o $@

