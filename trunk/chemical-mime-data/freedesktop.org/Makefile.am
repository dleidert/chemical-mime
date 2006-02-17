# Document  $Id$
# Summary   Makefile for the chemical-mime-data project.
#
# Copyright (C) 2004-2006 by Daniel Leidert.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

EXTRA_DIST = chemical-mime-data.xml.in

CLEANFILES = $(mime_DATA)

MAINTAINERCLEANFILES = Makefile.in


if BOOL_FREEDESKTOP_MIME
mime_in_files = chemical-mime-data.xml.in
@INTLTOOL_XML_RULE@
mimedir = $(DIR_FDMIME)/packages
mime_DATA = $(mime_in_files:.xml.in=.xml)
endif #BOOL_FREEDESKTOP_MIME

install-data-hook:
if BOOL_UPDATE_DATABASE
	$(UPDATE_MIME_DATABASE) $(DIR_FDMIME)
endif #BOOL_UPDATE_DATABASE

uninstall-hook:
if BOOL_UPDATE_DATABASE
	$(UPDATE_MIME_DATABASE) $(DIR_FDMIME)
endif #BOOL_UPDATE_DATABASE

