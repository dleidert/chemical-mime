
UPDATE_MIME_DATABASE = @UPDATE_MIME_DATABASE@

EXTRA_DIST = chemical-mime-data.xml.in

if BOOL_FREEDESKTOP_MIME
mime_in_files = chemical-mime-data.xml.in
@INTLTOOL_XML_RULE@

mimedir = $(DIR_FDMIME)/packages
mime_DATA = $(mime_in_files:.xml.in=.xml)
endif

install-data-hook:
if BOOL_UPDATE_DATABASE
	$(UPDATE_MIME_DATABASE) $(DIR_FDMIME)
endif

uninstall-hook:
if BOOL_UPDATE_DATABASE
	$(UPDATE_MIME_DATABASE) $(DIR_FDMIME)
endif

CLEANFILES = $(mime_DATA)

MAINTAINERCLEANFILES = Makefile.in

