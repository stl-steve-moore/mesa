<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mesa="urn:mir" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<xsl:output method="html" indent="yes" version="4.01" encoding="ISO-8859-1" doctype-public="-//W3C//DTD HTML 4.01//EN"/>
	<xsl:variable name="title">
		<xsl:choose>
			<xsl:when test="/mesa:CodeDocument/mesa:header/mesa:title">
				<xsl:value-of select="mesa:CodeDocument/mesa:header/mesa:title"/>
			</xsl:when>
			<xsl:otherwise>MESA Code Document (Unspecified)</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="context">
		<xsl:choose>
			<xsl:when test="/mesa:CodeDocument/mesa:header/mesa:context">
				<xsl:value-of select="mesa:CodeDocument/mesa:header/mesa:context"/>
			</xsl:when>
			<xsl:otherwise>Unspecified</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="description">
		<xsl:choose>
			<xsl:when test="/mesa:CodeDocument/mesa:header/mesa:description">
				<xsl:value-of select="mesa:CodeDocument/mesa:header/mesa:description"/>
			</xsl:when>
			<xsl:otherwise>Unspecified</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:template match="/">
	 <xsl:apply-templates select="mesa:CodeDocument"/>
	</xsl:template>
	<xsl:template match="mesa:CodeDocument">
		<html>
			<head>
				<xsl:comment>
                    Do NOT edit this HTML directly, it was generated via an XSL
                    transformation
                </xsl:comment>
				<xsl:text disable-output-escaping="yes">&#010;</xsl:text>
				<title>
					<xsl:value-of select="$title"/>
				</title>
			</head>
			<xsl:text disable-output-escaping="yes">&#010;</xsl:text>
			<body class="base" style="width: 95%">
				<h2>
					<xsl:value-of select="$title"/>
				</h2>
				<xsl:text disable-output-escaping="yes">&#010;</xsl:text>
				<p><b>Context: </b><xsl:value-of select="$context"/></p>
				<xsl:text disable-output-escaping="yes">&#010;</xsl:text>
				<p><b>Description: </b><xsl:value-of select="$description"/></p>
				<hr/>
				<xsl:apply-templates select="mesa:codes"/>
            </body>
			<hr/>
		</html>
	</xsl:template>
	
    <!-- Sections -->    
	
    <!-- Codes -->
    <xsl:template match="mesa:codes">
     <TABLE border = "2">
     <xsl:apply-templates select="mesa:columns"/>
     <xsl:apply-templates select="mesa:coded_entry"/>
      </TABLE>
      <br></br>
    </xsl:template>
    
    <xsl:template match="mesa:columns">
     <tr>
      <xsl:apply-templates select="mesa:column_name"/>
     </tr>
    </xsl:template> 
    <xsl:template match="mesa:coded_entry">
     <tr>
      <xsl:apply-templates select="mesa:param"/>
     </tr>
    </xsl:template> 
       
	<xsl:template match="mesa:column_name">
		<th><xsl:apply-templates/></th>
    </xsl:template> 
	<xsl:template match="mesa:param">
		<td><xsl:apply-templates/></td>
    </xsl:template> 
</xsl:stylesheet>
