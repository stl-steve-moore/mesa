<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">

<xsl:template match="/">
<html>
    <head>
	    <title> <xsl:value-of select="IHEDocumentList/recordTarget/patient/patientPatient/name/family"/>,
	    <xsl:value-of select="IHEDocumentList/recordTarget/patient/patientPatient/name/given"/>
	    </title>
    </head>
    <body>
	    <h2>List of ECG's for <xsl:value-of select="IHEDocumentList/recordTarget/patient/patientPatient/name/family"/>,
	    <xsl:value-of select="IHEDocumentList/recordTarget/patient/patientPatient/name/given"/>
	    </h2>
	    <b> Gender:</b> <xsl:value-of select="IHEDocumentList/recordTarget/patient/patientPatient/administrativeGenderCode/@code"/><br/>
	    <b> DOB:</b> <xsl:value-of select="IHEDocumentList/recordTarget/patient/patientPatient/birthTime/@value"/><br/>
	    <b> List Created:</b> <xsl:value-of select="IHEDocumentList/activityTime/@value"/><br/><br/>
        <table border="2" bgcolor="lightcyan">
            <tr>
                <th>Type</th>
                <th>Status</th>
                <th>Date</th>
                <th>ECG Document</th>
            </tr>
	    <xsl:for-each select="/IHEDocumentList/component/documentInformation">
		<tr>
		    <td><xsl:value-of select="code/@displayName"/></td>
		    <td><xsl:value-of select="statusCode/@code"/></td>
		    <td><xsl:value-of select="effectiveTime/@value"/></td>
		    <td>
			<a> <xsl:attribute name = "HREF"> <xsl:value-of select="text/reference/@value"/>
			</xsl:attribute> Get Document</a>
		    </td>
                </tr>
            </xsl:for-each>
        </table>
    </body>
</html>
</xsl:template>
</xsl:stylesheet>

