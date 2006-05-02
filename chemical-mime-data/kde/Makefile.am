# Document  $Id$
# Summary   Makefile for the chemical-mime-data project.
#
# Copyright (C) 2004-2006 by Daniel Leidert.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

CLEANFILES = $(kdemime_DATA)

MAINTAINERCLEANFILES = Makefile.in

vpath cmd_%.xsl $(top_srcdir)/xsl
vpath chemical-mime-database.xml $(top_builddir)/src


if BOOL_KDE_MIME
kdemimedir = $(DIR_KDEMIME)/chemical
kdemime_DATA = *.desktop
endif #BOOL_KDE_MIME


*.desktop : cmd_kde.xsl chemical-mime-database.xml
	$(XSLTPROC) $^

