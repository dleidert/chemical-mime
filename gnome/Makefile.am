# Document  $Id$
# Summary   Makefile for the chemical-mime-data project.
#
# Copyright (C) 2004-2007 by Daniel Leidert <daniel.leidert@wgdd.de>.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

CLEANFILES = $(gnomemime_DATA)

MAINTAINERCLEANFILES = Makefile.in

VPATH += $(top_builddir)/src $(top_srcdir)/xsl 


if BOOL_GNOME_MIME
gnomemimedir   = $(with_gnome_mime)
gnomemime_DATA = chemical-mime-data.keys chemical-mime-data.mime
endif #BOOL_GNOME_MIME


chemical-mime-data.keys : cmd_gnome-keys.xsl chemical-mime-database.xml
	$(XSLTPROC) $(XSLTPROC_FLAGS) $^

chemical-mime-data.mime : cmd_gnome-mime.xsl chemical-mime-database.xml
	$(XSLTPROC) $(XSLTPROC_FLAGS) $^

