bin_PROGRAMS = \
	transformer

check_PROGRAMS = \
	test-algebra

CLEANFILES = \
	*~

EXTRA_DIST = \
	algebra.i \
	simplify.i

TESTS = \
	test-algebra

test_algebra_SOURCES = test-algebra.vala
transformer_SOURCES = transformer.vala

VALAFLAGS = \
	--vapidir=$(top_builddir)/gee \
	--vapidir=$(top_builddir)/iko \
	--vapidir=$(top_builddir)/ikoast \
	--pkg=gee \
	--pkg=iko \
	--pkg=ikoast \
	-C

CFLAGS = \
	@GOBJECT_CFLAGS@ \
	-I$(top_srcdir)/gee \
	-I$(top_srcdir)/iko \
	-I$(top_srcdir)/ikoast

LDADD = \
	$(top_builddir)/gee/libgee.la \
	$(top_builddir)/iko/libiko.la \
	$(top_builddir)/ikoast/libikoast.la

