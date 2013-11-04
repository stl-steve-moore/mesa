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
<axsl:template mode="M3" priority="4000" match="cda:realmCode">
<axsl:if test="@code='US'">In pattern @code='US':
   cda:realmCode OK
</axsl:if>
<axsl:choose>
<axsl:when test="@code='US'"/>
<axsl:otherwise>In pattern @code='US':
   ERR: cda:realmCode does not match 'US'
</axsl:otherwise>
</axsl:choose>
<axsl:apply-templates mode="M3"/>
</axsl:template>
<axsl:template mode="M3" priority="3999" match="cda:typeId">
<axsl:if test="@root='2.16.840.1.113883.1.3'">In pattern @root='2.16.840.1.113883.1.3':
   cda:typeId OK
</axsl:if>
<axsl:choose>
<axsl:when test="@root='2.16.840.1.113883.1.3'"/>
<axsl:otherwise>In pattern @root='2.16.840.1.113883.1.3':
   ERR: typeId does not match 2.16.840.1.113883.1.3
</axsl:otherwise>
</axsl:choose>
<axsl:apply-templates mode="M3"/>
</axsl:template>
<axsl:template mode="M3" priority="3998" match="cda:ClinicalDocument">
<axsl:if test="count(cda:templateId)=2">In pattern count(cda:templateId)=2:
   number of cda:templateId tags under cda:ClinicalDocument OK
</axsl:if>
<axsl:choose>
<axsl:when test="count(cda:templateId)=2"/>
<axsl:otherwise>In pattern count(cda:templateId)=2:
   ERR: There should be two (2) cda:templateId tags under cda:ClinicalDocument
</axsl:otherwise>
</axsl:choose>
<axsl:if test="count(cda:templateId[@root='1.3.6.1.4.1.19376.1.5.3.1'])=1">In pattern count(cda:templateId[@root='1.3.6.1.4.1.19376.1.5.3.1'])=1:
   cda:templateId tag @root OK
</axsl:if>
<axsl:choose>
<axsl:when test="count(cda:templateId[@root='1.3.6.1.4.1.19376.1.5.3.1']) &gt; 0"/>
<axsl:otherwise>In pattern count(cda:templateId[@root='1.3.6.1.4.1.19376.1.5.3.1']) &gt; 0:
   ERR: cda:templateId tag with root 1.3.6.1.4.1.19376.1.5.3.1 not found 
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:title">In pattern cda:title:
   cda:title OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:title"/>
<axsl:otherwise>In pattern cda:title:
   ERR: cda:title not found
</axsl:otherwise>
</axsl:choose>
<axsl:choose>
<axsl:when test="count(cda:code[@displayName='Discharge Summary']) &gt; 0"/>
<axsl:otherwise>In pattern count(cda:code[@displayName='Discharge Summary']) &gt; 0:
   ERR: no cda:code displayName matches 'Discharge Summary'
</axsl:otherwise>
</axsl:choose>
<axsl:apply-templates mode="M3"/>
</axsl:template>
<axsl:template mode="M3" priority="3997" match="cda:code">
<axsl:if test="parent::cda:ClinicalDocument and @displayName='Discharge Summary'">In pattern parent::cda:ClinicalDocument and @displayName='Discharge Summary':
   cda:code displayName OK
</axsl:if>
<axsl:apply-templates mode="M3"/>
</axsl:template>
<axsl:template mode="M3" priority="3996" match="cda:versionNumber">
<axsl:if test="@value='1'">In pattern @value='1':
   cda:versionNumber OK
</axsl:if>
<axsl:choose>
<axsl:when test="@value='1'"/>
<axsl:otherwise>In pattern @value='1':
   ERR: cda:versionNumber does not match '1'
</axsl:otherwise>
</axsl:choose>
<axsl:apply-templates mode="M3"/>
</axsl:template>
<axsl:template mode="M3" priority="-1" match="text()"/>
<axsl:template priority="-1" match="text()"/>
</axsl:stylesheet>
