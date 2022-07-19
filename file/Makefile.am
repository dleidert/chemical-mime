# Document  $Id$
# Summary   Makefile for the chemical-mime-data project.
#
# Copyright (C) 2004-2007 by Daniel Leidert <daniel.leidert@wgdd.de>.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

CLEANFILES = $(filemagic_DATA)

MAINTAINERCLEANFILES = Makefile.in


VPATH += $(top_builddir)/src $(top_srcdir)/xsl


XSLTPROC_FLAGS +=  --stringparam file.magic.mode "file"


filemagicdir   = $(pkgdatadir)/file
filemagic_DATA = magic.mime

$(filemagic_DATA): cmd_file-magic.xsl chemical-mime-database.xml
	$(XSLTPROC) $(XSLTPROC_FLAGS) $^

