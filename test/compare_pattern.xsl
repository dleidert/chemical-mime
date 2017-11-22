<?xml version="1.0" encoding="UTF-8"?>

<!--
  Document  $Id$
  Summary   XSLT stylesheet for testing, if the database contains
            a MIME type with an unrecognized pattern conflict to
            the given database.
  
  Copyright (C) 2007 Daniel Leidert <daniel.leidert@wgdd.de>.

  This file is free software. The copyright owner gives unlimited
  permission to copy, distribute and modify it.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cm="http://chemical-mime.sourceforge.net/chemical-mime"
                xmlns:fdo="http://www.freedesktop.org/standards/shared-mime-info"
                exclude-result-prefixes="cm fdo"
                version="1.0">

<!-- ********************************************************************* -->
<!-- * Space-stripped and -preserved elements/tokens.                      -->
<!-- ********************************************************************* -->

<xsl:strip-space elements="*"/>

<!-- ********************************************************************* -->
<!-- * Parameter declaration section.                                      -->
<!-- ********************************************************************* -->

<xsl:param name="database"/>
<xsl:param name="database.type"/>
<xsl:param name="database.uri"/>

<!-- ********************************************************************* -->
<!-- * xsl:template match (modes) section                                  -->
<!-- ********************************************************************* -->

<xsl:template match="/">
  <!-- * Select every chemical MIME type node of the root node to start    -->
  <!-- * the test.                                                         -->
	<xsl:message>
TEST: Compare global pattern to <xsl:value-of select="$database"/>
TEST: <xsl:value-of select="$database.type"/> database for unrecognized pattern conflicts.
/*****************************************************************************
* STARTING pattern test .....
	</xsl:message>
	<xsl:apply-templates select=".//fdo:mime-type">
		<xsl:sort select="@type"/>
	</xsl:apply-templates>
  <xsl:message>
* ENDING pattern test .....
*
* TEST: Pattern test ran successful.
\*****************************************************************************
	</xsl:message>
</xsl:template>

<xsl:template match="fdo:mime-type">
  <!-- * Write the MIME-type, if magic pattern are available and the       -->
  <!-- * sub-class (fallback: application/octet-stream into parameters.    -->
  <!-- * Then process every global pattern and also overhand the already   -->
  <!-- * examined data.                                                    -->
	<xsl:variable name="my.mime.type" select="@type"/>
	<xsl:variable name="my.mime.type.magic" select="boolean(fdo:magic)"/>
	<xsl:variable name="my.mime.type.subclass">
		<xsl:choose>
			<xsl:when test="fdo:sub-class-of/@type">
				<xsl:value-of select="fdo:sub-class-of/@type"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'application/octet-stream'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:apply-templates select="fdo:glob">
		<xsl:with-param name="my.mime.type" select="$my.mime.type"/>
		<xsl:with-param name="my.mime.type.magic" select="$my.mime.type.magic"/>
		<xsl:with-param name="my.mime.type.subclass" select="$my.mime.type.subclass"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="fdo:glob">
  <!-- * Add the pattern to the given set of data. If the pattern has a    -->
  <!-- * known conflicts, process it and overhand the already collected    -->
  <!-- * data. If no conflicts exists, directly call the real test         -->
  <!-- * template with the examined data.                                  -->
	<xsl:param name="my.mime.type"/>
	<xsl:param name="my.mime.type.magic"/>
	<xsl:param name="my.mime.type.subclass"/>
	<xsl:variable name="my.mime.type.pattern" select="@pattern"/>
	
	<xsl:choose>
		<xsl:when test="$database.type = 'fdo'">
			<xsl:apply-templates select="cm:conflicts[@fdo = 'yes']">
				<xsl:with-param name="my.mime.type" select="$my.mime.type"/>
				<xsl:with-param name="my.mime.type.magic" select="$my.mime.type.magic"/>
				<xsl:with-param name="my.mime.type.pattern" select="$my.mime.type.pattern"/>
				<xsl:with-param name="my.mime.type.subclass" select="$my.mime.type.subclass"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:when test="$database.type = 'gnome'">
			<xsl:apply-templates select="cm:conflicts[@gnome = 'yes']">
				<xsl:with-param name="my.mime.type" select="$my.mime.type"/>
				<xsl:with-param name="my.mime.type.magic" select="$my.mime.type.magic"/>
				<xsl:with-param name="my.mime.type.pattern" select="$my.mime.type.pattern"/>
				<xsl:with-param name="my.mime.type.subclass" select="$my.mime.type.subclass"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:when test="$database.type = 'kde'">
			<xsl:apply-templates select="cm:conflicts[@kde = 'yes']">
				<xsl:with-param name="my.mime.type" select="$my.mime.type"/>
				<xsl:with-param name="my.mime.type.magic" select="$my.mime.type.magic"/>
				<xsl:with-param name="my.mime.type.pattern" select="$my.mime.type.pattern"/>
				<xsl:with-param name="my.mime.type.subclass" select="$my.mime.type.subclass"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:when test="$database.type = 'mime.types'">
			<xsl:apply-templates select="cm:conflicts[@mimetypes = 'yes']">
				<xsl:with-param name="my.mime.type" select="$my.mime.type"/>
				<xsl:with-param name="my.mime.type.magic" select="$my.mime.type.magic"/>
				<xsl:with-param name="my.mime.type.pattern" select="$my.mime.type.pattern"/>
				<xsl:with-param name="my.mime.type.subclass" select="$my.mime.type.subclass"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="match.mime.type.glob">
				<xsl:with-param name="my.mime.type" select="$my.mime.type"/>
				<xsl:with-param name="my.mime.type.magic" select="$my.mime.type.magic"/>
				<xsl:with-param name="my.mime.type.pattern" select="$my.mime.type.pattern"/>
				<xsl:with-param name="my.mime.type.subclass" select="$my.mime.type.subclass"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template> 

<xsl:template match="cm:conflicts">
  <!-- * Add the conflicting MIME type to the given set of data and call   -->
  <!-- * the real test template with the examined data.                    -->
	<xsl:param name="my.mime.type"/>
	<xsl:param name="my.mime.type.magic"/>
	<xsl:param name="my.mime.type.pattern"/>
	<xsl:param name="my.mime.type.subclass"/>
	
	<xsl:call-template name="match.mime.type.glob">
		<xsl:with-param name="my.mime.type" select="$my.mime.type"/>
		<xsl:with-param name="my.mime.type.conflict" select="@type"/>
		<xsl:with-param name="my.mime.type.magic" select="$my.mime.type.magic"/>
		<xsl:with-param name="my.mime.type.pattern" select="$my.mime.type.pattern"/>
		<xsl:with-param name="my.mime.type.subclass" select="$my.mime.type.subclass"/>
	</xsl:call-template>
</xsl:template> 

<!-- ********************************************************************* -->
<!-- * Named templates for special processing and functions.               -->
<!-- ********************************************************************* -->

<xsl:template name="match.mime.type.glob">
  <!-- * The test template. Check, if we have a pattern match between the  -->
  <!-- * source and the extern database. If that's the case, check, if we  -->
  <!-- * already mentioned the related MIME type as conflicts in our       -->
  <!-- * internal source database. If that's not the case, bail out with   -->
  <!-- * an error. Otherwise check, if the MIME types are of the same      -->
  <!-- * sub-class. In such a case, it would be very important, that magic -->
  <!-- * pattern exist, so these MIME types can be divided. If no magic    -->
  <!-- * pattern exist, print a warning. Otherwise just give some          -->
  <!-- * information, what we found out.                                   -->
	<xsl:param name="my.mime.type"/>
	<xsl:param name="my.mime.type.conflict" select="false()"/>
	<xsl:param name="my.mime.type.magic"/>
	<xsl:param name="my.mime.type.pattern"/>
	<xsl:param name="my.mime.type.subclass"/>
	
	<xsl:for-each select="document($database.uri)//fdo:mime-type[child::fdo:glob[@pattern = $my.mime.type.pattern]]">

		<xsl:variable name="ext.database.type" select="@type"/>
		<xsl:variable name="ext.database.subtype">
			<xsl:choose>
				<xsl:when test="fdo:sub-class-of/@type">
					<xsl:value-of select="fdo:sub-class-of/@type"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'application/octet-stream'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:message>
			<xsl:text> </xsl:text>
			<xsl:text>FOUND: Hit in the </xsl:text>
			<xsl:value-of select="$database.type"/>
			<xsl:text> database: Pattern "</xsl:text>
			<xsl:value-of select="$my.mime.type.pattern"/>
			<xsl:text>" of "</xsl:text>
			<xsl:value-of select="$my.mime.type"/>
			<xsl:text>" conflicting with "</xsl:text>
			<xsl:value-of select="$ext.database.type"/>
			<xsl:text>".</xsl:text>
		</xsl:message>
		<xsl:choose>
			<xsl:when test="$ext.database.type != $my.mime.type.conflict
			                and not(child::fdo:alias[attribute::type = $my.mime.type.conflict])">
				<xsl:message terminate="yes">       ** ERROR **: MUST add this conflict with "<xsl:value-of select="$ext.database.type"/>"!
*
* TEST: Pattern test bailed out with an error.
\*****************************************************************************
				</xsl:message>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>
					<xsl:text>     </xsl:text>
					<xsl:text>INFO: Already mentioned the conflict with "</xsl:text>
					<xsl:value-of select="$ext.database.type"/>
					<xsl:text>". No need to worry.</xsl:text>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$database.type = 'fdo'">
			<xsl:choose>
				<xsl:when test="not($ext.database.subtype = $my.mime.type.subclass)">
					<xsl:message>
						<xsl:text>     </xsl:text>
						<xsl:text>INFO: Different MIME sub-class types "</xsl:text>
						<xsl:value-of select="$ext.database.subtype"/>
						<xsl:text>" (external) and "</xsl:text>
						<xsl:value-of select="$my.mime.type.subclass"/>
						<xsl:text>" (chemical)!</xsl:text>
					</xsl:message>
					<xsl:choose>
						<xsl:when test="$my.mime.type.magic">
							<xsl:message>
								<xsl:text>     </xsl:text>
								<xsl:text>INFO: Found some magic, which is a good thing.</xsl:text>
							</xsl:message>
						</xsl:when>
						<xsl:otherwise>
							<xsl:message>
								<xsl:text>     </xsl:text>
								<xsl:text>INFO: No magic found, but maybe not a big problem, because sub-class types differ.</xsl:text>
							</xsl:message>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message>
						<xsl:text>     </xsl:text>
						<xsl:text>INFO: Same MIME sub-class types "</xsl:text>
						<xsl:value-of select="$ext.database.subtype"/>
						<xsl:text>" and "</xsl:text>
						<xsl:value-of select="$my.mime.type.subclass"/>
						<xsl:text>"!</xsl:text>
					</xsl:message>
					<xsl:choose>
						<xsl:when test="$my.mime.type.magic">
							<xsl:message>
								<xsl:text>     </xsl:text>
								<xsl:text>INFO: Found some magic, which is a good thing.</xsl:text>
							</xsl:message>
						</xsl:when>
						<xsl:otherwise>
							<xsl:message>
								<xsl:text>     </xsl:text>
								<xsl:text>WARNING: No magic found, which is RECOMMENDED to be changed.</xsl:text>
							</xsl:message>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:message><xsl:text>&#10;</xsl:text></xsl:message>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
