libexec_PROGRAMS = ibus-engine-gucharmap
noinst_PROGRAMS = gen-index

# force include config.h before gi18n.h.
AM_CPPFLAGS = -include $(CONFIG_HEADER)

ibus_engine_gucharmap_VALAFLAGS = \
	--vapidir=. \
	--pkg config --pkg gtk+-3.0 --pkg gucharmap-2.90 --pkg ibus-1.0 \
	--pkg sqlite3 \
	$(VALAFLAGS)

ibus_engine_gucharmap_CFLAGS = \
	$(GUCHARMAP_CFLAGS) $(IBUS_CFLAGS) $(SQLITE_CFLAGS) \
	-DPACKAGE_DATADIR=\"$(pkgdatadir)\"
ibus_engine_gucharmap_LDADD = \
	$(GUCHARMAP_LIBS) $(IBUS_LIBS) $(SQLITE_LIBS)

ibus_engine_gucharmap_SOURCES = \
	charmap-panel.vala \
	search-panel.vala \
	engine.vala \
	main.vala

gen_index_VALAFLAGS = \
	--vapidir=. \
	--pkg config --pkg gtk+-3.0 --pkg gucharmap-2.90 --pkg sqlite3 \
	$(VALAFLAGS)

gen_index_CFLAGS = \
	$(GUCHARMAP_CFLAGS) $(SQLITE_CFLAGS)
gen_index_LDADD = \
	$(GUCHARMAP_LIBS) $(SQLITE_LIBS)

gen_index_SOURCES = \
	gen-index.vala

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

pkgdata_DATA = unicodenames.sqlite3
unicodenames.sqlite3: gen-index
	$(AM_V_GEN) $(builddir)/gen-index $@

CLEANFILES = *.[ch] gucharmap.xml
DISTCLEANFILES = gucharmap.xml.in
EXTRA_DIST = gucharmap.xml.in.in gucharmap-2.90.vapi config.vapi
