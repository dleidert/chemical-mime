<?xml version="1.0" encoding="UTF-8"?>

<!--
  Document  $Id$
  Summary   XSLT stylesheet to convert XML database into GNOME
            .keys file.
  
  Copyright (C) 2006 Daniel Leidert <daniel.leidert@wgdd.de>.

  This file is free software. The copyright owner gives unlimited
  permission to copy, distribute and modify it.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">


<xsl:import href="cmd_common.xsl"/>
<xsl:output method="text"
            encoding="UTF-8"/>

<xsl:strip-space elements="*"/>

<xsl:template match="/">
	<!-- Output content to 'chemical-mime-data.xml' -->
	<xsl:call-template name="write.chunk">
		<xsl:with-param name="filename" select="'chemical-mime-data.keys'"/>
		<xsl:with-param name="method" select="'text'"/>
		<xsl:with-param name="indent" select="'yes'"/>
		<xsl:with-param name="omit-xml-declaration" select="'yes'"/>
		<xsl:with-param name="media-type" select="'text/plain'"/>
		<xsl:with-param name="doctype-public" select="''"/>
		<xsl:with-param name="doctype-system" select="''"/>
		<!-- Process the whole file -->
		<xsl:with-param name="content">
			<xsl:call-template name="header.text"/>
			<xsl:apply-templates/>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template match="mime-type">
	<!--
		If our MIME type conflicts with another MIME-type, we must suppress support for GNOME 2.4
	-->
	<xsl:param name="conflicts">
		<xsl:choose>
			<xsl:when test=".//conflicts/@gnome='yes'">
				<xsl:value-of select="yes"/>
			</xsl:when>
			<xsl:otherwise>no</xsl:otherwise>
		</xsl:choose>
	</xsl:param>
	
	<!--
		Check if the MIME type is supported and if there are no conflicts.
	-->
	<xsl:if test="@support = 'yes' and $conflicts = 'no'">
		<xsl:value-of select="@type"/>
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&#10;</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="icon">
	<xsl:text>	icon_filename: </xsl:text>
	<xsl:choose>
		<xsl:when test="@gnome != ''">
			<xsl:value-of select="@gnome"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>gnome-mime-chemical.png</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="comment">
	<xsl:choose>
		<xsl:when test="@xml:lang != ''">
			<xsl:text>	[</xsl:text>
			<xsl:value-of select="@xml:lang"/>
			<xsl:text>]description: </xsl:text>
			<xsl:apply-templates/>
			<xsl:text>&#10;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>	description: </xsl:text>
			<xsl:apply-templates/>
			<xsl:text>&#10;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--
	These elements are not used here.
-->
<xsl:template match="acronym|alias|application|expanded-acronym|glob|
                     magic|match|root-XML|specification|sub-class-of|supported-by"/>

</xsl:stylesheet>