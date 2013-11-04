<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mesa="urn:mir" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<xsl:output method="html" indent="yes" version="4.01" encoding="ISO-8859-1" doctype-public="-//W3C//DTD HTML 4.01//EN"/>
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
		<html>
			<head>
				<!-- <meta name='Generator' content='&n1-Stylesheet;'/> -->
				<xsl:comment>
                    Do NOT edit this HTML directly, it was generated via an XSLt
                    transformation from the original release 2 n1 Document.
                </xsl:comment>
				<title>
					<xsl:value-of select="$title"/>
				</title>
			</head>
			<body class="base" style="width: 95%">
				<h2>
					<xsl:value-of select="$title"/>
				</h2>
				<hr/>
            <xsl:apply-templates select="mesa:section"/>
            <xsl:apply-templates select="mesa:testSteps"/>
            </body>
			<hr/>
		</html>
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
    
    <!--   list  -->
    <xsl:template match="mesa:list">
        <ul><li class='text'><xsl:apply-templates/></li></ul>
    </xsl:template>
    
    <!--   paragraph  -->
    <xsl:template match="mesa:paragraph">
        <p class='text'><xsl:apply-templates/></p>
    </xsl:template>
    
    <!-- Test Steps -->
    <xsl:template match="mesa:testSteps">
     <TABLE border = "2">
      <!-- <tr><th>Identifier</th><th>Description</th><th>Transaction</th><th>Source</th><th>Destination</th><th>Verb</th><th>P1</th><th>P2</th><th>P3</th></tr> -->
      <tr><th>Identifier</th><th>Description</th><th>Transaction</th><th>Source</th><th>Destination</th><th>Verb</th></tr>
     <xsl:apply-templates select="mesa:step"/>
      </TABLE>
      <br></br>
	 <!--
     <TABLE border = "2">
     <xsl:apply-templates select="mesa:internal | mesa:patient | mesa:profile | mesa:step | mesa:text_file"/>

      </TABLE>
     -->
    </xsl:template>
	
    <xsl:template match="mesa:step">
     <tr>
     <td><xsl:value-of select="mesa:identifier"/></td>
     <td><xsl:value-of select="mesa:description"/></td>
     <td><xsl:value-of select="mesa:transaction"/></td>
     <td><xsl:value-of select="mesa:source"/></td>
     <td><xsl:value-of select="mesa:destination"/></td>
     <td><xsl:value-of select="mesa:verb"/></td>
     <!-- <xsl:apply-templates select="mesa:param"/> -->
     </tr>
    </xsl:template>
	
    <xsl:template match="mesa:verb">
     <td><xsl:value-of select="$verb"/></td>
     <td><xsl:value-of select="$param"/></td>
    </xsl:template>

	<xsl:template match="mesa:param">
		<td><xsl:apply-templates/></td>
    </xsl:template>    
	
    <xsl:template match="mesa:internal">
      <tr>
      <td>INTERNAL</td>
      <xsl:apply-templates select="mesa:param"/>
      </tr>
    </xsl:template>
	
    <xsl:template match="mesa:patient">
      <tr>
      <td>PATIENT</td>
      <td><xsl:value-of select="mesa:file"/></td>
      </tr>
    </xsl:template>
	
    <xsl:template match="mesa:profile">
      <tr>
      <td>PROFILE</td>
      <td><xsl:value-of select="mesa:name"/></td>
      </tr>
    </xsl:template>
	
    <xsl:template match="mesa:text_file">
      <tr>
      <td>TEXT</td>
      <td><xsl:value-of select="mesa:file"/></td>
      </tr>
    </xsl:template>
	
</xsl:stylesheet>
