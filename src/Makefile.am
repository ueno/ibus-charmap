# force include config.h before gi18n.h.
AM_CPPFLAGS = -include $(CONFIG_HEADER)

@INTLTOOL_XML_NOMERGE_RULE@
@GSETTINGS_RULES@
gsettings_schemas_in_files = \
	org.freedesktop.ibus.charmap.gtk.gschema.xml.in \
	org.freedesktop.ibus.engines.charmap.gschema.xml.in
gsettings_SCHEMAS = $(gsettings_schemas_in_files:.gschema.xml.in=.gschema.xml)

lib_LTLIBRARIES = libibuscharmap.la
libexec_PROGRAMS = ibus-ui-charmap-gtk ibus-engine-charmap ibus-setup-charmap

libibuscharmap_la_VALAFLAGS = \
	-H ibuscharmap.h --vapi ibus-charmap.vapi \
	--vapidir=$(top_srcdir)/vapi \
	--pkg gio-2.0 \
	--library ibus-charmap \
	$(VALAFLAGS)

libibuscharmap_la_CFLAGS = \
	$(LIBIBUSCHARMAP_CFLAGS)
libibuscharmap_la_LIBADD = \
	$(LIBIBUSCHARMAP_LIBS)

libibuscharmapincludedir = \
	$(includedir)/ibus-charmap/ibus

libibuscharmapinclude_HEADERS = \
	ibuscharmap.h

libibuscharmap_la_SOURCES = \
	client.vala

ibus_ui_charmap_gtk_VALAFLAGS = \
	--vapidir=$(builddir) --vapidir=$(top_srcdir)/vapi \
	--pkg config --pkg gio-2.0 --pkg gtk+-3.0 --pkg gucharmap-2.90 \
	--pkg sqlite3 --pkg ibus-1.0 --pkg ibus-charmap \
	$(VALAFLAGS)

ibus_ui_charmap_gtk_CFLAGS = \
	$(GUCHARMAP_CFLAGS) $(SQLITE_CFLAGS) $(IBUS_CFLAGS) \
	-DPACKAGE_DATADIR=\"$(pkgdatadir)\" \
	-DLOCALEDIR=\"$(datadir)/locale\" \
	-DUNICODENAMESFILE=\"$(unicodenames)\" \
	-DLIBEXECDIR=\"$(libexecdir)\"
ibus_ui_charmap_gtk_LDADD = \
	$(GUCHARMAP_LIBS) $(SQLITE_LIBS) $(IBUS_LIBS)

ibus_ui_charmap_gtk_SOURCES = \
	selectable.vala \
	charmap-panel.vala \
	search-panel.vala \
	service.vala \
	window-placement.vala \
	service-gtk.vala \
	service-gtk-main.vala

ibus_engine_charmap_VALAFLAGS = \
	--vapidir=$(builddir) --vapidir=$(top_srcdir)/vapi \
	--pkg config --pkg gio-2.0 \
	--pkg ibus-1.0 --pkg ibus-charmap \
	$(VALAFLAGS)

ibus_engine_charmap_CFLAGS = \
	$(IBUS_CFLAGS) \
	-DPACKAGE_DATADIR=\"$(pkgdatadir)\" \
	-DLOCALEDIR=\"$(datadir)/locale\" \
	-DLIBEXECDIR=\"$(libexecdir)\"
ibus_engine_charmap_LDADD = \
	$(IBUS_LIBS) -libuscharmap

ibus_engine_charmap_SOURCES = \
	engine.vala \
	engine-main.vala

ibus_setup_charmap_VALAFLAGS = \
	--vapidir=$(builddir) --vapidir=$(top_srcdir)/vapi \
	--pkg config --pkg gtk+-3.0 --pkg ibus-1.0 --pkg ibus-charmap \
	$(VALAFLAGS)

setupdir = $(pkgdatadir)/setup
dist_setup_DATA = ibus-charmap-preferences.ui

ibus_setup_charmap_CFLAGS = \
	$(GTK_CFLAGS) $(IBUS_CFLAGS) \
	-DPACKAGE_DATADIR=\"$(pkgdatadir)\" \
	-DLOCALEDIR=\"$(datadir)/locale\" \
	-DSETUPDIR=\"$(setupdir)\"
ibus_setup_charmap_LDADD = \
	$(GTK_LIBS) $(IBUS_LIBS)

ibus_setup_charmap_SOURCES = \
	key-capture-dialog.vala \
	setup.vala \
	setup-main.vala

component_DATA = gtkcharmap.xml charmap.xml
componentdir = $(datadir)/ibus/component

# cannot use suffix rules here because of conflict with
# INTLTOOL_XML_NOMERGE_RULE
gtkcharmap.xml: gtkcharmap.xml.in
	$(AM_V_GEN) \
	( \
		libexecdir=${libexecdir}; \
		pkgdatadir=${pkgdatadir}; \
		s=`cat $<`; \
		eval "echo \"$${s}\""; \
	) > $@
charmap.xml: charmap.xml.in
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

# work around for "make dist", so that it does not fail when
# attempting to include *.c
config-cache-dummy.c: config-cache-dummy.vala
	$(VALAC) -c -C \
	--vapidir=$(builddir) \
	--pkg gio-2.0 --pkg gobject-2.0 --pkg ibus-1.0 \
	$(VALAFLAGS) \
	$<

ibus-charmap.deps:
	$(AM_V_GEN) echo gio-2.0 > ibus-charmap.deps

vapi_DATA = ibus-charmap.vapi ibus-charmap.deps
vapidir = $(datadir)/vala/vapi

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = ibus-charmap.pc

CLEANFILES = \
	*.[ch] \
	*.stamp \
	gtkcharmap.xml \
	charmap.xml \
	$(gsettings_SCHEMAS) \
	$(vapi_DATA) \
	$(pkgconfig_DATA)
DISTCLEANFILES = \
	gtkcharmap.xml.in \
	charmap.xml.in \
	$(unicodenames)
EXTRA_DIST = \
	config.vapi \
	gtkcharmap.xml.in \
	charmap.xml.in.in \
	$(gsettings_schemas_in_files)
