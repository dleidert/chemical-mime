<?xml version="1.0" encoding="UTF-8"?>

<!--
  Document  $Id$
  Summary   XSLT stylesheet to convert XML database into KDE
            .desktop files.
  
  Copyright (C) 2006,2007 Daniel Leidert <daniel.leidert@wgdd.de>.

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
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="mime-type">
	<!--
		If our MIME type conflicts with another MIME-type, we must suppress support for KDE 3.x
	-->
	<xsl:param name="conflicts">
		<xsl:choose>
			<xsl:when test=".//conflicts/@kde='yes'">
				<xsl:value-of select="yes"/>
			</xsl:when>
			<xsl:otherwise>no</xsl:otherwise>
		</xsl:choose>
	</xsl:param>
	<!--
		Check if the MIME type is supported and if there are no conflicts.
	-->
	<xsl:if test="@support = 'yes' and $conflicts = 'no'">
		<!--
			Output content to fielname=@type.
		-->
		<xsl:call-template name="write.chunk">
			<xsl:with-param name="filename" select="concat(substring-after(@type,'/'),'.desktop')"/>
			<xsl:with-param name="method" select="'text'"/>
			<xsl:with-param name="indent" select="'yes'"/>
			<xsl:with-param name="omit-xml-declaration" select="'yes'"/>
			<xsl:with-param name="media-type" select="'text/plain'"/>
			<xsl:with-param name="doctype-public" select="''"/>
			<xsl:with-param name="doctype-system" select="''"/>
			<xsl:with-param name="content">
				<xsl:call-template name="header.desktop"/>
				<xsl:text>MimeType=</xsl:text>
				<xsl:value-of select="@type"/>
				<xsl:text>&#10;</xsl:text>
				<xsl:apply-templates/>
				<xsl:call-template name="pattern.list"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<!--
	Now we output the comment as 'Comment=...' or 'Comment[LANG]=...'.
-->
<xsl:template match="comment">
	<xsl:choose>
		<xsl:when test="@xml:lang != ''">
			<xsl:text>Comment[</xsl:text>
			<xsl:value-of select="@xml:lang"/>
			<xsl:text>]=</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>&#10;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>Comment=</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>&#10;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--
	Now output all the possible pattern types as 'Pattern=pattern1;pattern2;'.
-->
<xsl:template name="pattern.list">
	<xsl:text>Patterns=</xsl:text>
	<xsl:for-each select=".//glob/@pattern">
		<xsl:value-of select="."/>
		<xsl:text>;</xsl:text>
	</xsl:for-each>
	<xsl:text>&#10;</xsl:text>
</xsl:template>

<!--
	Now we output the icon filename without suffix as 'Icon=...'.
-->
<xsl:template match="icon">
	<xsl:text>Icon=</xsl:text>
	<xsl:choose>
		<xsl:when test="@kde != ''">
			<xsl:value-of select="@kde"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>chemistry</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>&#10;</xsl:text>
</xsl:template>


<!--
	These elements are not used here.
-->
<xsl:template match="acronym|alias|application|expanded-acronym|glob|
                     magic|match|root-XML|specification|sub-class-of|supported-by"/>

</xsl:stylesheet>

