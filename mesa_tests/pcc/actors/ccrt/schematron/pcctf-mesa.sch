<schema xmlns="http://www.ascc.net/xml/schematron" xmlns:cda="urn:hl7-org:v3">
  <title>Schematron schema for validating conformance to IMPL_CDAR2_LEVEL1-2REF_US_I3_2006JAN</title>
  <ns prefix="cda" uri="urn:hl7-org:v3"/>
  <ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.3'>
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.3"]'>
   <!-- Verify that the template id is used on the appropriate type of object -->
   <assert test='../cda:ClinicalDocument'>
     Error: The Referral Summary can only be used on Clinical Documents.
   </assert> 
   <!-- Verify that the parent templateId is also present. -->
   <assert test='cda:templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.1.2"]'>
     Error: The parent template identifier for Referral Summary is not present.
   </assert> 
   <!-- Verify the document type code -->
   <assert test='cda:code[@code = "34133-9"]'>
     Error: The document type code of a Referral Summary must be 34133-9
   </assert>
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'>
     Error: The document type code must come from the LOINC code 
     system (2.16.840.1.113883.6.1).
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.1"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Referral Summary must contain Reason for Referral.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.4"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Referral Summary must contain History Present Illness.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.6"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Referral Summary must contain Active Problems.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.19"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Referral Summary must contain Current Meds.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.13"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Referral Summary must contain Allergies.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.8"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Referral Summary should contain Resolved Problems.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.11"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Referral Summary should contain List of Surgeries.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.23"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Referral Summary should contain Immunizations.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.14"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Referral Summary should contain Family History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.16"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Referral Summary should contain Social History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.18"]'> 
     <!-- Note any missing optional elements -->
     Note: This Referral Summary does not contain Pertinent Review of Systems.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.25"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Referral Summary should contain Vital Signs.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.24"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Referral Summary should contain Physical Exam.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.27"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Referral Summary should contain Relevant Diagnostic Surgical 
     Procedures / Clinical Reports and Relevant Diagnostic Test and Reports.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3 
     (Lab, Imaging, EKG's, etc.) including links.
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.31"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Referral Summary should contain Plan of Care (new meds, labs, or x-rays ordered).
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.34"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Referral Summary should contain Advance Directives.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
   <assert test='.//cda:templateId[@root = ""]'> 
   -->
     <!-- Verify that all required data elements are present -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
     Error: A(n) Referral Summary must contain Patient Administrative Identifiers.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3 
     Handled by the Medical Documents Content Profile by reference to constraints in HL7 CRS.
   </assert> 
   -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
   <assert test='.//cda:templateId[@root = ""]'> 
   -->
     <!-- Alert on any missing required if known elements -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
     Warning: A(n) Referral Summary should contain Pertinent Insurance Information.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3 
     Refer to Appropriate Payers Section - TBD
   </assert> 
   -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
   <assert test='.//cda:templateId[@root = ""]'> 
   -->
     <!-- Alert on any missing required if known elements -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
     Warning: A(n) Referral Summary should contain Data needed for state and local
     referral forms, if different than above.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3 
     These are handed by including additional sections within the summary.
   </assert> 
   -->
 </rule>
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.4'>
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.4"]'>
   <!-- Verify that the template id is used on the appropriate type of object -->
   <assert test='../cda:ClinicalDocument'>
     Error: The Discharge Summary can only be used on Clinical Documents.
   </assert> 
   <!-- Verify that the parent templateId is also present. -->
   <assert test='cda:templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.1.2"]'>
     Error: The parent template identifier for Discharge Summary is not present.
   </assert> 
   <!-- Verify the document type code -->
   <assert test='cda:code[@code = "18842-5"]'>
     Error: The document type code of a Discharge Summary must be 18842-5
   </assert>
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'>
     Error: The document type code must come from the LOINC code 
     system (2.16.840.1.113883.6.1).
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.6"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Discharge Summary must contain Active Problems.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.8"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Discharge Summary must contain Resolved Problems.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.7"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Discharge Summary must contain Discharge Diagnosis.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.3"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Discharge Summary must contain Admitting Diagnosis.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.21"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Discharge Summary should contain Selected Meds Administered.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.22"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Discharge Summary must contain Discharge Meds.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.20"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Discharge Summary should contain Admission Medications.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.13"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Discharge Summary must contain Allergies.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.5"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Discharge Summary must contain Hospital Course.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.34"]'> 
     <!-- Note any missing optional elements -->
     Note: This Discharge Summary does not contain Advance Directives.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.4"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Discharge Summary should contain History of Present Illness.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.17"]'> 
     <!-- Note any missing optional elements -->
     Note: This Discharge Summary does not contain Functional Status.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.18"]'> 
     <!-- Note any missing optional elements -->
     Note: This Discharge Summary does not contain Review of Systems.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.24"]'> 
     <!-- Note any missing optional elements -->
     Note: This Discharge Summary does not contain Physical Examination.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.25"]'> 
     <!-- Note any missing optional elements -->
     Note: This Discharge Summary does not contain Vital Signs.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.29"]'> 
     <!-- Note any missing optional elements -->
     Note: This Discharge Summary does not contain Discharge Procedures Tests, Reports.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.31"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Discharge Summary must contain Plan of Care.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.33"]'> 
     <!-- Note any missing optional elements -->
     Note: This Discharge Summary does not contain Discharge Diet.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.4
   </assert> 
 </rule>
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.5.3.1'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.5.3.1"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Hazardous Working Conditions can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10161-8"]'> 
     Error: The section type code of a Hazardous Working Conditions must be 10161-8 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code of a Hazardous Working Conditions must come from the LOINC code  
     system (2.16.840.1.113883.6.1). 
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.5.3.2'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.5.3.2"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Coded Vital Signs can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='cda:templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.3.25"]'> 
     Error: The parent template identifier for Coded Vital Signs is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "8716-3"]'> 
     Error: The section type code of a Coded Vital Signs must be 8716-3 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Coded Vital Signs
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.1"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Coded Vital Signs must contain Vital Signs Organizer.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5.3.2
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.5.3.3'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.5.3.3"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Encounter Histories can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='cda:templateId[@root="2.16.840.1.113883.10.20.1.3"]'> 
     Error: The parent template identifier for Encounter Histories is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "46240-8"]'> 
     Error: The section type code of a Encounter Histories must be 46240-8 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Encounter Histories
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.14"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Encounter Histories must contain Encounters.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5.3.3
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.5.3.4'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.5.3.4"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Pregnancy History can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10162-6"]'> 
     Error: The section type code of a Pregnancy History must be 10162-6 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Pregnancy History
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.5"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Pregnancy History must contain Pregnancy Observation .
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5.3.4
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.5.3.5'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.5.3.5"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Medical Devices can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='cda:templateId[@root="2.16.840.1.113883.10.20.1.7"]'> 
     Error: The parent template identifier for Medical Devices is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "46264-8"]'> 
     Error: The section type code of a Medical Devices must be 46264-8 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Medical Devices
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.5.3.6'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.5.3.6"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Foreign Travel can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10182-4"]'> 
     Error: The section type code of a Foreign Travel must be 10182-4 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Foreign Travel
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.5.3.7'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.5.3.7"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Payers can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='cda:templateId[@root="2.16.840.1.113883.10.20.1.9"]'> 
     Error: The parent template identifier for Payers is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "48768-6"]'> 
     Error: The section type code of a Payers must be 48768-6 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Payers
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.17"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Payers should contain Coverage Entry.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5.3.7
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.5'>
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.5"]'>
   <!-- Verify that the template id is used on the appropriate type of object -->
   <assert test='../cda:ClinicalDocument'>
     Error: The PHR Extract can only be used on Clinical Documents.
   </assert> 
   <!-- Verify that the parent templateId is also present. -->
   <assert test='cda:templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.1.2"]'>
     Error: The parent template identifier for PHR Extract is not present.
   </assert> 
   <!-- Verify the document type code -->
   <assert test='cda:code[@code = "34133-9"]'>
     Error: The document type code of a PHR Extract must be 34133-9
   </assert>
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'>
     Error: The document type code must come from the LOINC code 
     system (2.16.840.1.113883.6.1).
   </assert> 
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
   <assert test='.//cda:templateId[@root = ""]'> 
   -->
     <!-- Verify that all required data elements are present -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
     Error: A(n) PHR Extract must contain Personal Information.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5 
     See Personal Information
   </assert> 
   -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
   <assert test='.//cda:templateId[@root = ""]'> 
   -->
     <!-- Verify that all required data elements are present -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
     Error: A(n) PHR Extract must contain Name.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5 
     See Personal Information
   </assert> 
   -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
   <assert test='.//cda:templateId[@root = ""]'> 
   -->
     <!-- Alert on any missing required if known elements -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
     Warning: A(n) PHR Extract should contain Address.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5 
     See Personal Information
   </assert> 
   -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
   <assert test='.//cda:templateId[@root = ""]'> 
   -->
     <!-- Alert on any missing required if known elements -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
     Warning: A(n) PHR Extract should contain Contact Information.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5 
     See Personal Information
   </assert> 
   -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
   <assert test='.//cda:templateId[@root = ""]'> 
   -->
     <!-- Alert on any missing required if known elements -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
     Warning: A(n) PHR Extract should contain Personal Identification Information.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5 
     See Personal Information
   </assert> 
   -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
   <assert test='.//cda:templateId[@root = ""]'> 
   -->
     <!-- Verify that all required data elements are present -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
     Error: A(n) PHR Extract must contain Gender.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5 
     See Personal Information
   </assert> 
   -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
   <assert test='.//cda:templateId[@root = ""]'> 
   -->
     <!-- Alert on any missing required if known elements -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
     Warning: A(n) PHR Extract should contain Date of Birth.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5 
     See Personal Information
   </assert> 
   -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
   <assert test='.//cda:templateId[@root = ""]'> 
   -->
     <!-- Alert on any missing required if known elements -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
     Warning: A(n) PHR Extract should contain Marital Status.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5 
     See Personal Information
   </assert> 
   -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
   <assert test='.//cda:templateId[@root = ""]'> 
   -->
     <!-- Note any missing optional elements -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
     Note: This PHR Extract does not contain Race.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5 
     See Personal Information
   </assert> 
   -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
   <assert test='.//cda:templateId[@root = ""]'> 
   -->
     <!-- Note any missing optional elements -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
     Note: This PHR Extract does not contain Ethnicity.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5 
     See Personal Information
   </assert> 
   -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
   <assert test='.//cda:templateId[@root = ""]'> 
   -->
     <!-- Note any missing optional elements -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
     Note: This PHR Extract does not contain (Religious Affiliation[2]).
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5 
     See Personal Information
   </assert> 
   -->
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.2.1"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) PHR Extract should contain Languages Spoken.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.2.2"]'> 
     <!-- Note any missing optional elements -->
     Note: This PHR Extract does not contain Employer and School Contacts.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.5.3.1"]'> 
     <!-- Note any missing optional elements -->
     Note: This PHR Extract does not contain Hazardous Working Conditions.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.2.4"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) PHR Extract should contain Patient Contacts.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.2.3"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) PHR Extract must contain Healthcare Providers.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.5.3.7"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) PHR Extract should contain Insurance Providers.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.2.3"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) PHR Extract should contain Pharamacy.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.34"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) PHR Extract should contain Legal Documents and Medical Directives.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.13"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) PHR Extract must contain Allergies and Drug Sensitivities.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.8"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) PHR Extract must contain Conditions.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.6"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) PHR Extract must contain Conditions (cont).
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.12"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) PHR Extract should contain Surgeries.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.19"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) PHR Extract must contain Medications – Prescription and Non-Prescription.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.23"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) PHR Extract should contain Immunizations.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.5.3.3"]'> 
     <!-- Note any missing optional elements -->
     Note: This PHR Extract does not contain Doctor Visits / Last Physical or Checkup.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.5.3.3"]'> 
     <!-- Note any missing optional elements -->
     Note: This PHR Extract does not contain Hospitalizations.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.5.3.3"]'> 
     <!-- Note any missing optional elements -->
     Note: This PHR Extract does not contain Other Healthcare Visits.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.28"]'> 
     <!-- Note any missing optional elements -->
     Note: This PHR Extract does not contain Clinical Tests / Blood Type.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.5.3.4"]'> 
     <!-- Note any missing optional elements -->
     Note: This PHR Extract does not contain Pregnancies.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.5.3.5"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) PHR Extract should contain Medical Devices.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.15"]'> 
     <!-- Note any missing optional elements -->
     Note: This PHR Extract does not contain Family Member History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.5.3.6"]'> 
     <!-- Note any missing optional elements -->
     Note: This PHR Extract does not contain Foreign Travel.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.5
   </assert> 
 </rule>
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.7'>
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.7"]'>
   <!-- Verify that the template id is used on the appropriate type of object -->
   <assert test='../cda:ClinicalDocument'>
     Error: The Consent to Share Information can only be used on Clinical Documents.
   </assert> 
   <!-- Verify that the parent templateId is also present. -->
   <assert test='cda:templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.1.1"]'>
     Error: The parent template identifier for Consent to Share Information is not present.
   </assert> 
   <!-- Verify the document type code -->
   <assert test='cda:code[@code = "{{{LOINC}}}"]'>
     Error: The document type code of a Consent to Share Information must be {{{LOINC}}}
   </assert>
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'>
     Error: The document type code must come from the LOINC code 
     system (2.16.840.1.113883.6.1).
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.2.6"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Consent to Share Information must contain Consent Service Event.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.7 
     At least one, an possible more than one consent can be provided within the document.
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.2.5"]'> 
     <!-- Note any missing optional elements -->
     Note: This Consent to Share Information does not contain Authorization.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.7 
     Consents may also be protected under a sharing policity.
   </assert> 
 </rule>
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.1'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.1"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Proposed Procedure can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "29554-3"]'> 
     Error: The section type code of a Proposed Procedure must be 29554-3 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Proposed Procedure
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.19"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Proposed Procedure must contain Procedure Entry .
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.4"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Proposed Procedure must contain Reason for Procedure.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.3"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Proposed Procedure must contain Proposed Anesthesia.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.2"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Proposed Procedure should contain Expected Blood Loss.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.40"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Proposed Procedure should contain Procedure Care Plan.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.1
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.10'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.10"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Current Alcohol/Substance Abuse can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "18663-5"]'> 
     Error: The section type code of a Current Alcohol/Substance Abuse must be 18663-5 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Current Alcohol/Substance Abuse
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.12'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.12"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Transfusion History can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "TBD"]'> 
     Error: The section type code of a Transfusion History must be TBD 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Transfusion History
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.13'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.13"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Preprocedure Review of Systems can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.3.18"]'> 
     Error: The parent template identifier for Preprocedure Review of Systems is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10187-3"]'> 
     Error: The section type code of a Preprocedure Review of Systems must be 10187-3 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Preprocedure Review of Systems
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.46"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Preprocedure Review of Systems must contain History of Implanted Medical Devices.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.13
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.47"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Preprocedure Review of Systems should contain Pregnancy Status History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.13
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.14"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Preprocedure Review of Systems must contain Anesthesia Risk Review of Systems.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.13
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.14'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.14"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Anesthesia Risk Review of Systems can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.3.18"]'> 
     Error: The parent template identifier for Anesthesia Risk Review of Systems is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "TBD"]'> 
     Error: The section type code of a Anesthesia Risk Review of Systems must be TBD 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Anesthesia Risk Review of Systems
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.15'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.15"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Physical Exam can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='cda:templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.3.24"]'> 
     Error: The parent template identifier for Physical Exam is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "29545-1"]'> 
     Error: The section type code of a Physical Exam must be 29545-1 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Physical Exam
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.25"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Vital Signs.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15 
     Vital signs may be a subsection of the physical exam or they may stand alone
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.16"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain General Appearance.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.48"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Visible Implanted Medical Devices.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.17"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Integumentary System.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.18"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Head.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.19"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Eyes.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.20"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Ears, Nose, Mouth and Throat.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.21"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Ears.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.22"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Nose.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.23"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Mouth, Throat, and Teeth.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.24"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Neck.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.25"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Endocrine System.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.26"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Thorax and Lungs.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.27"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Chest Wall.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.28"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Breasts.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.29"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Heart.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.30"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Respiratory System.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.31"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Abdomen.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.32"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Lymphatic System.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.33"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Vessels.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.34"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Musculoskeletal System.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.35"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Neurologic System.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.36"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Genitalia.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.37"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Exam does not contain Rectum.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.15
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.16'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.16"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The General Appearance can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10210-3"]'> 
     Error: The section type code of a General Appearance must be 10210-3 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  General Appearance
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.17'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.17"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Integumentary System can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "29302-7"]'> 
     Error: The section type code of a Integumentary System must be 29302-7 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Integumentary Systems
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.18'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.18"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Head can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10199-8"]'> 
     Error: The section type code of a Head must be 10199-8 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Head
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.19'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.19"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Eyes can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10197-2"]'> 
     Error: The section type code of a Eyes must be 10197-2 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Eyes
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.2'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.2"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Expected Blood Loss can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "8717-1"]'> 
     Error: The section type code of a Expected Blood Loss must be 8717-1 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Expected Blood Loss
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Expected Blood Loss must contain Simple Observations.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.2
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.20'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.20"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Ears, Nose, Mouth and Throat can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11393-6"]'> 
     Error: The section type code of a Ears, Nose, Mouth and Throat must be 11393-6 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Ears, Nose, Mouth and Throat
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.21'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.21"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Ears can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10195-6"]'> 
     Error: The section type code of a Ears must be 10195-6 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Ears
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.22'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.22"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Nose can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10203-8"]'> 
     Error: The section type code of a Nose must be 10203-8 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Nose
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.23'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.23"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Mouth, Throat and Teeth can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10201-2"]'> 
     Error: The section type code of a Mouth, Throat and Teeth must be 10201-2 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Mouth, Throat and Teeth
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.24'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.24"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Neck can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11411-6"]'> 
     Error: The section type code of a Neck must be 11411-6 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Neck
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.25'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.25"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Endocrine System can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "29307-6"]'> 
     Error: The section type code of a Endocrine System must be 29307-6 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Endocrine System
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.26'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.26"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Thorax and Lungs can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10207-9"]'> 
     Error: The section type code of a Thorax and Lungs must be 10207-9 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Thorax and Lungs
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.27'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.27"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Chest Wall can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11392-8"]'> 
     Error: The section type code of a Chest Wall must be 11392-8 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Chest Wall
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.28'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.28"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Breast can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10193-1"]'> 
     Error: The section type code of a Breast must be 10193-1 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Breast
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.29'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.29"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Heart can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10200-4"]'> 
     Error: The section type code of a Heart must be 10200-4 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Heart
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.3'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.3"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Proposed Anesthesia can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10213-7"]'> 
     Error: The section type code of a Proposed Anesthesia must be 10213-7 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Proposed Anesthesia
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.19"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Proposed Anesthesia must contain Procedure Entry.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.3 
     The procedure entries shall be in INT mood.
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.30'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.30"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Respiratory System can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11412-4"]'> 
     Error: The section type code of a Respiratory System must be 11412-4 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Respitory System
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.31'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.31"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Abdomen can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10191-5"]'> 
     Error: The section type code of a Abdomen must be 10191-5 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Abdomen
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.32'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.32"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Lymphatic System can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11447-0"]'> 
     Error: The section type code of a Lymphatic System must be 11447-0 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Lymphatic System
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.33'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.33"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Vessels can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10208-7"]'> 
     Error: The section type code of a Vessels must be 10208-7 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Vessels
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.34'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.34"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Musculoskeletal System can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11410-8"]'> 
     Error: The section type code of a Musculoskeletal System must be 11410-8 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Musculoskeletal System
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.35'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.35"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Neurologic System can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10202-0"]'> 
     Error: The section type code of a Neurologic System must be 10202-0 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Neurologic System
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.36'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.36"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Genitalia can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11400-9"]'> 
     Error: The section type code of a Genitalia must be 11400-9 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Genitalia
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.37'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.37"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Rectum can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10205-3"]'> 
     Error: The section type code of a Rectum must be 10205-3 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Rectum
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.38'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.38"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Patient Education and Consents can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "34895-3"]'> 
     Error: The section type code of a Patient Education and Consents must be 34895-3 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Patient Education and Consents
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.39'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.39"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Patient Education and Consents can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.38"]'> 
     Error: The parent template identifier for Patient Education and Consents is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "34895-3"]'> 
     Error: The section type code of a Patient Education and Consents must be 34895-3 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Patient Education and Consents
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.19"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Patient Education and Consents must contain Procedure Entry.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.39 
     The procedures shall be in INT mood
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Patient Education and Consents should contain Simple Observations.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.39
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.4"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Patient Education and Consents should contain External References.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.39
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.4'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.4"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Reason for Procedure can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10217-8"]'> 
     Error: The section type code of a Reason for Procedure must be 10217-8 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Reason for Procedure
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.5"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Reason for Procedure should contain Conditions Entry.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.4
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.40'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.40"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Procedure Care Plan can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.3.31"]'> 
     Error: The parent template identifier for Procedure Care Plan is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "18776-5"]'> 
     Error: The section type code of a Procedure Care Plan must be 18776-5 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Procedure Care Plan
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.41'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.41"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Health Maintenance Care Plan Status Report can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.50"]'> 
     Error: The parent template identifier for Health Maintenance Care Plan Status Report is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "18776-5"]'> 
     Error: The section type code of a Health Maintenance Care Plan Status Report must be 18776-5 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Health Maintenance Care Plan Status Report
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.42'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.42"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Pre-procedure Impressions can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.3.6"]'> 
     Error: The parent template identifier for Pre-procedure Impressions is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "34895-3"]'> 
     Error: The section type code of a Pre-procedure Impressions must be 34895-3 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Pre-procedure Impressions
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.44"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Pre-procedure Impressions must contain Pre-procedure Risk Assessment.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.42
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.44'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.44"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Pre-procedure Risk Assessment can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.3.6"]'> 
     Error: The parent template identifier for Pre-procedure Risk Assessment is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11450-4"]'> 
     Error: The section type code of a Pre-procedure Risk Assessment must be 11450-4 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Pre-procedure Risk Assessment
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.5"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Pre-procedure Risk Assessment must contain Conditions Entry.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9.44
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.45'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.45"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Procedure Care Plan Status Report can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.40"]'> 
     Error: The parent template identifier for Procedure Care Plan Status Report is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "18776-5"]'> 
     Error: The section type code of a Procedure Care Plan Status Report must be 18776-5 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Procedure Care Plan Status Report
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.46'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.46"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Implanted Medical Device Review can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "TBD"]'> 
     Error: The section type code of a Implanted Medical Device Review must be TBD 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Medical Device Review
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.47'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.47"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Pregnancy Status Review can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "TBD"]'> 
     Error: The section type code of a Pregnancy Status Review must be TBD 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Pregnancy Status Review
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.48'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.48"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Visible Implanted Medical Devices can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "TBD"]'> 
     Error: The section type code of a Visible Implanted Medical Devices must be TBD 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Visible Implanted Medical Devices
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.5'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.5"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Pre-procedure Family Medical History can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.3.15"]'> 
     Error: The parent template identifier for Pre-procedure Family Medical History is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10157-6"]'> 
     Error: The section type code of a Pre-procedure Family Medical History must be 10157-6 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Pre-procedure Family Medical History
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.50'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.50"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Health Maintenance Care Plan can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.3.31"]'> 
     Error: The parent template identifier for Health Maintenance Care Plan is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "18776-5"]'> 
     Error: The section type code of a Health Maintenance Care Plan must be 18776-5 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Health Maintenace Care Plan
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9.8'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9.8"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The History of Tobacco Use can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11366-2"]'> 
     Error: The section type code of a History of Tobacco Use must be 11366-2 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  History of Tobacco Use
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.9'>
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.9"]'>
   <!-- Verify that the template id is used on the appropriate type of object -->
   <assert test='../cda:ClinicalDocument'>
     Error: The Preprocedure History and Physical can only be used on Clinical Documents.
   </assert> 
   <!-- Verify that the parent templateId is also present. -->
   <assert test='cda:templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.1.1"]'>
     Error: The parent template identifier for Preprocedure History and Physical is not present.
   </assert> 
   <!-- Verify the document type code -->
   <assert test='cda:code[@code = "{{{LOINC}}}"]'>
     Error: The document type code of a Preprocedure History and Physical must be {{{LOINC}}}
   </assert>
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'>
     Error: The document type code must come from the LOINC code 
     system (2.16.840.1.113883.6.1).
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.1"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Preprocedure History and Physical must contain Proposed Procedure: (coded procedure) includes:.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9 
     Content same as corresponding Op Note section except that this section describes 
     what is planned to happen instead of what happened.
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.4"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Preprocedure History and Physical must contain -Reason for Procedure: (coded diagnosis).
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9 
     Content same as corresponding Op Note section except that this section describes 
     what is planned to happen instead of what happened.
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.3"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Preprocedure History and Physical must contain -Proposed Anesthesia.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9 
     Content same as corresponding Op Note section except that this section describes 
     what is planned to happen instead of what happened.
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.2"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Preprocedure History and Physical should contain -Expected Blood Loss.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9 
     Content same as corresponding Op Note section except that this section describes 
     what is planned to happen instead of what happened.Needs narrative LOINC code
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.40"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Preprocedure History and Physical should contain -Procedure Care Plan.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9 
     Care Plan generated by the surgeon or surgical coordinator prior to the H&amp;P
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.4"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Preprocedure History and Physical must contain HPI—(free text leading up to procedure).
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.6"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Preprocedure History and Physical should contain Current Problem List.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9 
     Problem List (if known) is represented as current at beginning of H&amp;P encounter.
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.8"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Preprocedure History and Physical should contain Past Medical History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.11"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Preprocedure History and Physical must contain Past Surgical-Anesthesia History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.19"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Preprocedure History and Physical must contain Medication List.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.13"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Preprocedure History and Physical must contain Allergy List.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.23"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Preprocedure History and Physical should contain Immunizations.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.8"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Preprocedure History and Physical must contain History of Tobacco Use.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.10"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Preprocedure History and Physical must contain Current Alcohol/Substance Abuse.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.12"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Preprocedure History and Physical must contain Transfusion History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.5"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Preprocedure History and Physical must contain Pre-procedure Family History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.16"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Preprocedure History and Physical should contain Social History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.34"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Preprocedure History and Physical should contain Advance Directives.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.17"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Preprocedure History and Physical must contain Functional Capacity.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.13"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Preprocedure History and Physical must contain Review of Systems (specifically includes):.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.18"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Preprocedure History and Physical must contain   -General Review.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.46"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Preprocedure History and Physical should contain -Implanted Medical Devices.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.47"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Preprocedure History and Physical must contain -Pregnancy Status (if female).
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.14"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Preprocedure History and Physical must contain   -Anesthesia Review of Systems.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.15"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Preprocedure History and Physical must contain Physical Exam (specifically includes):.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.9.49"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Preprocedure History and Physical must contain -Vitals.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.16"]'> 
     <!-- Note any missing optional elements -->
     Note: This Preprocedure History and Physical does not contain -General Appearance.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.48"]'> 
     <!-- Note any missing optional elements -->
     Note: This Preprocedure History and Physical does not contain -Visible Implanted Medical Devices.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.17"]'> 
     <!-- Note any missing optional elements -->
     Note: This Preprocedure History and Physical does not contain -Integumentary System.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.18"]'> 
     <!-- Note any missing optional elements -->
     Note: This Preprocedure History and Physical does not contain -Head.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.19"]'> 
     <!-- Note any missing optional elements -->
     Note: This Preprocedure History and Physical does not contain -Eyes.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.20.1"]'> 
     <!-- Note any missing optional elements -->
     Note: This Preprocedure History and Physical does not contain -Ears, Nose, Mouth and Throat (may include):.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.21"]'> 
     <!-- Note any missing optional elements -->
     Note: This Preprocedure History and Physical does not contain --Ears.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.22"]'> 
     <!-- Note any missing optional elements -->
     Note: This Preprocedure History and Physical does not contain --Nose.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.23"]'> 
     <!-- Note any missing optional elements -->
     Note: This Preprocedure History and Physical does not contain --Mouth, Throat, and Teeth.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.24"]'> 
     <!-- Note any missing optional elements -->
     Note: This Preprocedure History and Physical does not contain -Neck.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.25"]'> 
     <!-- Note any missing optional elements -->
     Note: This Preprocedure History and Physical does not contain -Endocrine System.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.26.1"]'> 
     <!-- Note any missing optional elements -->
     Note: This Preprocedure History and Physical does not contain -Thorax and Lungs (may include):.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.27"]'> 
     <!-- Note any missing optional elements -->
     Note: This Preprocedure History and Physical does not contain --Chest Wall.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.9
   </assert> 
 </rule>
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.3'>
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.3"]'>
   <!-- Verify that the template id is used on the appropriate type of object -->
   <assert test='../cda:ClinicalDocument'>
     Error: The Referral Summary can only be used on Clinical Documents.
   </assert> 
   <!-- Verify that the parent templateId is also present. -->
   <assert test='cda:templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.1.2"]'>
     Error: The parent template identifier for Referral Summary is not present.
   </assert> 
   <!-- Verify the document type code -->
   <assert test='cda:code[@code = "34133-9"]'>
     Error: The document type code of a Referral Summary must be 34133-9
   </assert>
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'>
     Error: The document type code must come from the LOINC code 
     system (2.16.840.1.113883.6.1).
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.1"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Referral Summary must contain Reason for Referral.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.4"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Referral Summary must contain History Present Illness.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.6"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Referral Summary must contain Active Problems.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.19"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Referral Summary must contain Current Meds.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.13"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Referral Summary must contain Allergies.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.8"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Referral Summary should contain Resolved Problems.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.11"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Referral Summary should contain List of Surgeries.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.23"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Referral Summary should contain Immunizations.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.14"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Referral Summary should contain Family History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.16"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Referral Summary should contain Social History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.18"]'> 
     <!-- Note any missing optional elements -->
     Note: This Referral Summary does not contain Pertinent Review of Systems.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.25"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Referral Summary should contain Vital Signs.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.24"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Referral Summary should contain Physical Exam.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.27"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Referral Summary should contain Relevant Diagnostic Surgical
     Procedures / Clinical Reports and Relevant Diagnostic Test and Reports.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3 
     (Lab, Imaging, EKG's, etc.) including links.
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.31"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Referral Summary should contain Plan of Care (new meds, labs, or x-rays ordered).
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.34"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Referral Summary should contain Advance Directives.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3
   </assert> 
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
   <assert test='.//cda:templateId[@root = ""]'> 
   -->
     <!-- Verify that all required data elements are present -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
     Error: A(n) Referral Summary must contain Patient Administrative Identifiers.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3 
     Handled by the Medical Documents Content Profile by reference to constraints in HL7 CRS.
   </assert> 
   -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
   <assert test='.//cda:templateId[@root = ""]'> 
   -->
     <!-- Alert on any missing required if known elements -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
     Warning: A(n) Referral Summary should contain Pertinent Insurance Information.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3 
     Refer to Appropriate Payers Section - TBD
   </assert> 
   -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
   <assert test='.//cda:templateId[@root = ""]'> 
   -->
     <!-- Alert on any missing required if known elements -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
     Warning: A(n) Referral Summary should contain Data needed for state and local
     referral forms, if different than above.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.3 
     These are handed by including additional sections within the summary.
   </assert> 
   -->
 </rule>
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.1'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.1"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Reason for Referral can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "42349-1"]'> 
     Error: The section type code of a Reason for Referral must be 42349-1 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Reason for Referral
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.10'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.10"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The History of Inpatient Visits can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11336-5"]'> 
     Error: The section type code of a History of Inpatient Visits must be 11336-5 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  History of Inpatient Visits
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.11'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.11"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The List of Surgeries can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='cda:templateId[@root="2.16.840.1.113883.10.20.1.12"]'> 
   <!-- <assert test='templateId[@root="2.16.840.1.113883.10.20.1.12"]'>  -->
     Error: The parent template identifier for List of Surgeries is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "47519-4"]'> 
     Error: The section type code of a List of Surgeries must be 47519-4 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Llist of Surgeries
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.12'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.12"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Coded List of Surgeries can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='cda:templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.3.11"]'> 
     Error: The parent template identifier for Coded List of Surgeries is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "47519-4"]'> 
     Error: The section type code of a Coded List of Surgeries must be 47519-4 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Coded List of Surgeries
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.19"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Coded List of Surgeries must contain Procedure Entry .
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.3.12
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.4"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Coded List of Surgeries should contain References Entry.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.3.12
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.13'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.13"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Allergies and Other Adverse Reactions can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='cda:templateId[@root="2.16.840.1.113883.10.20.1.2"]'> 
     Error: The parent template identifier for Allergies and Other Adverse Reactions is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "48765-2"]'> 
     Error: The section type code of a Allergies and Other Adverse Reactions must be 48765-2 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Allergies and Other Adverse Reactions
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.5.3"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Allergies and Other Adverse Reactions must contain Allergies and Intolerances Concern.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.3.13
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.14'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.14"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Family Medical History can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='cda:templateId[@root="2.16.840.1.113883.10.20.1.4"]'> 
     Error: The parent template identifier for Family Medical History is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10157-6"]'> 
     Error: The section type code of a Family Medical History must be 10157-6 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Family Medical History
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.15'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.15"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Coded Family Medical History can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='cda:templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.3.14"]'> 
     Error: The parent template identifier for Coded Family Medical History is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10157-6"]'> 
     Error: The section type code of a Coded Family Medical History must be 10157-6 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Coded Family Medical History
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.15"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Coded Family Medical History must contain Family History Organizer.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.3.15
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.16'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.16"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Social History can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='cda:templateId[@root="2.16.840.1.113883.10.20.1.15"]'> 
     Error: The parent template identifier for Social History is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "29762-2"]'> 
     Error: The section type code of a Social History must be 29762-2 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Social History
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.17'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.17"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Functional Status can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='cda:templateId[@root="2.16.840.1.113883.10.20.1.5"]'> 
     Error: The parent template identifier for Functional Status is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "47420-5"]'> 
     Error: The section type code of a Functional Status must be 47420-5 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Functional Status
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.18'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.18"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Review of Systems can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10187-3"]'> 
     Error: The section type code of a Review of Systems must be 10187-3 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1).  Review of Systems
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.19'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.19"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Medications can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='cda:templateId[@root="2.16.840.1.113883.10.20.1.8"]'> 
     Error: The parent template identifier for Medications is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10160-0"]'> 
     Error: The section type code of a Medications must be 10160-0 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Medications
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.7"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Medications must contain Medications.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.3.19
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.2'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.2"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Coded Reason for Referral can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.3.1"]'> 
     Error: The parent template identifier for Coded Reason for Referral is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "42349-1"]'> 
     Error: The section type code of a Coded Reason for Referral must be 42349-1 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Coded Reason for Referral
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Coded Reason for Referral must contain Simple Observations.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.3.2
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.5"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Coded Reason for Referral must contain Conditions Entry.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.3.2
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.20'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.20"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Admission Medication History can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "42346-7"]'> 
     Error: The section type code of a Admission Medication History must be 42346-7 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Admission Medication History
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.7"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Admission Medication History must contain Medications.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.3.20
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.21'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.21"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Medications Administered can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "18610-6"]'> 
     Error: The section type code of a Medications Administered must be 18610-6 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Medications Administered
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.7"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Medications Administered must contain Medications.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.3.21
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.22'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.22"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Hospital Discharge Medications can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10183-2"]'> 
     Error: The section type code of a Hospital Discharge Medications must be 10183-2 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Hospital Discharge Medications
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.7"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Hospital Discharge Medications must contain Medications.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.3.22
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.23'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.23"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Immunizations can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='cda:templateId[@root="2.16.840.1.113883.10.20.1.6"]'> 
     Error: The parent template identifier for Immunizations is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11369-6"]'> 
     Error: The section type code of a Immunizations must be 11369-6 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Immunizations
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.12"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Immunizations must contain Immunization.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.3.23
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.24'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.24"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Physical Exam can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "29545-1"]'> 
     Error: The section type code of a Physical Exam must be 29545-1 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Physical Exam
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.25'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.25"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Vital Signs can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='cda:templateId[@root="2.16.840.1.113883.10.20.1.16"]'> 
     Error: The parent template identifier for Vital Signs is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "8716-3"]'> 
     Error: The section type code of a Vital Signs must be 8716-3 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Vital Signs
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.26'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.26"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Hospital Discharge Physical Exam can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10184-0"]'> 
     Error: The section type code of a Hospital Discharge Physical Exam must be 10184-0 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Hospital Discharge Physical Exam
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.27'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.27"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Results can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "30954-2"]'> 
     Error: The section type code of a Results must be 30954-2 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Results
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.28'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.28"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Coded Results can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "30954-2"]'> 
     Error: The section type code of a Coded Results must be 30954-2 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Coded Results
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.16"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Coded Results must contain Procedure Entry.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.3.28
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.4"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Coded Results should contain References Entry.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.3.28
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.29'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.29"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Hospital Studies Summary can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11493-4"]'> 
     Error: The section type code of a Hospital Studies Summary must be 11493-4 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Hospital Studies Summary
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.3'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.3"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Hospital Admission Diagnosis can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "46241-6"]'> 
     Error: The section type code of a Hospital Admission Diagnosis must be 46241-6 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Hospital Admission Diagnosis
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.5"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Hospital Admission Diagnosis must contain Conditions Entry.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.3.3
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.30'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.30"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Coded Hospital Studies Summary can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.3.29"]'> 
     Error: The parent template identifier for Coded Hospital Studies Summary is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11493-4"]'> 
     Error: The section type code of a Coded Hospital Studies Summary must be 11493-4 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Coded Hospital Studies Summary
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.16"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Coded Hospital Studies Summary must contain Procedure Entry.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.3.30
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.4"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Coded Hospital Studies Summary should contain References Entry.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.3.30
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.31'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.31"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Care Plan can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "18776-5"]'> 
     Error: The section type code of a Care Plan must be 18776-5 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Care Plan
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.32'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.32"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Discharge Disposition can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "18776-5"]'> 
     Error: The section type code of a Discharge Disposition must be 18776-5 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Discharge Disposition
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.33'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.33"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Discharge Diet can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "42344-2"]'> 
     Error: The section type code of a Discharge Diet must be 42344-2 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Discharge Diet
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.34'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.34"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Advance Directives can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='cda:templateId[@root="2.16.840.1.113883.10.20.1.1"]'> 
     Error: The parent template identifier for Advance Directives is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "42348-3"]'> 
     Error: The section type code of a Advance Directives must be 42348-3 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Advance Directives
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.35'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.35"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Coded Advance Directives can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.3.34"]'> 
     Error: The parent template identifier for Coded Advance Directives is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "42348-3"]'> 
     Error: The section type code of a Coded Advance Directives must be 42348-3 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Coded Advance Directives
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.13.7"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Coded Advance Directives should contain Advance Directive Observation.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.3.35
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.4'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.4"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The History of Present Illness can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10164-2"]'> 
     Error: The section type code of a History of Present Illness must be 10164-2 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). History of Present Illness
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.5'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.5"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Hospital Course can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "8648-8"]'> 
     Error: The section type code of a Hospital Course must be 8648-8 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Hospital Course
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.6'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.6"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Active Problems can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='cda:templateId[@root="2.16.840.1.113883.10.20.1.11"]'> 
     Error: The parent template identifier for Active Problems is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11450-4"]'> 
     Error: The section type code of a Active Problems must be 11450-4 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Active Problems
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.5.2"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Active Problems must contain Problem Concern Entry.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.3.6
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.7'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.7"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Discharge Diagnosis can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11535-2"]'> 
     Error: The section type code of a Discharge Diagnosis must be 11535-2 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Discharge Diagnosis
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.5.2"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Discharge Diagnosis must contain Problem Concern Entry.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.3.7
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.8'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.8"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Resolved Problems can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11348-0"]'> 
     Error: The section type code of a Resolved Problems must be 11348-0 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Resolved Problems
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.5.2"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Resolved Problems must contain Problem Concern Entry.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.3.8
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.3.9'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.3.9"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The History of Outpatient Visits can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11346-4"]'> 
     Error: The section type code of a History of Outpatient Visits must be 11346-4 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). History of Outpatient Visits
   </assert> 
 </rule> 
</pattern>
  <pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.10.3.1'> 
   <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.10.3.1"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Care Plan can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.3.31"]'> 
     Error: The parent template identifier for Care Plan is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "18776-5"]'> 
     Error: The section type code of a Care Plan must be 18776-5 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Care Plan
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.10.4.2"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Care Plan should contain Intended Encounter Disposition.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10.3.1 
     This required entry describes the expected disposition of the patient 
     after the emergency department encounter has been completed.
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.10.3.2"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Care Plan must contain Transport Mode.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10.3.1 
     This required entry describes the expected disposition of the patient after 
     the emergency department encounter has been completed.
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.10.3.2'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.10.3.2"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Transport Mode can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11459-5"]'> 
     Error: The section type code of a Transport Mode must be 11459-5 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Transport Mode
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.10.4.1"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Transport Mode must contain Transport.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10.3.2 
     This entry provides coded values giving the mode and time of departure or 
     arrival of the patient to a facility.
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.10'>
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.10"]'>
   <!-- Verify that the template id is used on the appropriate type of object -->
   <assert test='../cda:ClinicalDocument'>
     Error: The Emergency Department Referral can only be used on Clinical Documents.
   </assert> 
   <!-- Verify that the parent templateId is also present. -->
   <assert test='cda:templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.1.3"]'>
     Error: The parent template identifier for Emergency Department Referral is not present.
   </assert> 
   <!-- Verify the document type code -->
   <assert test='cda:code[@code = "34133-9"]'>
     Error: The document type code of a Emergency Department Referral must be 34133-9
   </assert>
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'>
     Error: The document type code must come from the LOINC code 
     system (2.16.840.1.113883.6.1).
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.1"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Emergency Department Referral must contain Reason for Referral.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.4"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Emergency Department Referral must contain History Present Illness.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.6"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Emergency Department Referral must contain Active Problems.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.19"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Emergency Department Referral must contain Current Meds.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.13"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Emergency Department Referral must contain Allergies.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.8"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Emergency Department Referral should contain Resolved Problems.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.11"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Emergency Department Referral should contain List of Surgeries.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.23"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Emergency Department Referral should contain Immunizations.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.14"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Emergency Department Referral should contain Family History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.16"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Emergency Department Referral should contain Social History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.18"]'> 
     <!-- Note any missing optional elements -->
     Note: This Emergency Department Referral does not contain Pertinent Review of Systems.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.25"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Emergency Department Referral should contain Vital Signs.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.24"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Emergency Department Referral should contain Physical Exam.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.27"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Emergency Department Referral should contain Relevant Diagnostic 
     Results and/or Clinical Reports.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10 
     Includes Diagnostic Surgical Procedures, Clinical Reports and Diagnostic Tests 
     and Results (Lab, Imaging, EKG’s, etc.) including links to relevant documents.
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.31"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Emergency Department Referral should contain Care Plan.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10 
     (new meds, labs, or x-rays ordered)
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.10.3.2"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Emergency Department Referral must contain Mode of Transport to the 
     Emergency Department(includes ETA) .
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.10"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Emergency Department Referral should contain Proposed ED Disposition.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.34"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Emergency Department Referral must contain Advance Directives.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10 
     The availability of information about Advance Directives must provided.  A common 
     concern among ED providers is over situations where patients presented to the ED 
     require extensive resuscitative efforts, only later to discover that the patient 
     had a DNR order.
   </assert> 
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
   <assert test='.//cda:templateId[@root = ""]'> 
   -->
     <!-- Verify that all required data elements are present -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
     Error: A(n) Emergency Department Referral must contain Patient Administrative Identifiers.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10 
     These are handed by the Medical Documents Content Profile by reference to constraints in HL7 CRS.
   </assert> 
   -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
   <assert test='.//cda:templateId[@root = ""]'> 
   -->
     <!-- Alert on any missing required if known elements -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
     Warning: A(n) Emergency Department Referral should contain Pertinent Insurance Information.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10
   </assert> 
   -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
   <assert test='.//cda:templateId[@root = ""]'> 
   -->
     <!-- Alert on any missing required if known elements -->
   <!-- Removed SMM 2007.10.30 This needs to be repaired by Keith Boone 
     Warning: A(n) Emergency Department Referral should contain Data needed for state and 
     local referral forms, if different than above.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.10 
     These are handed by including additional sections within the summary.
   </assert> 
   -->
 </rule>
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.11.2.2.1'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.11.2.2.1"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Estimated Due Dates Section can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "(xx-edd-section)"]'> 
     Error: The section type code of a Estimated Due Dates Section must be (xx-edd-section) 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Estimated Due Dates Section
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.11.2.3.1"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Estimated Due Dates Section must contain Estimated Due Date Observation.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.11.2.2.1 
     This is a simple observation to represent the estimated due date with a supporting 
     observation or observations that state the method used and date implied by that 
     method. If one observation is present, then it is to be interpreted as the initial 
     EDD. If the initial observation dates indicate the EDD is within  the 18 to 20 weeks
     completed gestation, that observation will also populate the 18-20 week update.  If 
     the initial observation indicates an EDD of more than 20 weeks EGA, then no value will
     be placed in the 18-20 week update field.
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.11.2.2.2'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.11.2.2.2"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Visit Summary can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "(xx-acog-visit-sum-section)"]'> 
     Error: The section type code of a Visit Summary must be (xx-acog-visit-sum-section) 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Visit Summary
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.13"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Visit Summary must contain Simple Observation.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.11.2.2.2 
     The flowsheet contains one simple observation to represent the Prepregancy Weight.  
     This observation SHALL be valued with the LOINC code 8348-5, 
     BODY WEIGHT^PRE PREGNANCY-MASS-PT-QN-MEASURED.  The value SHALL be of type PQ.  
     The units may be either "lb_av" or "kg".
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.11.2.3.2"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Visit Summary must contain Antepartum Flowsheet Panel.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.11.2.2.2 
     Other entries on the flowsheet are "batteries" which represent a single visit.
   </assert> 
   <assert test='.//cda:observation/cda:code[@code="8348-5"]'>
     Error: The Visit Summary must have at least one simple observation with the LOINC
     code 8348-5 to represent the prepregnancy weight.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.11.2.2.2
   </assert>
   <assert test='.//cda:observation[cda:code/@code="8348-5"]/cda:value[@unit="kg" or @unit="lb_av"]'>
     Error: The prepregnancy weight shall record the units in kg or lbs
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.11.2.2.2
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.11.2'>
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.11.2"]'>
   <!-- Verify that the template id is used on the appropriate type of object -->
   <assert test='../cda:ClinicalDocument'>
     Error: The Antepartum Summary can only be used on Clinical Documents.
   </assert> 
   <!-- Verify that the parent templateId is also present. -->
   <assert test='cda:templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.1.2"]'>
     Error: The parent template identifier for Antepartum Summary is not present.
   </assert> 
   <!-- Verify the document type code -->
   <assert test='cda:code[@code = "{{{LOINC}}}"]'>
     Error: The document type code of a Antepartum Summary must be {{{LOINC}}}
   </assert>
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'>
     Error: The document type code must come from the LOINC code 
     system (2.16.840.1.113883.6.1).
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.13"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Antepartum Summary must contain Allergies.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.11.2 
     This section is the same as for Medical Summary, however it SHALL include one 
     observation of Latex Allergy which may be negated through the negationInd attribute.
     Latex Allergy is particularly relevant for Obstetrics because of the frequency of 
     vaginal exams that might involve the use of latex gloves.  The observation value 
     code for Latex Allergy is '300916003'.  The codeSystem is '2.16.840.1.113883.6.96'.
     The codeSystemName is 'SNOMED CT'
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.34"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Antepartum Summary must contain Advance Directives.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.11.2 
     APS includes an explicit check of patients preference for blood transfusion because
     the risk of massive hemorrhage during delivery is much higher.  This observation SHALL
     be recorded in the Advance Directives section.  APS Form C documents SHALL include a 
     simple observation of "blood transfusion acceptable?" The observation value for this 
     observation is '(xx-bld-transf-ok)'.  The codeSystem is '2.16.840.1.113883.6.1'.  
     The codeSystemName is 'LOINC'
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.31"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Antepartum Summary must contain Plan of Care.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.11.2 
     APS forms SHOULD include an observation stating if an anesthesia consult is planned.  
     When present, the observation value for this observation is '(xx-anest-cons-pland)'.  
     The codeSystem is '2.16.840.1.113883.6.1'.  The codeSystemName is 'LOINC'.  If the type
     of anesthesia planned is known, systems SHOULD include an observation to represent that
     data using the LOINC code '(xx-type-of-anesth-pland)' with a CD value including one of
     the following values: ( General | Epidural | Spinal ) or a Null flavor to represent
     unknown or not listed.
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.19"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Antepartum Summary must contain Medications.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.11.2 
     Medications should include start and stop date if known.
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.6"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Antepartum Summary must contain Problems.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.11.2 
     Related Plans should be included in the Plan of Care section.
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.11.2.2.1"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Antepartum Summary must contain Estimated Delivery Dates.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.11.2
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.11.2.2.2"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Antepartum Summary must contain Antepartum Visit Summary Flowsheet.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.11.2
   </assert> 
   <assert test="cda:entry/cda:observation/cda:value[@code='300916003']">
     Antepartum Summary Requires an observation of Latex Allergy to be
     asserted.  This may be negated via the negationInd attribute.
   </assert>
   <assert test="cda:entry/cda:observation/cda:value[@code='(xx-bld-transf-ok)']">
     Antepartum Summary Requires an observation of blood transfusion
     acceptability to be asserted.  This may be negated via the negationInd attribute.
   </assert>
   <assert test="cda:entry/cda:observation/cda:value[@code='(xx-anest-cons-pland)']">
     Antepartum Summary Requires an observation of anesthesia consult 
     planned to be asserted.  This may be negated via the negationInd attribute.
   </assert> 
 </rule>
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.12.2.1'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.12.2.1"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Coded Functional Status Assessment can only be used on sections. 
   </assert> 
   <!-- Verify that the parent templateId is also present. --> 
   <assert test='cda:templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.3.17"]'> 
     Error: The parent template identifier for Coded Functional Status Assessment is not present. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "47420-5"]'> 
     Error: The section type code of a Coded Functional Status Assessment must be 47420-5 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Coded Functional Status Assessment
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.12.2.2"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Coded Functional Status Assessment must contain Pain Scale Assessment.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.12.2.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.12.2.3"]'> 
     <!-- Note any missing optional elements -->
     Note: This Coded Functional Status Assessment does not contain Braden Score Assessment.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.12.2.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.12.2.4"]'> 
     <!-- Note any missing optional elements -->
     Note: This Coded Functional Status Assessment does not contain Geriatric Depression Scale.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.12.2.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.12.2.5"]'> 
     <!-- Note any missing optional elements -->
     Note: This Coded Functional Status Assessment does not contain Minimum Data Set.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.12.2.1
   </assert> 
   <assert test="./cda:component/cda:section/cda:templateId[
                   @root = '1.3.6.1.4.1.19376.1.5.3.1.1.12.2.3' or
                   @root = '1.3.6.1.4.1.19376.1.5.3.1.1.12.2.4' or
                   @root = '1.3.6.1.4.1.19376.1.5.3.1.1.12.2.5']">
     At least one of the optional subsections must be in a coded functional assessment.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.12.2.1
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.12.2.2'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.12.2.2"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Pain Scale Assessment can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "38208-5"]'> 
     Error: The section type code of a Pain Scale Assessment must be 38208-5 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Pain Scale Assessment
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.12.3.1"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Pain Scale Assessment must contain Pain Score Observation.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.12.2.2
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.12.2.3'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.12.2.3"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Braden Score can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "38228-3"]'> 
     Error: The section type code of a Braden Score must be 38228-3 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Braden Score
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.12.3.2"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Braden Score must contain Braden Score Observation.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.12.2.3
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.12.2.4'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.12.2.4"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Geriatric Depression Scale can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "48542-5"]'> 
     Error: The section type code of a Geriatric Depression Scale must be 48542-5 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Geriatric Depression Scale
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.12.3.4"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Geriatric Depression Scale must contain Geriatric Depression Score Observation.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.12.2.4
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.12.2.5'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.12.2.5"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Physical Function can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "46006-3"]'> 
     Error: The section type code of a Physical Function must be 46006-3 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Physical Function
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.12.3.7"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Function does not contain Survey Panel.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.12.2.5 
     At least one Survey Panel or Survey Observation shall be present.
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.12.3.6"]'> 
     <!-- Note any missing optional elements -->
     Note: This Physical Function does not contain Survey Observations.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.12.2.5 
     At least one Survey Panel or Survey Observation shall be present.
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.12.3.6"] or 
                 .//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.12.3.7"]'>
     At least one Survey Panel or Survey Observation shall be present.
     See http://www.ihe.net/index.php/1.3.6.1.4.1.19376.1.5.3.1.1.12.2.5
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.13.1.1'>
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.13.1.1"]'>
   <!-- Verify that the template id is used on the appropriate type of object -->
   <assert test='../cda:ClinicalDocument'>
     Error: The Triage Note can only be used on Clinical Documents.
   </assert> 
   <!-- Verify that the parent templateId is also present. -->
   <assert test='cda:templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.1.1"]'>
     Error: The parent template identifier for Triage Note is not present.
   </assert> 
   <!-- Verify the document type code -->
   <assert test='cda:code[@code = "X-TRIAGE"]'>
     Error: The document type code of a Triage Note must be X-TRIAGE
   </assert>
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'>
     Error: The document type code must come from the LOINC code 
     system (2.16.840.1.113883.6.1).
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.1"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Triage Note must contain Chief Complaint.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.1.1"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Triage Note must contain Reason for Visit.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.10.3.2"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Triage Note must contain Mode of Arrival.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.4"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Triage Note must contain History of Present Illness.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.8"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Triage Note should contain Past Medical History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.11"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Triage Note should contain List of Surgeries.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.23"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Triage Note should contain Immunizations.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.14"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Triage Note should contain Family History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.16"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Triage Note should contain Social History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.5.3.4"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Triage Note should contain History of Pregnancies.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.1 
     This section should contain one entry containing the date (TS) of last menstrual 
     period for women of childbearing age, using LOINC Code 8665-2 DATE LAST MENSTRUAL PERIOD
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.19"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Triage Note must contain Current Medications.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.13"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Triage Note must contain Allergies.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.2"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Triage Note must contain Acuity Assessment.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.5.3.2"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Triage Note must contain Vital Signs.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.4"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Triage Note should contain Assessments.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.11"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Triage Note should contain Procedures and Interventions.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.21"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Triage Note should contain Medications Administered.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.1
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.6"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Triage Note should contain Intravenous Fluids Administered.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.1
   </assert> 
 </rule>
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.13.1.2'>
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.13.1.2"]'>
   <!-- Verify that the template id is used on the appropriate type of object -->
   <assert test='../cda:ClinicalDocument'>
     Error: The ED Nursing Note can only be used on Clinical Documents.
   </assert> 
   <!-- Verify that the parent templateId is also present. -->
   <assert test='cda:templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.1.1"]'>
     Error: The parent template identifier for ED Nursing Note is not present.
   </assert> 
   <!-- Verify the document type code -->
   <assert test='cda:code[@code = "X-NN"]'>
     Error: The document type code of a ED Nursing Note must be X-NN
   </assert>
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'>
     Error: The document type code must come from the LOINC code 
     system (2.16.840.1.113883.6.1).
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.25"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Nursing Note must contain Vital Signs.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.2
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.4"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Nursing Note must contain Assessments.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.2 
     Record of assessments of the patient's condition
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.11"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Nursing Note must contain Procedures and Interventions.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.2 
     This section is used to record interventions or nursing procedures performed
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.21"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Nursing Note must contain Medications Administered.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.2
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.6"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Nursing Note must contain Intravenous Fluids Administered.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.2
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.10"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Nursing Note must contain ED Disposition.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.2
   </assert> 
 </rule>
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3'>
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3"]'>
   <!-- Verify that the template id is used on the appropriate type of object -->
   <assert test='../cda:ClinicalDocument'>
     Error: The Composite Triage and Nursing Note can only be used on Clinical Documents.
   </assert> 
   <!-- Verify that the parent templateId is also present. -->
   <assert test='cda:templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.1.1"]'>
     Error: The parent template identifier for Composite Triage and Nursing Note 
     is not present.
   </assert> 
   <!-- Verify the document type code -->
   <assert test='cda:code[@code = "X-TRIAGE"]'>
     Error: The document type code of a Composite Triage and Nursing Note must 
     be X-TRIAGE
   </assert>
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'>
     Error: The document type code must come from the LOINC code 
     system (2.16.840.1.113883.6.1).
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.1"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Composite Triage and Nursing Note must contain Chief Complaint.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.1.1"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Composite Triage and Nursing Note must contain Reason for Visit.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.10.3.2"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Composite Triage and Nursing Note must contain Mode of Arrival.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.4"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Composite Triage and Nursing Note must contain History of Present Illness.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.8"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Composite Triage and Nursing Note should contain Past Medical History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.11"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Composite Triage and Nursing Note should contain List of Surgeries.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.23"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Composite Triage and Nursing Note should contain Immunizations.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.14"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Composite Triage and Nursing Note should contain Family History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.16"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Composite Triage and Nursing Note should contain Social History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.5.3.4"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Composite Triage and Nursing Note should contain History of Pregnancies.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3 
     This section should contain one entry containing the date (TS) of last menstrual 
     period for women of childbearing age, using LOINC Code 8665-2 DATE LAST MENSTRUAL PERIOD
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.19"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Composite Triage and Nursing Note must contain Current Medications.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.13"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Composite Triage and Nursing Note must contain Allergies.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.2"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Composite Triage and Nursing Note must contain Acuity Assessment.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.5.3.2"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Composite Triage and Nursing Note must contain Vital Signs.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.4"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Composite Triage and Nursing Note should contain Assessments .
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.11"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Composite Triage and Nursing Note must contain Procedures and Interventions.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3 
     This section is used to record interventions or nursing procedures performed
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.21"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Composite Triage and Nursing Note should contain Medications Administered.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.6"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) Composite Triage and Nursing Note should contain IV Fluids Administered.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.10"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Composite Triage and Nursing Note must contain ED Disposition.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.3 
     The ED Disposition shall have a Mode of Transport entry describing how the patient departed.
   </assert> 
 </rule>
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4'>
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4"]'>
   <!-- Verify that the template id is used on the appropriate type of object -->
   <assert test='../cda:ClinicalDocument'>
     Error: The ED Physician Note can only be used on Clinical Documents.
   </assert> 
   <!-- Verify that the parent templateId is also present. -->
   <assert test='cda:templateId[@root="1.3.6.1.4.1.19376.1.5.3.1.1.1"]'>
     Error: The parent template identifier for ED Physician Note is not present.
   </assert> 
   <!-- Verify the document type code -->
   <assert test='cda:code[@code = "28568-4"]'>
     Error: The document type code of a ED Physician Note must be 28568-4
   </assert>
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'>
     Error: The document type code must come from the LOINC code 
     system (2.16.840.1.113883.6.1).
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.3"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Physician Note must contain Referral Source.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.10.3.2"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Physician Note must contain Mode of Arrival.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.1"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Physician Note must contain Chief Complaint.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.1.1"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Physician Note must contain Reason for Visit.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.4"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Physician Note must contain History of Present Illness.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.34"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Physician Note must contain Advanced Directives.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.6"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) ED Physician Note should contain Active Problems.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.8"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) ED Physician Note should contain Past Medical History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.19"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Physician Note must contain Current Medications.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.13"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Physician Note must contain Allergies.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.11"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Physician Note must contain List of Surgeries.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.23"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Physician Note must contain Immunizations.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.14"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Physician Note must contain Family History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.16"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Physician Note must contain Social History.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.5.3.4"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) ED Physician Note should contain History of Pregnancies.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4 
     This section should contain one entry containing the date (TS) of last menstrual
     period for women of childbearing age, using LOINC Code 8665-2 DATE LAST MENSTRUAL PERIOD
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.18"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) ED Physician Note should contain Pertinent ROS.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.5.3.2"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Physician Note must contain Vital Signs.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.9.15"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Physician Note must contain Physical Examination.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.4"]'> 
     <!-- Manually verify condtional elements -->
     Manual: This ED Physician Note does not contain Assessements.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4 
     This section shall be present when assessments and plans are recorded separately.
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.31"]'> 
     <!-- Manually verify condtional elements -->
     Manual: This ED Physician Note does not contain Care Plan.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4 
     This section shall be present when assessments and plans are recorded separately.
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.5"]'> 
     <!-- Manually verify condtional elements -->
     Manual: This ED Physician Note does not contain Assessment and Plan.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4 
     This section shall be present when assessments and plans are recorded together.
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.21"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) ED Physician Note should contain Medications Administered.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.6"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) ED Physician Note should contain Intravenous Fluids Administered.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.11"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Physician Note must contain Procedures Performed.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.27"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Physician Note must contain Test Results Lab, ECG, Radiology.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.8"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Physician Note must contain Consultations.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.7"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Physician Note must contain Progress Note.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.9"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Physician Note must contain ED Diagnoses.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.3.22"]'> 
     <!-- Alert on any missing required if known elements -->
     Warning: A(n) ED Physician Note should contain Medications at Discharge.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.2.10"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Physician Note must contain ED Disposition.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.1.4 
     The ED Disposition shall contain a mode of transport entry describing how the 
     patient departed.
   </assert> 
 </rule>
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.13.2.1.1'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.13.2.1.1"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Chief Complaint can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "29299-6"]'> 
     Error: The section type code of a Chief Complaint must be 29299-6 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Chief Complaint
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.13.2.1'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.13.2.1"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Chief Complaint can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "10154-3"]'> 
     Error: The section type code of a Chief Complaint must be 10154-3 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Chief Complaint
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.13.2.10'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.13.2.10"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The ED Disposition can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11302-7"]'> 
     Error: The section type code of a ED Disposition must be 11302-7 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). ED Disposition
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.10.4.2"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Disposition must contain Encounter Disposition.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.2.10 
     This required entry describes the expected or actual disposition of the patient
     after the emergency department encounter has been completed.
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.13.2.11'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.13.2.11"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Procedures and Interventions can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "X-PROC"]'> 
     Error: The section type code of a Procedures and Interventions must be X-PROC 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Procedures and Interventions
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.13.2.2'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.13.2.2"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Acuity Assessment can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11283-9"]'> 
     Error: The section type code of a Acuity Assessment must be 11283-9 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Acuity Assessment
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.3.1"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Acuity Assessment must contain Acuity.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.2.2 
     This entry provides coded values giving the triage acuity.
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.13.2.3'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.13.2.3"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Referral Source can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11293-8"]'> 
     Error: The section type code of a Referral Source must be 11293-8 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Referral Source
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.13.2.4'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.13.2.4"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Assessments can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "X-ASSESS"]'> 
     Error: The section type code of a Assessments must be X-ASSESS 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Assessments
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.3.4"]'> 
     <!-- Note any missing optional elements -->
     Note: This Assessments does not contain Nursing Assessments Battery.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.2.4
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.13.2.5'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.13.2.5"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Care Plan can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "X-AANDP"]'> 
     Error: The section type code of a Care Plan must be X-AANDP 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Care Plan
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.13.2.6'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.13.2.6"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Intravenous Fluids Administered can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "XIVFLU-X"]'> 
     Error: The section type code of a Intravenous Fluids Administered must be XIVFLU-X 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Intravenous Fluids Administered
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.1.13.3.2"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) Intravenous Fluids Administered must contain Intravenous Fluids Administered.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.2.6
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.13.2.7'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.13.2.7"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The Progress Note can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "18733-6"]'> 
     Error: The section type code of a Progress Note must be 18733-6 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). Progress Note
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.13.2.8'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.13.2.8"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The ED Consultations can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "18693-2"]'> 
     Error: The section type code of a ED Consultations must be 18693-2 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). ED Consultations
   </assert> 
 </rule> 
</pattern>
<pattern name='Template_1.3.6.1.4.1.19376.1.5.3.1.1.13.2.9'> 
 <rule context='*[cda:templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.1.13.2.9"]'> 
     <!-- Verify that the template id is used on the appropriate type of object --> 
   <assert test='../cda:section'> 
      Error: The ED Diagnosis can only be used on sections. 
   </assert> 
   <!-- Verify the section type code --> 
   <assert test='cda:code[@code = "11301-9"]'> 
     Error: The section type code of a ED Diagnosis must be 11301-9 
   </assert> 
   <assert test='cda:code[@codeSystem = "2.16.840.1.113883.6.1"]'> 
     Error: The section type code must come from the LOINC code  
     system (2.16.840.1.113883.6.1). ED Diagnosis
   </assert> 
   <assert test='.//cda:templateId[@root = "1.3.6.1.4.1.19376.1.5.3.1.4.5"]'> 
     <!-- Verify that all required data elements are present -->
     Error: A(n) ED Diagnosis must contain Conditions Entry.
     See http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.1.13.2.9
   </assert> 
 </rule> 
</pattern>  
</schema>
