libexec_PROGRAMS = ibus-engine-gucharmap

# force include config.h before gi18n.h.
AM_CPPFLAGS = -include $(CONFIG_HEADER)

ibus_engine_gucharmap_VALAFLAGS = \
	--vapidir=. \
	--pkg config --pkg gtk+-3.0 --pkg gucharmap-2.90 --pkg ibus-1.0 \
	$(VALAFLAGS)

ibus_engine_gucharmap_CFLAGS = \
	$(GUCHARMAP_CFLAGS) $(IBUS_CFLAGS)
ibus_engine_gucharmap_LDADD = \
	$(GUCHARMAP_LIBS) $(IBUS_LIBS)

ibus_engine_gucharmap_SOURCES = \
	charmap-panel.vala \
	engine.vala \
	main.vala

component_DATA = gucharmap.xml
componentdir = $(datadir)/ibus/component

gucharmap.xml: gucharmap.xml.in
	$(AM_V_GEN) \
	( \
		libexecdir=${libexecdir}; \
		pkgdatadir=${pkgdatadir}; \
		s=`cat $<`; \
		eval "echo \"$${s}\""; \
	) > $@

CLEANFILES = *.[ch] gucharmap.xml
DISTCLEANFILES = gucharmap.xml.in
EXTRA_DIST = gucharmap.xml.in.in gucharmap-2.90.vapi config.vapi
