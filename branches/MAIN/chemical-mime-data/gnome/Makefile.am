
EXTRA_DIST = \
	chemical-mime-data.keys.in \
	chemical-mime-data.mime

if BOOL_GNOME_MIME
keys_in_files = chemical-mime-data.keys.in
@INTLTOOL_KEYS_RULE@

keysdir = $(DIR_GNOMEMIME)
keys_DATA = $(keys_in_files:.keys.in=.keys) chemical-mime-data.mime
endif

CLEANFILES = chemical-mime-data.keys

MAINTAINERCLEANFILES = Makefile.in

