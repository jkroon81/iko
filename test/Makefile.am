bin_PROGRAMS = \
	ish

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
	test-power

ish_SOURCES = ish.vala
test_addition_SOURCES = test-common.vala test-addition.vala
test_constant_folding_SOURCES = test-common.vala test-constant-folding.vala
test_multiplication_SOURCES = test-common.vala test-multiplication.vala
test_power_SOURCES = test-common.vala test-power.vala

AM_VALAFLAGS = \
	--vapidir=$(top_builddir)/iko \
	--vapidir=$(top_builddir)/ikocas \
	--vapidir=$(top_builddir)/ikoast \
	--pkg=iko \
	--pkg=ikocas \
	--pkg=ikoast

AM_CFLAGS = \
	@GOBJECT_CFLAGS@ \
	-I$(top_srcdir)/iko \
	-I$(top_srcdir)/ikocas \
	-I$(top_srcdir)/ikoast

LDADD = \
	$(top_builddir)/iko/libiko.la \
	$(top_builddir)/ikocas/libikocas.la \
	$(top_builddir)/ikoast/libikoast.la

