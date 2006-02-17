# Document  $Id$
# Summary   Makefile for the chemical-mime-data project.
#
# Copyright (C) 2004-2006 by Daniel Leidert.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

EXTRA_DIST = chemical-mime-data.keys.in chemical-mime-data.mime

CLEANFILES = chemical-mime-data.keys

MAINTAINERCLEANFILES = Makefile.in


if BOOL_GNOME_MIME
keys_in_files = chemical-mime-data.keys.in
@INTLTOOL_KEYS_RULE@
keysdir = $(DIR_GNOMEMIME)
keys_DATA = $(keys_in_files:.keys.in=.keys) chemical-mime-data.mime
endif #BOOL_GNOME_MIME

