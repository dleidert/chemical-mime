# Document  $Id$
# Summary   Makefile for the chemical-mime-data project.
#
# Copyright (C) 2007 by Daniel Leidert <daniel.leidert@wgdd.de>.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

EXTRA_DIST = index.html cmd.css

CLEANFILES = chemical-mime-data.html

MAINTAINERCLEANFILES = Makefile.in

VPATH += @top_builddir@/xsl

XSLTPROC_FLAGS += --path "$(VPATH)"


vpath cmd_%.xsl $(top_srcdir)/xsl
vpath chemical-mime-database.xml $(top_builddir)/src


htmldocsdir   = $datadir/doc/$PACKAGE
htmldocs_DATA = index.html chemical-mime-data.html cmd.css


chemical-mime-data.html : cmd_website.xsl chemical-mime-database.xml cmd_common.xsl
	$(XSLTPROC) $(XSLTPROC_FLAGS) $(filter-out $(top_srcdir)/xsl/cmd_common.xsl,$^)


