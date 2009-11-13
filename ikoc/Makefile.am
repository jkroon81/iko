bin_PROGRAMS = ikoc

CLEANFILES = \
	*~

ikoc_SOURCES = \
	ikoc.vala

ikoc_VALAFLAGS = \
	--vapidir=$(top_builddir)/iko \
	--vapidir=$(top_builddir)/ikocas \
	--vapidir=$(top_builddir)/ikoast \
	--vapidir=$(top_builddir)/ikovalacode \
	--pkg=iko \
	--pkg=ikocas \
	--pkg=ikoast \
	--pkg=ikovalacode

ikoc_CFLAGS = \
	@GOBJECT_CFLAGS@ \
	-I$(top_srcdir)/iko \
	-I$(top_srcdir)/ikocas \
	-I$(top_srcdir)/ikoast \
	-I$(top_srcdir)/ikovalacode

ikoc_LDADD = \
	$(top_builddir)/iko/libiko.la \
	$(top_builddir)/ikocas/libikocas.la \
	$(top_builddir)/ikoast/libikoast.la \
	$(top_builddir)/ikovalacode/libikovalacode.la

