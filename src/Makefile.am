# force include config.h before gi18n.h.
AM_CPPFLAGS = -include $(CONFIG_HEADER)

libexec_PROGRAMS = ibus-engine-gucharmap ibus-setup-gucharmap

ibus_engine_gucharmap_VALAFLAGS = \
	--vapidir=$(top_srcdir)/vapi \
	--pkg config --pkg gtk+-3.0 --pkg gucharmap-2.90 --pkg ibus-1.0 \
	--pkg sqlite3 \
	$(VALAFLAGS)

ibus_engine_gucharmap_CFLAGS = \
	$(GUCHARMAP_CFLAGS) $(IBUS_CFLAGS) $(SQLITE_CFLAGS) \
	-DPACKAGE_DATADIR=\"$(pkgdatadir)\" \
	-DLOCALEDIR=\"$(datadir)/locale\" \
	-DUNICODENAMESFILE=\"$(unicodenames)\" \
	-DLIBEXECDIR=\"$(libexecdir)\"
ibus_engine_gucharmap_LDADD = \
	$(GUCHARMAP_LIBS) $(IBUS_LIBS) $(SQLITE_LIBS)

ibus_engine_gucharmap_SOURCES = \
	config-cache.vala \
	charmap-panel.vala \
	search-panel.vala \
	engine.vala \
	engine-main.vala

ibus_setup_gucharmap_VALAFLAGS = \
	--vapidir=$(top_srcdir)/vapi \
	--pkg config --pkg gtk+-3.0 --pkg ibus-1.0 \
	$(VALAFLAGS)

setupdir = $(pkgdatadir)/setup
dist_setup_DATA = ibus-gucharmap-preferences.ui

ibus_setup_gucharmap_CFLAGS = \
	$(GUCHARMAP_CFLAGS) $(IBUS_CFLAGS) $(SQLITE_CFLAGS) \
	-DPACKAGE_DATADIR=\"$(pkgdatadir)\" \
	-DLOCALEDIR=\"$(datadir)/locale\" \
	-DSETUPDIR=\"$(setupdir)\"
ibus_setup_gucharmap_LDADD = \
	$(GUCHARMAP_LIBS) $(IBUS_LIBS) $(SQLITE_LIBS)

ibus_setup_gucharmap_SOURCES = \
	config-cache.vala \
	setup.vala \
	setup-main.vala

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

unicodenames = unicodenames.sqlite3
dist_pkgdata_DATA = $(unicodenames)
unicodenames.sqlite3: | $(top_builddir)/tools/gen-index
	$(AM_V_GEN) $(top_builddir)/tools/gen-index $@

CLEANFILES = *.[ch] *.stamp gucharmap.xml
DISTCLEANFILES = gucharmap.xml.in $(unicodenames)
EXTRA_DIST = gucharmap.xml.in.in
