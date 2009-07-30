bin_PROGRAMS = transformer

CLEANFILES = \
	*~

transformer_SOURCES = \
	transformer.vala

transformer_VALAFLAGS = \
	--vapidir=$(top_builddir)/gee \
	--vapidir=$(top_builddir)/iko \
	--vapidir=$(top_builddir)/ikoast \
	--pkg=gee \
	--pkg=iko \
	--pkg=ikoast \
	-C

transformer_CFLAGS = \
	@GOBJECT_CFLAGS@ \
	-I$(top_srcdir)/gee \
	-I$(top_srcdir)/iko \
	-I$(top_srcdir)/ikoast

transformer_LDADD = \
	$(top_builddir)/gee/libgee.la \
	$(top_builddir)/iko/libiko.la \
	$(top_builddir)/ikoast/libikoast.la

