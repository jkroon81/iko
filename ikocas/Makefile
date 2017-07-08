ld-sharedlib := ikocas
ikocas-sources := $(notdir $(wildcard $(srcdir)/*.vala))
ikocas-ldflags := $(shell pkg-config gobject-introspection-1.0 --libs) -lgmp
ikocas-valaflags := \
	--pkg=gi \
	--pkg=gmp \
	--vapidir=$(top-srcdir)/vapi
ikocas-ccflags := \
	$(shell pkg-config gobject-introspection-1.0 --cflags) \
	-I$(top-srcdir)/vapi

include $(dir $(lastword $(MAKEFILE_LIST)))../make/build.mk
