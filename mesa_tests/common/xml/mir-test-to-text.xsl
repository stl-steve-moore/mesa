<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mesa="urn:mir" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<xsl:output method="text" indent="yes" version="4.01" encoding="ISO-8859-1" doctype-public="-//W3C//DTD HTML 4.01//EN"/>
	<!-- <xsl:variable name="tableWidth">50%</xsl:variable> -->
	<xsl:variable name="title">
		<xsl:choose>
			<xsl:when test="/mesa:TestDocument/mesa:header/mesa:title">
				<xsl:value-of select="mesa:TestDocument/mesa:header/mesa:title"/>
			</xsl:when>
			<xsl:otherwise>MESA Test Document (Unspecified)</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
		<xsl:variable name="par">
		<xsl:choose>
			<xsl:when test="/mesa:paragraph">
				<xsl:value-of select="/mesa:paragraph"/>
			</xsl:when>
			<xsl:otherwise>Empty paragraph</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="verb">
		<xsl:choose>
			<xsl:when test="/mesa:verb">
				<xsl:value-of select="/mesa:verb"/>
			</xsl:when>
			<xsl:otherwise>Unspecified verb</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>	
	
	<xsl:variable name="param">
		<xsl:choose>
			<xsl:when test="/mesa:param">
				<xsl:value-of select="/mesa:param"/>
			</xsl:when>
			<xsl:otherwise>Unspecified param</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
		
	<xsl:template match="/">
		<xsl:apply-templates select="mesa:TestDocument"/>
	</xsl:template>
	<xsl:template match="mesa:TestDocument">

            <xsl:apply-templates select="mesa:testSteps"/>
	</xsl:template>
	
    <!-- Sections -->    
    <xsl:template match="mesa:section">
          <h3><xsl:apply-templates select="mesa:title">
        </xsl:apply-templates></h3>
        <xsl:apply-templates select="mesa:text"/>
	</xsl:template>
	
	<xsl:template match="mesa:text">  
	<xsl:apply-templates /> 
    </xsl:template>
    
    <!--   paragraph  -->
    <xsl:template match="mesa:paragraph">
        <p class='text'><xsl:apply-templates/></p>
    </xsl:template>
    
    <!-- Test Steps -->
    <xsl:template match="mesa:testSteps">
     <xsl:apply-templates select="mesa:comment | mesa:internal | mesa:message| mesa:patient | mesa:profile | mesa:step | mesa:text_file"/>
    </xsl:template>
	
    <xsl:template match="mesa:step">
     <xsl:value-of select="mesa:verb"/>
     <xsl:text disable-output-escaping="yes">&#009;</xsl:text><xsl:value-of select="mesa:transaction"/>
     <xsl:text disable-output-escaping="yes">&#009;</xsl:text><xsl:value-of select="mesa:source"/>
     <xsl:text disable-output-escaping="yes">&#009;</xsl:text><xsl:value-of select="mesa:destination"/>
     <xsl:apply-templates select="mesa:param"/>
     <xsl:text disable-output-escaping="yes">&#010;</xsl:text>
    </xsl:template>

    <xsl:template match="mesa:verb">
     <xsl:value-of select="$verb"/>
     <xsl:value-of select="$param"/>
    </xsl:template>

    <xsl:template match="mesa:comment"><xsl:text disable-output-escaping="yes">#</xsl:text><xsl:value-of select="mesa:description"/>
     <xsl:text disable-output-escaping="yes">&#010;</xsl:text>
    </xsl:template>

    <xsl:template match="mesa:internal"><xsl:text disable-output-escaping="yes">MESA-INTERNAL</xsl:text><xsl:apply-templates select="mesa:param"/>
     <xsl:text disable-output-escaping="yes">&#010;</xsl:text>
    </xsl:template>

    <xsl:template match="mesa:message"><xsl:text disable-output-escaping="yes">MESSAGE</xsl:text><xsl:apply-templates select="mesa:param"/>
     <xsl:text disable-output-escaping="yes">&#010;</xsl:text>
    </xsl:template>

    <xsl:template match="mesa:patient"><xsl:text disable-output-escaping="yes">PATIENT&#009;</xsl:text><xsl:value-of select="mesa:file"/>
     <xsl:text disable-output-escaping="yes">&#010;</xsl:text>
    </xsl:template>

    <xsl:template match="mesa:profile"><xsl:text disable-output-escaping="yes">PROFILE&#009;</xsl:text><xsl:value-of select="mesa:name"/>
     <xsl:text disable-output-escaping="yes">&#010;</xsl:text>
    </xsl:template>
    
	<xsl:template match="mesa:param"><xsl:text disable-output-escaping="yes">&#009;</xsl:text>
<xsl:apply-templates/>
    </xsl:template>    

    <xsl:template match="mesa:text_file"><xsl:text disable-output-escaping="yes">TEXT&#009;</xsl:text><xsl:value-of select="mesa:file"/>
     <xsl:text disable-output-escaping="yes">&#010;</xsl:text>
    </xsl:template>
	
</xsl:stylesheet>
