ld-sharedlib := ikoast
ikoast-sources := $(sort $(notdir $(wildcard $(srcdir)/*.vala)))
ikoast-vala-sharedlibs := \
	$(top-builddir)/iko/iko \
	$(top-builddir)/ikocas/ikocas

include $(dir $(lastword $(MAKEFILE_LIST)))../make/build.mk
