# Document  $Id$
# Summary   Makefile for the chemical-mime-data project.
#
# Copyright (C) 2004-2007 by Daniel Leidert.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

CLEANFILES = $(freedesktopmime_DATA)

MAINTAINERCLEANFILES = Makefile.in


vpath cmd_%.xsl $(top_srcdir)/xsl
vpath chemical-mime-database.xml $(top_builddir)/src


if BOOL_FREEDESKTOP_MIME
freedesktopmimedir   = $(with_freedesktop_mime)/packages
freedesktopmime_DATA = chemical-mime-data.xml
endif #BOOL_FREEDESKTOP_MIME


chemical-mime-data.xml : cmd_freedesktop_org.xsl chemical-mime-database.xml cmd_common.xsl
	$(XSLTPROC) $(XSLTPROC_FLAGS) $(filter-out $(top_srcdir)/xsl/cmd_common.xsl,$^)


install-data-hook:
if BOOL_UPDATE_DATABASE
	$(UPDATE_MIME_DATABASE) $(DESTDIR)$(with_freedesktop_mime)
endif #BOOL_UPDATE_DATABASE

uninstall-hook:
if BOOL_UPDATE_DATABASE
	$(UPDATE_MIME_DATABASE) $(DESTDIR)$(with_freedesktop_mime)
endif #BOOL_UPDATE_DATABASE

