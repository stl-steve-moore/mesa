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
<axsl:template mode="M3" priority="4000" match="cda:patientRole">
<axsl:if test="cda:addr[cda:streetAddressLine = '4525 Scott Ave']">In pattern cda:addr[cda:streetAddressLine = '4525 Scott Ave']:
   patient cda:streetAddressLine OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:addr[cda:streetAddressLine = '4525 Scott Ave']"/>
<axsl:otherwise>In pattern cda:addr[cda:streetAddressLine = '4525 Scott Ave']:
   ERR: patient cda:streetAddressLine does not match 4525 Scott Ave
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:addr[cda:city = 'St. Louis']">In pattern cda:addr[cda:city = 'St. Louis']:
   patient cda:city OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:addr[cda:city = 'St. Louis']"/>
<axsl:otherwise>In pattern cda:addr[cda:city = 'St. Louis']:
   ERR: patient cda:city does not match St. Louis
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:addr[cda:state = 'MO']">In pattern cda:addr[cda:state = 'MO']:
   patient cda:state OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:addr[cda:state = 'MO']"/>
<axsl:otherwise>In pattern cda:addr[cda:state = 'MO']:
   ERR: patient cda:state does not match MO
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:addr[cda:postalCode = '63110']">In pattern cda:addr[cda:postalCode = '63110']:
   patient cda:postalCode OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:addr[cda:postalCode = '63110']"/>
<axsl:otherwise>In pattern cda:addr[cda:postalCode = '63110']:
   ERR: patient cda:postalCode does not match 63110
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:telecom[@value = 'tel:314-555-1671']">In pattern cda:telecom[@value = 'tel:314-555-1671']:
   patient cda:telecom OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:telecom[@value = 'tel:314-555-1671']"/>
<axsl:otherwise>In pattern cda:telecom[@value = 'tel:314-555-1671']:
   ERR: patient cda:telecom does not match tel:314-555-1671
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:patient[cda:administrativeGenderCode[@code='F' and @codeSystem='2.16.840.1.113883.5.1']]">In pattern cda:patient[cda:administrativeGenderCode[@code='F' and @codeSystem='2.16.840.1.113883.5.1']]:
   cda:administrativeGenderCode OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:patient[cda:administrativeGenderCode[@code='F' and @codeSystem='2.16.840.1.113883.5.1']]"/>
<axsl:otherwise>In pattern cda:patient[cda:administrativeGenderCode[@code='F' and @codeSystem='2.16.840.1.113883.5.1']]:
   ERR: correct cda:administrativeGenderCode not found
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:patient[cda:birthTime[@value='19580204']]">In pattern cda:patient[cda:birthTime[@value='19580204']]:
   cda:birthTime OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:patient[cda:birthTime[@value='19580204']]"/>
<axsl:otherwise>In pattern cda:patient[cda:birthTime[@value='19580204']]:
   ERR: cda:birthTime does not match 19580204
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:providerOrganization[cda:name = 'Gateway Hospital']">In pattern cda:providerOrganization[cda:name = 'Gateway Hospital']:
   cda:providerOrganization name OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:providerOrganization[cda:name = 'Gateway Hospital']"/>
<axsl:otherwise>In pattern cda:providerOrganization[cda:name = 'Gateway Hospital']:
   ERR: cda:providerOrganization name does not match Gateway Hospital
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:providerOrganization[cda:addr[cda:streetAddressLine = '600 Euclid Ave']]">In pattern cda:providerOrganization[cda:addr[cda:streetAddressLine = '600 Euclid Ave']]:
   provider organization cda:streetAddressLine OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:providerOrganization[cda:addr[cda:streetAddressLine = '600 Euclid Ave']]"/>
<axsl:otherwise>In pattern cda:providerOrganization[cda:addr[cda:streetAddressLine = '600 Euclid Ave']]:
   ERR: provider organization cda:streetAddressLine does not match 600 Euclid Ave
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:providerOrganization[cda:addr[cda:city = 'St. Louis']]">In pattern cda:providerOrganization[cda:addr[cda:city = 'St. Louis']]:
   provider organization cda:city OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:providerOrganization[cda:addr[cda:city = 'St. Louis']]"/>
<axsl:otherwise>In pattern cda:providerOrganization[cda:addr[cda:city = 'St. Louis']]:
   ERR: provider organization cda:city does not match St. Louis
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:providerOrganization[cda:addr[cda:state = 'MO']]">In pattern cda:providerOrganization[cda:addr[cda:state = 'MO']]:
   provider organization cda:state OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:providerOrganization[cda:addr[cda:state = 'MO']]"/>
<axsl:otherwise>In pattern cda:providerOrganization[cda:addr[cda:state = 'MO']]:
   ERR: provider organization cda:state does not match MO
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:providerOrganization[cda:addr[cda:postalCode = '63110']]">In pattern cda:providerOrganization[cda:addr[cda:postalCode = '63110']]:
   provider organization cda:postalCode OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:providerOrganization[cda:addr[cda:postalCode = '63110']]"/>
<axsl:otherwise>In pattern cda:providerOrganization[cda:addr[cda:postalCode = '63110']]:
   ERR: provider organization cda:postalCode does not match 63110
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:providerOrganization[cda:addr[cda:country = 'USA']]">In pattern cda:providerOrganization[cda:addr[cda:country = 'USA']]:
   provider organization cda:country OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:providerOrganization[cda:addr[cda:country = 'USA']]"/>
<axsl:otherwise>In pattern cda:providerOrganization[cda:addr[cda:country = 'USA']]:
   ERR: provider organization cda:country does not match USA
</axsl:otherwise>
</axsl:choose>
<axsl:apply-templates mode="M3"/>
</axsl:template>
<axsl:template mode="M3" priority="3999" match="cda:custodian">
<axsl:if test="cda:assignedCustodian[cda:representedCustodianOrganization[cda:name = 'Gateway Hospital']]">In pattern cda:assignedCustodian[cda:representedCustodianOrganization[cda:name = 'Gateway Hospital']]:
   custodian cda:name OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:assignedCustodian[cda:representedCustodianOrganization[cda:name = 'Gateway Hospital']]"/>
<axsl:otherwise>In pattern cda:assignedCustodian[cda:representedCustodianOrganization[cda:name = 'Gateway Hospital']]:
   ERR: custodian cda:name does not match Gateway Hospital
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:assignedCustodian[cda:representedCustodianOrganization[cda:addr[cda:streetAddressLine = '600 Euclid Ave']]]">In pattern cda:assignedCustodian[cda:representedCustodianOrganization[cda:addr[cda:streetAddressLine = '600 Euclid Ave']]]:
   custodian cda:streetLAddressLine OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:assignedCustodian[cda:representedCustodianOrganization[cda:addr[cda:streetAddressLine = '600 Euclid Ave']]]"/>
<axsl:otherwise>In pattern cda:assignedCustodian[cda:representedCustodianOrganization[cda:addr[cda:streetAddressLine = '600 Euclid Ave']]]:
   ERR: custodian cda:streetAddressLine does not match 600 Euclid Ave
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:assignedCustodian[cda:representedCustodianOrganization[cda:addr[cda:city = 'St. Louis']]]">In pattern cda:assignedCustodian[cda:representedCustodianOrganization[cda:addr[cda:city = 'St. Louis']]]:
   custodian cda:city OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:assignedCustodian[cda:representedCustodianOrganization[cda:addr[cda:city = 'St. Louis']]]"/>
<axsl:otherwise>In pattern cda:assignedCustodian[cda:representedCustodianOrganization[cda:addr[cda:city = 'St. Louis']]]:
   ERR: custodian cda:city does not match St. Louis
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:assignedCustodian[cda:representedCustodianOrganization[cda:addr[cda:state = 'MO']]]">In pattern cda:assignedCustodian[cda:representedCustodianOrganization[cda:addr[cda:state = 'MO']]]:
   custodian cda:state OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:assignedCustodian[cda:representedCustodianOrganization[cda:addr[cda:state = 'MO']]]"/>
<axsl:otherwise>In pattern cda:assignedCustodian[cda:representedCustodianOrganization[cda:addr[cda:state = 'MO']]]:
   ERR: custodian cda:state does not match MO
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:assignedCustodian[cda:representedCustodianOrganization[cda:addr[cda:postalCode = '63110']]]">In pattern cda:assignedCustodian[cda:representedCustodianOrganization[cda:addr[cda:postalCode = '63110']]]:
   custodian cda:postalCode OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:assignedCustodian[cda:representedCustodianOrganization[cda:addr[cda:postalCode = '63110']]]"/>
<axsl:otherwise>In pattern cda:assignedCustodian[cda:representedCustodianOrganization[cda:addr[cda:postalCode = '63110']]]:
   ERR: custodian cda:postalCode does not match 63110
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:assignedCustodian[cda:representedCustodianOrganization[cda:addr[cda:country = 'USA']]]">In pattern cda:assignedCustodian[cda:representedCustodianOrganization[cda:addr[cda:country = 'USA']]]:
   custodian cda:country OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:assignedCustodian[cda:representedCustodianOrganization[cda:addr[cda:country = 'USA']]]"/>
<axsl:otherwise>In pattern cda:assignedCustodian[cda:representedCustodianOrganization[cda:addr[cda:country = 'USA']]]:
   ERR: custodian cda:country does not match USA
</axsl:otherwise>
</axsl:choose>
<axsl:apply-templates mode="M3"/>
</axsl:template>
<axsl:template mode="M3" priority="3998" match="cda:author">
<axsl:if test="cda:assignedAuthor[cda:addr[cda:streetAddressLine = '700 Euclid Ave']]">In pattern cda:assignedAuthor[cda:addr[cda:streetAddressLine = '700 Euclid Ave']]:
   author cda:streetAddressLine OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:assignedAuthor[cda:addr[cda:streetAddressLine = '700 Euclid Ave']]"/>
<axsl:otherwise>In pattern cda:assignedAuthor[cda:addr[cda:streetAddressLine = '700 Euclid Ave']]:
   ERR: author cda:streetAddressLine does not match 700 Euclid Ave
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:assignedAuthor[cda:addr[cda:city = 'St. Louis']]">In pattern cda:assignedAuthor[cda:addr[cda:city = 'St. Louis']]:
   author cda:city OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:assignedAuthor[cda:addr[cda:city = 'St. Louis']]"/>
<axsl:otherwise>In pattern cda:assignedAuthor[cda:addr[cda:city = 'St. Louis']]:
   ERR: author cda:city does not match St. Louis
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:assignedAuthor[cda:addr[cda:state = 'MO']]">In pattern cda:assignedAuthor[cda:addr[cda:state = 'MO']]:
   author cda:state OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:assignedAuthor[cda:addr[cda:state = 'MO']]"/>
<axsl:otherwise>In pattern cda:assignedAuthor[cda:addr[cda:state = 'MO']]:
   ERR: author cda:state does not match MO
</axsl:otherwise>
</axsl:choose>
<axsl:if test="cda:assignedAuthor[cda:addr[cda:country = 'USA']]">In pattern cda:assignedAuthor[cda:addr[cda:country = 'USA']]:
   author cda:country OK
</axsl:if>
<axsl:choose>
<axsl:when test="cda:assignedAuthor[cda:addr[cda:country = 'USA']]"/>
<axsl:otherwise>In pattern cda:assignedAuthor[cda:addr[cda:country = 'USA']]:
   ERR: author cda:country does not match USA 
</axsl:otherwise>
</axsl:choose>
<axsl:apply-templates mode="M3"/>
</axsl:template>
<axsl:template mode="M3" priority="-1" match="text()"/>
<axsl:template priority="-1" match="text()"/>
</axsl:stylesheet>
