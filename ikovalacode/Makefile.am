lib_LTLIBRARIES = libikovalacode.la

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

libikovalacode_la_SOURCES = \
	iko-valacode-writer.vala

libikovalacode_la_VALAFLAGS = \
	--header=ikovalacode.h \
	--library=ikovalacode \
	--pkg=iko \
	--pkg=ikoast \
	--pkg=ikocas \
	--vapidir=$(top_srcdir)/iko \
	--vapidir=$(top_srcdir)/ikoast \
	--vapidir=$(top_srcdir)/ikocas

CLEANFILES = *~

