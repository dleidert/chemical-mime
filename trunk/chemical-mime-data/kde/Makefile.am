# Document  $Id$
# Summary   Makefile for the chemical-mime-data project.
#
# Copyright (C) 2004-2006 by Daniel Leidert.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

EXTRA_DIST = $(kdemime_in_files)

CLEANFILES = $(kdemime_DATA)

MAINTAINERCLEANFILES = Makefile.in

kdemime_in_files = \
	seq-aa-fasta.desktop.in \
	seq-aa-genpept.desktop.in \
	seq-na-fasta.desktop.in \
	seq-na-genbank.desktop.in \
	x-alchemy.desktop.in \
	x-cache.desktop.in \
	x-cache-csf.desktop.in \
	x-cactvs-ascii.desktop.in \
	x-cactvs-binary.desktop.in \
	x-cactvs-table.desktop.in \
	x-cdx.desktop.in \
	x-cerius.desktop.in \
	x-chem3d.desktop.in \
	x-chemdraw.desktop.in \
	x-cif.desktop.in \
	x-cmdf.desktop.in \
	x-cml.desktop.in \
	x-compass.desktop.in \
	x-crossfire.desktop.in \
	x-csml.desktop.in \
	x-ctx.desktop.in \
	x-cxf.desktop.in \
	x-daylight-smiles.desktop.in \
	x-embl-dl-nucleotide.desktop.in \
	x-fasta.desktop.in \
	x-galactic-spc.desktop.in \
	x-gamess-input.desktop.in \
	x-gaussian-checkpoint.desktop.in \
	x-gaussian-cube.desktop.in \
	x-gaussian-input.desktop.in \
	x-gaussian-log.desktop.in \
	x-gcg8-sequence.desktop.in \
	x-genbank.desktop.in \
	x-hin.desktop.in \
	x-isostart.desktop.in \
	x-jcamp-dx.desktop.in \
	x-kinemage.desktop.in \
	x-macmolecule.desktop.in \
	x-macromodel-input.desktop.in \
	x-mdl-molfile.desktop.in \
	x-mdl-rdfile.desktop.in \
	x-mdl-rxnfile.desktop.in \
	x-mdl-sdfile.desktop.in \
	x-mdl-tgf.desktop.in \
	x-mif.desktop.in \
	x-mmcif.desktop.in \
	x-mol2.desktop.in \
	x-molconn-Z.desktop.in \
	x-mopac-graph.desktop.in \
	x-mopac-input.desktop.in \
	x-mopac-out.desktop.in \
	x-mopac-vib.desktop.in \
	x-ncbi-asn1-ascii.desktop.in \
	x-ncbi-asn1-binary.desktop.in \
	x-ncbi-asn1-spec.desktop.in \
	x-pdb.desktop.in \
	x-rosdal.desktop.in \
	x-swissprot.desktop.in \
	x-vamas-iso14976.desktop.in \
	x-vmd.desktop.in \
	x-xtel.desktop.in \
	x-xyz.desktop.in


if BOOL_KDE_MIME
@INTLTOOL_DESKTOP_RULE@
kdemimedir = $(DIR_KDEMIME)/chemical
kdemime_DATA = $(kdemime_in_files:.desktop.in=.desktop)
endif #BOOL_KDE_MIME

