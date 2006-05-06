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

XMLLINT_FLAGS  += --noout --valid


database_in_files = chemical-mime-database.xml.in
database_files    = $(database_in_files:.xml.in=.xml)


all-local: $(database_files)

check-local:
	$(info "Correct any errors before making a distribution.")
if HAVE_XMLLINT
	$(XMLLINT) $(XMLLINT_FLAGS) $(database_files)
else
	$(warning "Cannot check the XML sources because 'xmllint' is missing.")
endif


@INTLTOOL_XML_RULE@

