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

<xsl:template match="/">
	<xsl:variable name="targets" select=".//mime-type[@support = 'yes'
	                                     and (child::glob[not(conflicts[attribute::kde = 'yes'])]
	                                          or child::magic)]"/>

	<xsl:apply-templates select="$targets|$targets/alias">
		<xsl:sort select="@type"/>
	</xsl:apply-templates>
</xsl:template>

<!-- * Output the content for every chemical MIME type to a separate file, -->
<!-- * named from mime-type[@type]. Then just process the content of the   -->
<!-- * currently processed mime-type node.                                 -->
<xsl:template match="mime-type">
	<xsl:call-template name="common.write.chunk">
		<xsl:with-param name="filename" select="concat(substring-after(@type,'/'),'.desktop')"/>
		<xsl:with-param name="method" select="'text'"/>
		<xsl:with-param name="media-type" select="'text/plain'"/>
		<xsl:with-param name="content">
			<xsl:call-template name="kde.desktop.header"/>
			<xsl:text>MimeType=</xsl:text>
			<xsl:value-of select="@type"/>
			<xsl:text>&#10;</xsl:text>
			<xsl:apply-templates select="comment|icon"/>
			<xsl:if test="not(child::icon[attribute::kde])">
				<xsl:call-template name="kde.desktop.generic.icon"/>
			</xsl:if>
      <!-- * Output the pattern in alphabetical order. Therefor choose all -->
      <!-- * pattern, if there is some magic (then we have a KMimeMagic    -->
      <!-- * database). Or if no magic is defined, only apply              -->
      <!-- * non-conflicting global pattern.                               -->
			<xsl:apply-templates select="glob[not(conflicts[attribute::kde = 'yes'])][not(following-sibling::magic)]
			                            |glob[following-sibling::magic]">
				<xsl:sort select="@pattern"/>
			</xsl:apply-templates>
			<!-- <xsl:if test="child::sub-class-of">
				<xsl:apply-templates select="sub-class-of"/>
			</xsl:if> -->
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<!-- * http://lists.kde.org/?l=kde-core-devel&m=117187815920099&w=2:       -->
<!-- * Following David Faure's suggestion, the aliases should be output as -->
<!-- * separate .desktop files. These files should not contain any         -->
<!-- * pattern. But they should be of sub-class (X-KDE-IsAlso) of the      -->
<!-- * ancestor mime-type @type attribute.                                 -->
<xsl:template match="alias">
	<xsl:call-template name="common.write.chunk">
		<xsl:with-param name="filename" select="concat(substring-after(@type,'/'),'.desktop')"/>
		<xsl:with-param name="method" select="'text'"/>
		<xsl:with-param name="media-type" select="'text/plain'"/>
		<xsl:with-param name="content">
			<xsl:call-template name="kde.desktop.header"/>
			<xsl:text>MimeType=</xsl:text>
			<xsl:value-of select="@type"/>
			<xsl:text>&#10;</xsl:text>
			<xsl:apply-templates select="preceding-sibling::comment|following-sibling::icon"/>
			<xsl:if test="not(following-sibling::icon)">
				<xsl:call-template name="kde.desktop.generic.icon"/>
			</xsl:if>
      <!-- * Output no pattern, as we are doing alias-processing. But put  -->
      <!-- * the ancestor mime-type @type as alias into the file.                -->
			<xsl:call-template name="sub-class-of">
				<xsl:with-param name="content" select="ancestor::mime-type/@type"/>
			</xsl:call-template>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template match="comment">
	<xsl:text>Comment</xsl:text>
	<xsl:if test="@xml:lang">
		<xsl:text>[</xsl:text>
		<xsl:value-of select="@xml:lang"/>
		<xsl:text>]</xsl:text>
	</xsl:if>
	<xsl:text>=</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="icon[attribute::kde]">
	<xsl:text>Icon=</xsl:text>
	<xsl:value-of select="@kde"/>
	<xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="glob">
  <!-- * The pattern must occur in the Pattern field.                      -->
	<xsl:if test="position() = 1">
		<xsl:text>Patterns=</xsl:text>
	</xsl:if>
	<xsl:value-of select="@pattern"/>
	<xsl:text>;</xsl:text>
  <!-- * KDE uses lower- and uppercase extensions. So if we have           -->
  <!-- * case-insensitive lowercase pattern of the type "*.foo", create    -->
  <!-- * the uppercase pendant and add it to the list too.                 -->
	<xsl:variable name="uppercase.sensitive"
	              select="translate(@pattern,
		                    'abcdefghijklmnopqrstuvwxyz',
		                    'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
	<xsl:if test="starts-with(@pattern, '*.')
	              and $uppercase.sensitive != @pattern">
		<xsl:value-of select="$uppercase.sensitive"/>
		<xsl:text>;</xsl:text>
	</xsl:if>
  <!-- * And after the last pattern we need a newline.                     -->
	<xsl:if test="position() = last()">
		<xsl:text>&#10;</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="sub-class-of" name="sub-class-of">
	<xsl:param name="content" select="@type"/>

	<xsl:text>X-KDE-IsAlso=</xsl:text>
	<xsl:value-of select="$content"/>
	<xsl:text>&#10;</xsl:text>
	<!-- * Be empty at the moment.                                           -->
	<!--
	<xsl:if test="@type = ('text/plain' or 'application/xml' or 'text/xml')">
		<xsl:text>&#10;</xsl:text>
		<xsl:text>[Property::X-KDE-text]&#10;</xsl:text>
		<xsl:text>Type=bool&#10;</xsl:text>
		<xsl:text>Value=true&#10;</xsl:text>
	</xsl:if>
	-->
</xsl:template>

<xsl:template match="acronym|application|expanded-acronym|icon|
                     magic|match|root-XML|specification|supported-by"/>

<!-- ********************************************************************* -->
<!-- * Named templates for special processing and functions.               -->
<!-- ********************************************************************* -->

<xsl:template name="kde.desktop.header">
  <!-- * The header of a KDE MIME(lnk) .desktop file always looks the      -->
  <!-- * same. Output the header here.                                     -->
	<xsl:text>[Desktop Entry]
Encoding=UTF-8
Type=MimeType&#10;</xsl:text>
</xsl:template>

<xsl:template name="kde.desktop.generic.icon">
  <!-- * Just output the completely processed and (maybe) extended output  -->
  <!-- * without escaping the content. This saves added acronym templates  -->
  <!-- * tags.                                                             -->
	<xsl:text>Icon=chemistry&#10;</xsl:text>
</xsl:template>

</xsl:stylesheet>
