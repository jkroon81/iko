lib_LTLIBRARIES = libikovalacode.la

CLEANFILES = \
	ikovalacode.h \
	ikovalacode.vapi \
	*~

libikovalacode_la_SOURCES = \
	iko-valacode-writer.vala

libikovalacode_la_VALAFLAGS = \
	--library=ikovalacode \
	--vapidir=$(top_builddir)/iko \
	--vapidir=$(top_builddir)/ikoast \
	--vapidir=$(top_builddir)/ikocas \
	--pkg=iko \
	--pkg=ikoast \
	--pkg=ikocas \
	-H ikovalacode.h

libikovalacode_la_CFLAGS = \
	@GOBJECT_CFLAGS@ \
	-I$(top_srcdir)/iko \
	-I$(top_srcdir)/ikoast \
	-I$(top_srcdir)/ikocas

libikovalacode_la_LIBADD = \
	@GOBJECT_LIBS@ \
	$(top_builddir)/iko/libiko.la \
	$(top_builddir)/ikoast/libikoast.la \
	$(top_builddir)/ikocas/libikocas.la

