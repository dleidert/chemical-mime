# Document  $Id$
# Summary   Makefile for the chemical-mime-data project.
#
# Copyright (C) 2007 by Daniel Leidert <daniel.leidert@wgdd.de>.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

CLEANFILES = $(mimetypes_DATA)

MAINTAINERCLEANFILES = Makefile.in

VPATH += $(top_builddir)/src $(top_srcdir)/xsl 


mimetypesdir   = $(pkgdatadir)
mimetypes_DATA = mime.types


$(mimetypes_DATA) : cmd_mime_types.xsl chemical-mime-database.xml
	$(XSLTPROC) $(XSLTPROC_FLAGS) $^

