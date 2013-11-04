<?xml version="1.0"?>
 <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

 <xsl:template name="EventIdentification" match="/AuditMessage/EventIdentification/EventID">
  <H1>Event Identification</H1>
   <P>
    <xsl:value-of select="AuditMessage/EventIdentification/EventID" />-
    <xsl:value-of select="@code"/>-
    <xsl:value-of select="@code"/>
   </P>
   <p>paragraph</p>
 </xsl:template>


 <xsl:template match="/">
  <HTML>
   <TITLE>IHE-ATNA-Audit Message</TITLE>
   <BODY>
    <table border="1">
    <TR><TH>Field</TH><TH>Code</TH><TH>Code System Name</TH><TH>Display Name</TH></TR>
    <xsl:for-each select="AuditMessage/EventIdentification/EventID">
      <tr>
       <td>EventID</td>
       <td><xsl:value-of select="@code"/></td>
       <td><em><xsl:value-of select="@codeSystemName"/></em></td>
       <td><xsl:value-of select="@displayName"/></td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="AuditMessage/EventIdentification/EventTypeCode">
      <tr>
       <td>EventTypeCode</td>
       <td><xsl:value-of select="@code"/></td>
       <td><em><xsl:value-of select="@codeSystemName"/></em></td>
       <td><xsl:value-of select="@displayName"/></td>
      </tr>
    </xsl:for-each>
    </table>

    <table border="1">
    <xsl:for-each select="AuditMessage/EventIdentification/EventID">
      <tr>
       <td>EventID</td>
       <td><xsl:value-of select="@code"/>:
	<xsl:value-of select="@codeSystemName"/>:
       <xsl:value-of select="@displayName"/></td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="AuditMessage/EventIdentification/EventTypeCode">
      <tr>
       <td>EventTypeCode</td>
       <td><xsl:value-of select="@code"/>:
       <em><xsl:value-of select="@codeSystemName"/></em>:
       <xsl:value-of select="@displayName"/></td>
      </tr>
    </xsl:for-each>
    </table>

    <xsl:apply-templates mode="EventID"/>
    <xsl:apply-templates mode="EventTypeCode"/>

    <H3>Audit Message / Active Participants</H3>
    <table border="1">
    <TR><TH>User ID</TH><TH>User Name</TH><TH>Alternative User ID</TH><TH>User is Requestor</TH></TR>
    <xsl:for-each select="AuditMessage/ActiveParticipant">
     <TR>
      <TD><xsl:value-of select="@UserID" /></TD>
      <TD><xsl:value-of select="@UserName" /></TD>
      <TD><xsl:value-of select="@AlternativeUserID" /></TD>
      <TD><xsl:value-of select="@UserIsRequestor" /></TD>
     </TR>
    </xsl:for-each>
    </table>

    <H3>Audit Message / Audit Source Identification</H3>
    <table border="1">
    <TR><TH>Enterprise Site ID</TH><TH>Audit Source ID</TH></TR>
    <xsl:for-each select="AuditMessage/AuditSourceIdentification">
     <TR>
      <TD><xsl:value-of select="@AuditEnterpriseSiteID" /></TD>
      <TD><xsl:value-of select="@AuditSourceID" /></TD>
     </TR>
    </xsl:for-each>
    </table>



   </BODY>
  </HTML>
 </xsl:template>



 <xsl:template mode="EventID" match="AuditMessage/EventIdentification/EventID[@code=110100]">
  <P>Event ID indicates: Application Activity</P>
 </xsl:template>
 <xsl:template mode="EventID" match="AuditMessage/EventIdentification/EventID[@code=110101]">
  <P>Event ID indicates: Audit Log Used</P>
 </xsl:template>
 <xsl:template mode="EventID" match="AuditMessage/EventIdentification/EventID[@code=110102]">
  <P>Event ID indicates: Begin Transferring DICOM Instances</P>
 </xsl:template>
 <xsl:template mode="EventID" match="AuditMessage/EventIdentification/EventID[@code=110103]">
  <P>Event ID indicates: DICOM Instances Accessed</P>
 </xsl:template>
 <xsl:template mode="EventID" match="AuditMessage/EventIdentification/EventID[@code=110104]">
  <P>Event ID indicates: DICOM Instances Transferred</P>
 </xsl:template>
 <xsl:template mode="EventID" match="AuditMessage/EventIdentification/EventID[@code=110105]">
  <P>Event ID indicates: DICOM Study Deleted</P>
 </xsl:template>
 <xsl:template mode="EventID" match="AuditMessage/EventIdentification/EventID[@code=110106]">
  <P>Event ID indicates: Export</P>
 </xsl:template>
 <xsl:template mode="EventID" match="AuditMessage/EventIdentification/EventID[@code=110107]">
  <P>Event ID indicates: Import</P>
 </xsl:template>
 <xsl:template mode="EventID" match="AuditMessage/EventIdentification/EventID[@code=110108]">
  <P>Event ID indicates: Network Entry</P>
 </xsl:template>
 <xsl:template mode="EventID" match="AuditMessage/EventIdentification/EventID[@code=110109]">
  <P>Event ID indicates: Order Record</P>
 </xsl:template>
 <xsl:template mode="EventID" match="AuditMessage/EventIdentification/EventID[@code=110110]">
  <P>Event ID indicates: Patient Record</P>
 </xsl:template>
 <xsl:template mode="EventID" match="AuditMessage/EventIdentification/EventID[@code=110111]">
  <P>Event ID indicates: Procedure Record</P>
 </xsl:template>
 <xsl:template mode="EventID" match="AuditMessage/EventIdentification/EventID[@code=110112]">
  <P>Event ID indicates: Query</P>
 </xsl:template>
 <xsl:template mode="EventID" match="AuditMessage/EventIdentification/EventID[@code=110113]">
  <P>Event Type Code indicates: Security Alert</P>
 </xsl:template>
 <xsl:template mode="EventID" match="AuditMessage/EventIdentification/EventID[@code=110114]">
  <P>Event Type Code indicates: User Authentication</P>
 </xsl:template>

 <xsl:template mode="EventTypeCode" match="AuditMessage/EventIdentification/EventTypeCode[@code=110120]">
  <P>Event Type Code indicates: Application Start</P>
 </xsl:template>
 <xsl:template mode="EventTypeCode" match="AuditMessage/EventIdentification/EventTypeCode[@code=110121]">
  <P>Event Type Code indicates: Application Stop</P>
 </xsl:template>


</xsl:stylesheet>
