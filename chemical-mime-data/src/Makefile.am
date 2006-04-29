# Document  $Id$
# Summary   Makefile for the chemical-mime-data project.
#
# Copyright (C) 2006 by Daniel Leidert.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

EXTRA_DIST = $(database_in_files)

CLEANFILES = $(database_files)

MAINTAINERCLEANFILES = Makefile.in


database_in_files = chemical-mime-database.xml.in
database_files    = $(database_in_files:.xml.in=.xml)


all-local: $(database_files)

@INTLTOOL_XML_RULE@

