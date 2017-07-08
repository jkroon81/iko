ld-bin := ikoc
ikoc-sources := ikoc.vala
ikoc-vala-sharedlibs := \
	$(top-builddir)/iko/iko \
	$(top-builddir)/ikoast/ikoast \
	$(top-builddir)/ikocas/ikocas \
	$(top-builddir)/ikovalacode/ikovalacode
ikoc-ldflags := $(shell pkg-config gobject-introspection-1.0 --libs) -lgmp

include $(dir $(lastword $(MAKEFILE_LIST)))../make/build.mk
