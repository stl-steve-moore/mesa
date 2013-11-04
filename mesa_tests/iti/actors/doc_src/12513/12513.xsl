<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:sch="http://www.ascc.net/xml/schematron" version="1.0" xmlns:cda="urn:hl7-org:v3" cda:dummy-for-xmlns="" xmlns:crs="urn:hl7-org:crs" crs:dummy-for-xmlns="">
<axsl:output method="text"/>
<axsl:template mode="schematron-get-full-path" match="*|@*">
<axsl:apply-templates mode="schematron-get-full-path" select="parent::*"/>
<axsl:text>/</axsl:text>
<axsl:if test="count(. | ../@*) = count(../@*)">@</axsl:if>
<axsl:value-of select="name()"/>
<axsl:text>[</axsl:text>
<axsl:value-of select="1+count(preceding-sibling::*[name()=name(current())])"/>
<axsl:text>]</axsl:text>
</axsl:template>
<axsl:template match="/">Schematron schema for validating conformance to IMPL_CDAR2_LEVEL1REF_US_I1_2005MAY
<axsl:apply-templates mode="M3" select="/"/>
</axsl:template>
<axsl:template mode="M3" priority="4000" match="cda:ClinicalDocument">
<axsl:if test="count(cda:component[cda:structuredBody[cda:component[cda:section[cda:entry[cda:observation[cda:id[@extension='484.1.problem-4' and @root='1.3.6.1.4.1.21367.2006.1.2.103.10']]]]]]]) &gt; 0">In pattern count(cda:component[cda:structuredBody[cda:component[cda:section[cda:entry[cda:observation[cda:id[@extension='484.1.problem-4' and @root='1.3.6.1.4.1.21367.2006.1.2.103.10']]]]]]]) &gt; 0:
   cda:id @extenstion='484.1.problem-4' OK
</axsl:if>
<axsl:choose>
<axsl:when test="count(cda:component[cda:structuredBody[cda:component[cda:section[cda:entry[cda:observation[cda:id[@extension='484.1.problem-4' and @root='1.3.6.1.4.1.21367.2006.1.2.103.10']]]]]]]) &gt; 0"/>
<axsl:otherwise>In pattern count(cda:component[cda:structuredBody[cda:component[cda:section[cda:entry[cda:observation[cda:id[@extension='484.1.problem-4' and @root='1.3.6.1.4.1.21367.2006.1.2.103.10']]]]]]]) &gt; 0:
   ERR: cda:id @extension='484.1.problem-4' @root='1.3.6.1.4.1.21367.2006.1.2.103.10' not found
</axsl:otherwise>
</axsl:choose>
<axsl:choose>
<axsl:when test="count(cda:component[cda:structuredBody[cda:component[cda:section[cda:entry[cda:observation[cda:code[@codeSystemName='SNOMED CT' and  @codeSystem='2.16.840.1.113883.6.96' and @code='246188002' and @displayName='Finding']]]]]]]) &gt; 0"/>
<axsl:otherwise>In pattern count(cda:component[cda:structuredBody[cda:component[cda:section[cda:entry[cda:observation[cda:code[@codeSystemName='SNOMED CT' and @codeSystem='2.16.840.1.113883.6.96' and @code='246188002' and @displayName='Finding']]]]]]]) &gt; 0:
   ERR: no cda:code codeSystemName='SNOMED CT' and codeSystem='2.16.840.1.113883.6.96' and code='246188002' and displayName='Finding' found
</axsl:otherwise>
</axsl:choose>
<axsl:if test="count(cda:component[cda:structuredBody[cda:component[cda:section[cda:entry[cda:observation[cda:code[@codeSystemName='SNOMED CT' and  @codeSystem='2.16.840.1.113883.6.96' and @code='246188002' and @displayName='Finding']]]]]]]) &gt; 0">In pattern count(cda:component[cda:structuredBody[cda:component[cda:section[cda:entry[cda:observation[cda:code[@codeSystemName='SNOMED CT' and @codeSystem='2.16.840.1.113883.6.96' and @code='246188002' and @displayName='Finding']]]]]]]) &gt; 0:
   cda:code codeSystemName='SNOMED CT' displayName='Finding' OK
</axsl:if>
<axsl:if test="cda:component[cda:structuredBody[cda:component[cda:section[cda:entry[cda:observation[cda:effectiveTime]]]]]]">In pattern cda:component[cda:structuredBody[cda:component[cda:section[cda:entry[cda:observation[cda:effectiveTime]]]]]]:
   cda:effectiveTime OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:component[cda:structuredBody[cda:component[cda:section[cda:entry[cda:observation[cda:effectiveTime]]]]]]"/>
<axsl:otherwise>In pattern cda:component[cda:structuredBody[cda:component[cda:section[cda:entry[cda:observation[cda:effectiveTime]]]]]]:
   ERR: cda:effectiveTime not found
</axsl:otherwise>
</axsl:choose>
<axsl:if test="count(cda:templateId[@root='2.16.840.1.113883.10' and @extension='IMPL_CDAR2_LEVEL1-2REF_US_I2_2005SEP'])=1">In pattern count(cda:templateId[@root='2.16.840.1.113883.10' and @extension='IMPL_CDAR2_LEVEL1-2REF_US_I2_2005SEP'])=1:
   cda:templateId tag @root and @extension OK
</axsl:if>
<axsl:choose>
<axsl:when test="count(cda:templateId[@root='2.16.840.1.113883.10' and @extension='IMPL_CDAR2_LEVEL1-2REF_US_I2_2005SEP'])=1"/>
<axsl:otherwise>In pattern count(cda:templateId[@root='2.16.840.1.113883.10' and @extension='IMPL_CDAR2_LEVEL1-2REF_US_I2_2005SEP'])=1:
   ERR: cda:templateId tag with root 2.16.840.1.113883.10 and extension 'IMPL_CDAR2_LEVEL1-2REF_US_I2_2005SEP' not found
</axsl:otherwise>
</axsl:choose>
<axsl:apply-templates mode="M3"/>
</axsl:template>
<axsl:template mode="M3" priority="-1" match="text()"/>
<axsl:template priority="-1" match="text()"/>
</axsl:stylesheet>
