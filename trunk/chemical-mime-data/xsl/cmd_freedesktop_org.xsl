<?xml version="1.0" encoding="UTF-8"?>

<!--
  Document  $WgDD$
  Summary   XSLT stylesheet to convert XML database into freedesktop.org
            database file.
  
  Copyright (C) 2006 Daniel Leidert <daniel.leidert@wgdd.de>.

  This file is free software. The copyright owner gives unlimited
  permission to copy, distribute and modify it.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">


<xsl:import href="cmd_common.xsl"/>
<xsl:output method="xml"
            encoding="UTF-8"
            indent="yes"
            omit-xml-declaration="yes"/>

<xsl:strip-space elements="*"/>

<xsl:template match="/">
	<!-- Output content to 'chemical-mime-data.xml' -->
	<xsl:call-template name="write.chunk">
		<xsl:with-param name="filename" select="'chemical-mime-data.xml'"/>
		<xsl:with-param name="method" select="'xml'"/>
		<xsl:with-param name="indent" select="'yes'"/>
		<xsl:with-param name="omit-xml-declaration" select="'yes'"/>
		<xsl:with-param name="doctype-public" select="''"/>
		<xsl:with-param name="doctype-system" select="''"/>
		<xsl:with-param name="standalone" select="'yes'"/>
		<!-- Process the whole file -->
		<xsl:with-param name="content">
			<xsl:call-template name="header.xml"/>
			<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
				<xsl:apply-templates/>
			</mime-info>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template match="chemical-mime-type">
	<xsl:if test="@support='yes'">
		<mime-type>
			<xsl:copy-of select="@type"/>
			<xsl:apply-templates/>
		</mime-type>
	</xsl:if>
</xsl:template>

<xsl:template match="acronym|alias|comment|expanded-acronym|glob|magic|match|root-XML|sub-class-of">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:copy-of select="node()"/>
  </xsl:copy>
</xsl:template>

<!--
	These elements are not used here.
-->
<xsl:template match="application|conflicts|icon|specification|supported-by"/>

</xsl:stylesheet>