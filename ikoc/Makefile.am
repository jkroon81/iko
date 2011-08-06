bin_PROGRAMS = ikoc

ikoc_CFLAGS = \
	@GOBJECT_CFLAGS@ \
	-I$(top_srcdir)/iko \
	-I$(top_srcdir)/ikoast \
	-I$(top_srcdir)/ikocas \
	-I$(top_srcdir)/ikovalacode

ikoc_LDADD = \
	@GOBJECT_LIBS@ \
	$(top_builddir)/iko/libiko.la \
	$(top_builddir)/ikoast/libikoast.la \
	$(top_builddir)/ikocas/libikocas.la \
	$(top_builddir)/ikovalacode/libikovalacode.la

ikoc_SOURCES = \
	ikoc.vala

ikoc_VALAFLAGS = \
	--pkg=iko \
	--pkg=ikoast \
	--pkg=ikocas \
	--pkg=ikovalacode \
	--vapidir=$(top_srcdir)/iko \
	--vapidir=$(top_srcdir)/ikoast \
	--vapidir=$(top_srcdir)/ikocas \
	--vapidir=$(top_srcdir)/ikovalacode

CLEANFILES = *~

