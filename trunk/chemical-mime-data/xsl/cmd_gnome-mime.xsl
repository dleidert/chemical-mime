<?xml version="1.0" encoding="UTF-8"?>

<!--
  Document  $Id$
  Summary   XSLT stylesheet to convert XML database into GNOME
            .mime file.
  
  Copyright (C) 2006,2007 Daniel Leidert <daniel.leidert@wgdd.de>.

  This file is free software. The copyright owner gives unlimited
  permission to copy, distribute and modify it.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cm="http://chemical-mime.sourceforge.net/chemical-mime"
                xmlns:fdo="http://www.freedesktop.org/standards/shared-mime-info"
                version="1.0">

<!-- ********************************************************************* -->
<!-- * Import XSL stylesheets. Define output options.                      -->
<!-- ********************************************************************* -->

<xsl:import href="cmd_common.xsl"/>
<xsl:output method="text"
            encoding="UTF-8"/>

<!-- ********************************************************************* -->
<!-- * Space-stripped and -preserved elements/tokens.                      -->
<!-- ********************************************************************* -->

<xsl:strip-space elements="*"/>

<!-- ********************************************************************* -->
<!-- xsl:template match (modes) section                                    -->
<!-- ********************************************************************* -->

<!-- * Output content to 'chemical-mime-data.mime'. Then process the whole -->
<!-- * file.                                                               -->
<xsl:template match="/">
	<xsl:call-template name="common.write.chunk">
		<xsl:with-param name="filename" select="'chemical-mime-data.mime'"/>
		<xsl:with-param name="method" select="'text'"/>
		<xsl:with-param name="media-type" select="'text/plain'"/>
		<xsl:with-param name="content">
			<xsl:call-template name="common.header.text"/>
			<xsl:apply-templates select=".//fdo:mime-type[@cm:support = 'yes'
			                             and child::fdo:glob[not(cm:conflicts[attribute::gnome = 'yes'])]]">
				<xsl:sort select="@type"/>
			</xsl:apply-templates>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template match="fdo:mime-type">
	<xsl:value-of select="@type"/>
	<xsl:text>&#10;</xsl:text>
	<xsl:text>	ext:</xsl:text>
	<xsl:apply-templates select="fdo:glob[not(cm:conflicts[attribute::gnome = 'yes'])]"/>
	<xsl:text>&#10;&#10;</xsl:text>
</xsl:template>

<xsl:template match="fdo:glob">
	<xsl:text> </xsl:text>
	<xsl:value-of select="substring-after(@pattern,'.')"/>
</xsl:template>

<xsl:template match="*"/>

</xsl:stylesheet>
