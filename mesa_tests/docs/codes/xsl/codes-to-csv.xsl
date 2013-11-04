<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mesa="urn:mir" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<xsl:output method="text" indent="no"/>
	<xsl:template match="/">
		<xsl:apply-templates select="mesa:CodeDocument"/>
	</xsl:template>
	<xsl:template match="mesa:CodeDocument">
     <xsl:apply-templates select="mesa:codes/mesa:coded_entry"/>
	</xsl:template>
	
      <!-- Coded Entry -->
    <xsl:template match="mesa:codes/mesa:coded_entry">
    <xsl:text disable-output-escaping="yes">&#010;</xsl:text><xsl:apply-templates select="mesa:param"/>
    </xsl:template>
	
	<xsl:template match="mesa:param"><xsl:apply-templates/>,</xsl:template>    

</xsl:stylesheet>
