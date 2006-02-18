# Document  $Id$
# Summary   Makefile for the chemical-mime-data project.
#
# Copyright (C) 2004-2006 by Daniel Leidert.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

EXTRA_DIST = $(fdomime_in_files)

CLEANFILES = $(fdomime_DATA)

MAINTAINERCLEANFILES = Makefile.in

fdomime_in_files = chemical-mime-data.xml.in


if BOOL_FREEDESKTOP_MIME
@INTLTOOL_XML_RULE@

fdomimedir = $(DIR_FDMIME)/packages
fdomime_DATA = $(fdomime_in_files:.xml.in=.xml)
endif #BOOL_FREEDESKTOP_MIME

install-data-hook:
if BOOL_UPDATE_DATABASE
	$(UPDATE_MIME_DATABASE) $(DIR_FDMIME)
endif #BOOL_UPDATE_DATABASE

uninstall-hook:
if BOOL_UPDATE_DATABASE
	$(UPDATE_MIME_DATABASE) $(DIR_FDMIME)
endif #BOOL_UPDATE_DATABASE

