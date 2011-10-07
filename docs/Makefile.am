include $(top_srcdir)/gtk-doc.make

DOC_MODULE = ibus-charmap
DOC_MAIN_SGML_FILE = ibus-charmap-docs.xml
DOC_SOURCE_DIR = $(top_srcdir)/src
MKDB_OPTIONS = --output-format=xml

INCLUDES = $(LIBIBUSCHARMAP_CFLAGS)
GTKDOC_LIBS = $(LIBIBUSCHARMAP_LIBS) -L$(top_builddir)/src -libuscharmap -Wl,-rpath=$(top_builddir)/src

# IGNORE_HFILES = 
