<?xml version="1.0" encoding="UTF-8"?>

<!--
  Document  $Id$
  Summary   XSLT stylesheet to convert XML database into GNOME
            .keys file.
  
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
<!-- * xsl:template match (modes) section                                  -->
<!-- ********************************************************************* -->

<!-- * Output content to 'chemical-mime-data.keys'. Then process the whole -->
<!-- * file.                                                               -->
<xsl:template match="/">
	<xsl:call-template name="common.write.chunk">
		<xsl:with-param name="filename" select="'chemical-mime-data.keys'"/>
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
	<xsl:apply-templates/>
	<xsl:if test="not(child::cm:icon[attribute::gnome])">
		<xsl:call-template name="gnome.keys.generic.icon"/>
	</xsl:if>
	<xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="cm:icon[attribute::gnome]">
	<xsl:text>	icon_filename: </xsl:text>
	<xsl:value-of select="@gnome"/>
	<xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="fdo:comment">
	<xsl:text>	</xsl:text>
	<xsl:if test="@xml:lang">
		<xsl:text>[</xsl:text>
		<xsl:value-of select="@xml:lang"/>
		<xsl:text>]</xsl:text>
	</xsl:if>
	<xsl:text>description: </xsl:text>
	<xsl:apply-templates/>
	<xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="*"/>

<!-- ********************************************************************* -->
<!-- * Named templates for special processing and functions.               -->
<!-- ********************************************************************* -->

<!-- * Just output the completely processed and (maybe) extended output    -->
<!-- * without escaping the content. This saves added acronym templates    -->
<!-- * tags.                                                               -->
<xsl:template name="gnome.keys.generic.icon">
	<xsl:text>	icon_filename: gnome-mime-chemical.png&#10;</xsl:text>
</xsl:template>

</xsl:stylesheet>
