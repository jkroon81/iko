bin_PROGRAMS = \
	transformer

check_PROGRAMS = \
	test-addition \
	test-constant-folding \
	test-multiplication \
	test-power

CLEANFILES = \
	*~

TESTS = \
	test-addition \
	test-constant-folding \
	test-multiplication \
	test-power

XFAIL_TESTS = \
	test-addition \
	test-multiplication \
	test-power

test_addition_SOURCES = test-common.vala test-addition.vala
test_constant_folding_SOURCES = test-common.vala test-constant-folding.vala
test_multiplication_SOURCES = test-common.vala test-multiplication.vala
test_power_SOURCES = test-common.vala test-power.vala
transformer_SOURCES = transformer.vala

AM_VALAFLAGS = \
	--vapidir=$(top_builddir)/gee \
	--vapidir=$(top_builddir)/iko \
	--vapidir=$(top_builddir)/ikoast \
	--pkg=gee \
	--pkg=iko \
	--pkg=ikoast

AM_CFLAGS = \
	@GOBJECT_CFLAGS@ \
	-I$(top_srcdir)/gee \
	-I$(top_srcdir)/iko \
	-I$(top_srcdir)/ikoast

LDADD = \
	$(top_builddir)/gee/libgee.la \
	$(top_builddir)/iko/libiko.la \
	$(top_builddir)/ikoast/libikoast.la
