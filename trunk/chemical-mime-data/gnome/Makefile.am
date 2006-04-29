# Document  $Id$
# Summary   Makefile for the chemical-mime-data project.
#
# Copyright (C) 2004-2006 by Daniel Leidert.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

CLEANFILES = $(gnomemime_DATA)

MAINTAINERCLEANFILES = Makefile.in

vpath cmd_%.xsl $(top_srcdir)/xsl
vpath chemical-mime-database.xml $(top_srcdir)/src


if BOOL_GNOME_MIME
gnomemimedir = $(DIR_GNOMEMIME)
gnomemime_DATA = chemical-mime-data.keys chemical-mime-data.mime
endif #BOOL_GNOME_MIME


chemical-mime-data.keys : cmd_gnome-keys.xsl chemical-mime-database.xml
	$(XSLTPROC)  $^

chemical-mime-data.mime : cmd_gnome-mime.xsl chemical-mime-database.xml
	$(XSLTPROC)  $^
