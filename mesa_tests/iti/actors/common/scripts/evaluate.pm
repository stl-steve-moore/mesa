#!/usr/local/bin/perl -w

# General package for MESA scripts.  This file contains all the announcments.

use Env;

package mesa;
require Exporter;
@ISA = qw(Exporter);

#sub evaluate_ADT_A28_A31 {
#  my ($logLevel, $a28, $a31) = @_;
#  my $errorCount = 0;
#
#  print main::LOG "CTX: mesa::evaluate_ADT_A28_A31 $a28 $a31\n" if ($logLevel >= 3);
#  my $len = 0;
#
#  # PID 5, Patient Name
#  my $orgValue = mesa::getFieldLog($logLevel, $a28, "PID", "5", "0", "Patient Name");
#  my $updateValue = mesa::getFieldLog($logLevel, $a31, "PID", "5", "0", "Patient Name");
#
#  $len = length ($orgValue);
#  print main::LOG "CTX: PID 5 Patient Name from patient registration message: $orgValue, length: $len\n" if ($logLevel >= 3);
#  if ($len == 0) {
#    print main::LOG "ERR: PID 5: Patient Name should not be zero length\n";
#    print main::LOG "REF: PID 5: See ITI TF-2 Table 3.30-3\n" if ($logLevel >= 4);
#    $errorCount++;
#  }
#
#  $len = length ($updateValue);
#  print main::LOG "CTX: PID 5 Patient Name from patient update message: $updateValue, length: $len\n" if ($logLevel >= 3);
#  if ($len == 0) {
#    print main::LOG "ERR: PID 5: Patient Name should not be zero length\n";
#    print main::LOG "REF: PID 5: See ITI TF-2 Table 3.30-3\n" if ($logLevel >= 4);
#    $errorCount++;
#  }
#
#  if ($orgValue eq $updateValue) {
#    print main::LOG "ERR: PID 5: Patient Name from your patient update message should not match patient registration message\n";
#    print main::LOG "ERR: Patient Name from your patient update message: $updateValue\n";
#    print main::LOG "ERR: Patient Name from your patient registration message: $orgValue\n";
#    #print main::LOG "REF: PID 5: See ITI TF Supplement Patient Administration Management 2005-2006\n" if ($logLevel >= 4);
#    $errorCount++;
#  }
#
#  return $errorCount;
#}

sub evaluate_ADT_A01 {
  my ($logLevel, $mesaADT, $testADT) = @_;
  my $errorCount = 0;
  my $idx = 0;
  print main::LOG "CTX: mesa::evaluate_ADT_A01 $mesaADT $testADT\n" if ($logLevel >= 3);

  my @notEmptyFields = (
	$testADT, "MSH", "3", "0", "Sending Application",   "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "4", "0", "Sending Facility",      "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "5", "0", "Receiving Application", "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "6", "0", "Receiving Facility",    "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "7", "0", "Date/Time of Message",  "ITI TF-2 Table 3.30-1",
	$testADT, "EVN", "2", "0", "Recorded Date Time", "ITI TF-2 Table 3.30-2",
	$testADT, "PID", "3", "0", "Patient Identifier List", "ITI TF-2 Table 3.30-3"	
  );  
  $idx = 0;
  while ($idx < scalar(@notEmptyFields)) {
    $errorCount += check_Hl7_Field_Not_Empty($logLevel, $notEmptyFields[$idx], $notEmptyFields[$idx+1], $notEmptyFields[$idx+2], $notEmptyFields[$idx+3], $notEmptyFields[$idx+4], $notEmptyFields[$idx+5]);
    $idx += 6;
  }

  my @equalFields = (
  	$mesaADT, $testADT, "MSH", "9", "0", "Message Type", "ITI TF-2 Table 3.30-1",
	$mesaADT, $testADT, "MSH", "11", "0", "Processing Id", "ITI TF-2 Table 3.30-1",
	$mesaADT, $testADT, "MSH", "12", "0", "Version Id", "ITI TF-2 Table 3.30-1",
	$mesaADT, $testADT, "PID", "5", "0", "Patient Name", "ITI TF-2 Table 3.30-3",
	$mesaADT, $testADT, "PID", "7", "0", "Date/Time of Birth", "ITI TF-2 Table 3.30-3",
	$mesaADT, $testADT, "PID", "8", "0", "Administrative Sex", "ITI TF-2 Table 3.30-3",
	$mesaADT, $testADT, "PID", "11", "0", "Patient Address", "ITI TF-2 Table 3.30-3",
	$mesaADT, $testADT, "PV1", "2", "0", "Patient Class", "ITI TF-2 Table 3.30-4",
	$mesaADT, $testADT, "PV1", "3", "0", "Assigned Patient Location", "ITI TF-2 Table 3.30-4",
	$mesaADT, $testADT, "PV1", "7", "0", "Attending Doctor", "ITI TF-2 Table 3.30-4",
	$mesaADT, $testADT, "PV1", "44", "0", "Admit Date/Time", "ITI TF-2 Table 3.30-4"
  );
  $idx = 0;
  while ($idx < scalar(@equalFields)) {
    $errorCount += check_Hl7_Field_Equal($logLevel, $equalFields[$idx], $equalFields[$idx+1], $equalFields[$idx+2], $equalFields[$idx+3], $equalFields[$idx+4], $equalFields[$idx+5], $equalFields[$idx+6]);
    $idx += 7;
  }
  
  return $errorCount;
}

sub evaluate_ADT_A03 {
  my ($logLevel, $mesaADT, $testADT) = @_;
  my $errorCount = 0;
  my $idx = 0;
  print main::LOG "CTX: mesa::evaluate_ADT_A03 $mesaADT $testADT\n" if ($logLevel >= 3);

  my @notEmptyFields = (
	$testADT, "MSH", "3", "0", "Sending Application",   "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "4", "0", "Sending Facility",      "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "5", "0", "Receiving Application", "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "6", "0", "Receiving Facility",    "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "7", "0", "Date/Time of Message",  "ITI TF-2 Table 3.30-1",
	$testADT, "EVN", "2", "0", "Recorded Date Time", "ITI TF-2 Table 3.30-2",
	$testADT, "PID", "3", "0", "Patient Identifier List", "ITI TF-2 Table 3.30-3"	
  );  
  $idx = 0;
  while ($idx < scalar(@notEmptyFields)) {
    $errorCount += check_Hl7_Field_Not_Empty($logLevel, $notEmptyFields[$idx], $notEmptyFields[$idx+1], $notEmptyFields[$idx+2], $notEmptyFields[$idx+3], $notEmptyFields[$idx+4], $notEmptyFields[$idx+5]);
    $idx += 6;
  }
  
  my @equalFields = (
  	$mesaADT, $testADT, "MSH", "9", "0", "Message Type", "ITI TF-2 Table 3.30-1",
	$mesaADT, $testADT, "MSH", "11", "0", "Processing Id", "ITI TF-2 Table 3.30-1",
	$mesaADT, $testADT, "MSH", "12", "0", "Version Id", "ITI TF-2 Table 3.30-1",
	$mesaADT, $testADT, "PID", "5", "0", "Patient Name", "ITI TF-2 Table 3.30-3",
	$mesaADT, $testADT, "PID", "7", "0", "Date/Time of Birth", "ITI TF-2 Table 3.30-3",
	$mesaADT, $testADT, "PID", "8", "0", "Administrative Sex", "ITI TF-2 Table 3.30-3",
	$mesaADT, $testADT, "PID", "11", "0", "Patient Address", "ITI TF-2 Table 3.30-3",
	$mesaADT, $testADT, "PV1", "2", "0", "Patient Class", "ITI TF-2 Table 3.30-4",
	$mesaADT, $testADT, "PV1", "3", "0", "Assigned Patient Location", "ITI TF-2 Table 3.30-4",
	$mesaADT, $testADT, "PV1", "7", "0", "Attending Doctor", "ITI TF-2 Table 3.30-4",
	$mesaADT, $testADT, "PV1", "45", "0", "Discharge Date/Time", "ITI TF-2 Table 3.30-4"
  );
  $idx = 0;
  while ($idx < scalar(@equalFields)) {
    $errorCount += check_Hl7_Field_Equal($logLevel, $equalFields[$idx], $equalFields[$idx+1], $equalFields[$idx+2], $equalFields[$idx+3], $equalFields[$idx+4], $equalFields[$idx+5], $equalFields[$idx+6]);
    $idx += 7;
  }
  
  return $errorCount;
}

sub evaluate_ADT_A04_PIX {
  my ($logLevel, $mesaADT, $testADT) = @_;
  my $errorCount = 0;
  my $idx = 0;
  print main::LOG "CTX: mesa::evaluate_ADT_A04_PIX $mesaADT $testADT\n" if ($logLevel >= 3);
  
  
  my @notEmptyFields = (
	$testADT, "MSH", "3", "0", "Sending Application",   "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "4", "0", "Sending Facility",      "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "5", "0", "Receiving Application", "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "6", "0", "Receiving Facility",    "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "7", "0", "Date/Time of Message",  "ITI TF-2 Table 3.30-1",
	$testADT, "EVN", "2", "0", "Recorded Date Time", "ITI TF-2 Table 3.30-2",
	$testADT, "PID", "3", "0", "Patient Identifier List", "ITI TF-2 Table 3.30-3"	
  );  
  $idx = 0;
  while ($idx < scalar(@notEmptyFields)) {
    $errorCount += check_Hl7_Field_Not_Empty($logLevel, $notEmptyFields[$idx],
	$notEmptyFields[$idx+1], $notEmptyFields[$idx+2],
	$notEmptyFields[$idx+3], $notEmptyFields[$idx+4],
	$notEmptyFields[$idx+5]);
    $idx += 6;
  }
  
  my @equalFields = (
  	$mesaADT, $testADT, "MSH", "9", "1", "Message Type", "ITI TF-2 Table 3.30-1",
  	$mesaADT, $testADT, "MSH", "9", "2", "Message Type", "ITI TF-2 Table 3.30-1",
	$mesaADT, $testADT, "MSH", "11", "0", "Processing Id", "ITI TF-2 Table 3.30-1",
	$mesaADT, $testADT, "MSH", "12", "0", "Version Id", "ITI TF-2 Table 3.30-1",
	$mesaADT, $testADT, "PID", "3", "4", "Assigning Authority", "ITI TF-2 Table 3.30-3",
	$mesaADT, $testADT, "PID", "5", "0", "Patient Name", "ITI TF-2 Table 3.8-2",
	$mesaADT, $testADT, "PID", "7", "0", "Date/Time of Birth", "ITI TF-2 Table 3.8-2",
	$mesaADT, $testADT, "PID", "8", "0", "Administrative Sex", "ITI TF-2 Table 3.8-2",
	$mesaADT, $testADT, "PID", "11", "0", "Patient Address", "ITI TF-2 Table 3.8-2",
	$mesaADT, $testADT, "PID", "19", "0", "SSN Number - Patient", "ITI TF-2 Table 3.8-2",
	$mesaADT, $testADT, "PID", "20", "0", "Drivers License Number-Patient", "ITI TF-2 Table 3.8-2",
	$mesaADT, $testADT, "PV1", "2", "0", "Patient Class", "HL7 V.2.3.1",
#	$mesaADT, $testADT, "PV1", "44", "0", "Admit Date/Time", "ITI TF-2 Table 3.30-4"
  );
  $idx = 0;
  while ($idx < scalar(@equalFields)) {
    $errorCount += check_Hl7_Field_Equal($logLevel, $equalFields[$idx], $equalFields[$idx+1], $equalFields[$idx+2], $equalFields[$idx+3], $equalFields[$idx+4], $equalFields[$idx+5], $equalFields[$idx+6]);
    $idx += 7;
  }

  return $errorCount;
}

sub evaluate_ADT_A04_PAM {
  my ($logLevel, $mesaADT, $testADT) = @_;
  my $errorCount = 0;
  my $idx = 0;
  print main::LOG "CTX: mesa::evaluate_ADT_A04 $mesaADT $testADT\n" if ($logLevel >= 3);
  
  
  my @notEmptyFields = (
	$testADT, "MSH", "3", "0", "Sending Application",   "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "4", "0", "Sending Facility",      "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "5", "0", "Receiving Application", "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "6", "0", "Receiving Facility",    "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "7", "0", "Date/Time of Message",  "ITI TF-2 Table 3.30-1",
	$testADT, "EVN", "2", "0", "Recorded Date Time", "ITI TF-2 Table 3.30-2",
	$testADT, "PID", "3", "0", "Patient Identifier List", "ITI TF-2 Table 3.30-3"	
  );  
  $idx = 0;
  while ($idx < scalar(@notEmptyFields)) {
    $errorCount += check_Hl7_Field_Not_Empty($logLevel, $notEmptyFields[$idx], $notEmptyFields[$idx+1], $notEmptyFields[$idx+2], $notEmptyFields[$idx+3], $notEmptyFields[$idx+4], $notEmptyFields[$idx+5]);
    $idx += 6;
  }
  
  my @equalFields = (
  	$mesaADT, $testADT, "MSH", "9", "0", "Message Type", "ITI TF-2 Table 3.30-1",
	$mesaADT, $testADT, "MSH", "11", "0", "Processing Id", "ITI TF-2 Table 3.30-1",
	$mesaADT, $testADT, "MSH", "12", "0", "Version Id", "ITI TF-2 Table 3.30-1",
	$mesaADT, $testADT, "PID", "5", "0", "Patient Name", "ITI TF-2 Table 3.30-3",
	$mesaADT, $testADT, "PID", "7", "0", "Date/Time of Birth", "ITI TF-2 Table 3.30-3",
	$mesaADT, $testADT, "PID", "8", "0", "Administrative Sex", "ITI TF-2 Table 3.30-3",
	$mesaADT, $testADT, "PID", "11", "0", "Patient Address", "ITI TF-2 Table 3.30-3",
	$mesaADT, $testADT, "PV1", "2", "0", "Patient Class", "ITI TF-2 Table 3.30-4",
	$mesaADT, $testADT, "PV1", "44", "0", "Admit Date/Time", "ITI TF-2 Table 3.30-4"
  );
  $idx = 0;
  while ($idx < scalar(@equalFields)) {
    $errorCount += check_Hl7_Field_Equal($logLevel, $equalFields[$idx], $equalFields[$idx+1], $equalFields[$idx+2], $equalFields[$idx+3], $equalFields[$idx+4], $equalFields[$idx+5], $equalFields[$idx+6]);
    $idx += 7;
  }
  
  # PV1 19, Visit Number and PID 18 Account Number
  my $visitNumber =         mesa::getFieldLog($logLevel, $testADT, "PV1", "19", "0", "Visit Number");
  my $accountNumber =       mesa::getFieldLog($logLevel, $testADT, "PID", "18", "0", "Account Number");
  print main::LOG "CTX: PV1 19 Visit Number:             $visitNumber\n" if ($logLevel >= 3);
  print main::LOG "CTX: PID 18 Account Number:           $accountNumber\n" if ($logLevel >= 3);
  if (($visitNumber eq "") && ($accountNumber eq "")) {
    print main::LOG "ERR: Both PV1 19 (Visit Number) and PID 18 (Account Number) are 0 length\n";
    print main::LOG "REF: PV1 18: See TF Vol II, Table 4.1-3 (see notes below table)\n" if ($logLevel >= 4);
    $errorCount++;
  }
  
  return $errorCount;
}

sub evaluate_ADT_A28 {
  my ($logLevel, $mesaADT, $testADT) = @_;
  my $errorCount = 0;
  my $idx = 0;
  print main::LOG "CTX: mesa::evaluate_ADT_A28 $mesaADT $testADT\n" if ($logLevel >= 3);
 
  my @notEmptyFields = (
	$testADT, "MSH", "3", "0", "Sending Application",   "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "4", "0", "Sending Facility",      "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "5", "0", "Receiving Application", "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "6", "0", "Receiving Facility",    "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "7", "0", "Date/Time of Message",  "ITI TF-2 Table 3.30-1",
	$testADT, "EVN", "2", "0", "Recorded Date Time", "ITI TF-2 Table 3.30-2",
	$testADT, "PID", "3", "0", "Patient Identifier List", "ITI TF-2 Table 3.30-3"	
  );  
  $idx = 0;
  while ($idx < scalar(@notEmptyFields)) {
    $errorCount += check_Hl7_Field_Not_Empty($logLevel, $notEmptyFields[$idx], $notEmptyFields[$idx+1], $notEmptyFields[$idx+2], $notEmptyFields[$idx+3], $notEmptyFields[$idx+4], $notEmptyFields[$idx+5]);
    $idx += 6;
  }

  my @equalFields = (
  	$mesaADT, $testADT, "MSH", "9", "0", "Message Type", "ITI TF-2 Table 3.30-1",
	$mesaADT, $testADT, "MSH", "11", "0", "Processing Id", "ITI TF-2 Table 3.30-1",
	$mesaADT, $testADT, "MSH", "12", "0", "Version Id", "ITI TF-2 Table 3.30-1",
	$mesaADT, $testADT, "PID", "3", "4", "(Patient ID) Assigning Authority", "ITI TF-2 Table 3.30-1",
	$mesaADT, $testADT, "PID", "3", "5", "(Patient ID) Identifier Type Code", "ITI TF-2 Table 3.30-1",	
	$mesaADT, $testADT, "PID", "5", "0", "Patient Name", "ITI TF-2 Table 3.30-3",
	$mesaADT, $testADT, "PID", "7", "0", "Date/Time of Birth", "ITI TF-2 Table 3.30-3",
	$mesaADT, $testADT, "PID", "8", "0", "Administrative Sex", "ITI TF-2 Table 3.30-3",
	$mesaADT, $testADT, "PID", "11", "0", "Patient Address", "ITI TF-2 Table 3.30-3",
	$mesaADT, $testADT, "PV1", "2", "0", "Patient Class", "ITI TF-2 Table 3.30-4"
  );
  $idx = 0;
  while ($idx < scalar(@equalFields)) {
    $errorCount += check_Hl7_Field_Equal($logLevel, $equalFields[$idx], $equalFields[$idx+1], $equalFields[$idx+2], $equalFields[$idx+3], $equalFields[$idx+4], $equalFields[$idx+5], $equalFields[$idx+6]);
    $idx += 7;
  }

  return $errorCount;
}

sub evaluate_ADT_A31_PAM {
  my ($logLevel, $mesaADT, $testADT) = @_;
  my $errorCount = 0;
  my $idx = 0;
  print main::LOG "CTX: mesa::evaluate_ADT_A31 $mesaADT $testADT\n" if ($logLevel >= 3);
 
  my @notEmptyFields = (
	$testADT, "MSH", "3", "0", "Sending Application",   "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "4", "0", "Sending Facility",      "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "5", "0", "Receiving Application", "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "6", "0", "Receiving Facility",    "ITI TF-2 Table 3.30-1",
	$testADT, "MSH", "7", "0", "Date/Time of Message",  "ITI TF-2 Table 3.30-1",
	$testADT, "EVN", "2", "0", "Recorded Date Time", "ITI TF-2 Table 3.30-2",
	$testADT, "PID", "3", "0", "Patient Identifier List", "ITI TF-2 Table 3.30-3"	
  );  
  $idx = 0;
  while ($idx < scalar(@notEmptyFields)) {
    $errorCount += check_Hl7_Field_Not_Empty($logLevel, $notEmptyFields[$idx], $notEmptyFields[$idx+1], $notEmptyFields[$idx+2], $notEmptyFields[$idx+3], $notEmptyFields[$idx+4], $notEmptyFields[$idx+5]);
    $idx += 6;
  }

  my @equalFields = (
  	$mesaADT, $testADT, "MSH", "9", "0", "Message Type", "ITI TF-2 Table 3.30-1",
	$mesaADT, $testADT, "MSH", "11", "0", "Processing Id", "ITI TF-2 Table 3.30-1",
	$mesaADT, $testADT, "MSH", "12", "0", "Version Id", "ITI TF-2 Table 3.30-1",
	$mesaADT, $testADT, "PID", "3", "4", "(Patient ID) Assigning Authority", "ITI TF-2 Table 3.30-1",
	$mesaADT, $testADT, "PID", "3", "5", "(Patient ID) Identifier Type Code", "ITI TF-2 Table 3.30-1",	
	$mesaADT, $testADT, "PID", "5", "0", "Patient Name", "ITI TF-2 Table 3.30-3",
  );
  $idx = 0;
  while ($idx < scalar(@equalFields)) {
    $errorCount += check_Hl7_Field_Equal($logLevel, $equalFields[$idx], $equalFields[$idx+1], $equalFields[$idx+2], $equalFields[$idx+3], $equalFields[$idx+4], $equalFields[$idx+5], $equalFields[$idx+6]);
    $idx += 7;
  }

  return $errorCount;
}


sub check_Hl7_Field_Not_Empty{
  my($logLevel, $testHL7, $seg, $field, $comp, $fieldName, $ref) =  @_;
  
  my ($status, $value) = mesa::getFieldLog($logLevel, $testHL7, $seg, $field, $comp, $fieldName);
  if ($status != 0) {
    print main::LOG "Could not get HL7 Field for $seg, $field, $fieldName\n";
    print main::LOG "File name is $testHL7\n";
    return 1;
  }
  my $len = length ($value);
  print main::LOG "CTX: $seg $field $fieldName: <$value> length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: $seg $field : $fieldName should not be zero length\n";
    print main::LOG "REF: $seg $field: See $ref\n" if ($logLevel >= 4);
    return 1;
  }
  
  return 0;
}

sub check_Hl7_Field_Equal{
  my($logLevel, $mesaHL7, $testHL7, $seg, $field, $comp, $fieldName, $ref) =  @_;
  ($status, $vTest) = mesa::getFieldLog($logLevel, $testHL7, $seg, $field, $comp, $fieldName);
  if ($status != 0) {
    print main::LOG "Could not get HL7 Field for $seg, $field, $fieldName\n";
    print main::LOG "File name is $testHL7\n";
    return 1;         # Non-zero error count
  }
  ($status, $vMESA) = mesa::getFieldLog($logLevel, $mesaHL7, $seg, $field, $comp, $fieldName);
  if ($status != 0) {
    print main::LOG "Could not get HL7 Field for $seg, $field, $fieldName\n";
    print main::LOG "File name is $mesaHL7\n";
    return 1;         # Non-zero error count
  }
  my $len = length ($vTest);
  print main::LOG "CTX: $seg $field.$comp $fieldName: <$vTest> length: $len\n" if ($logLevel >= 3);
  if ($len == 0) {
    print main::LOG "ERR: $seg $field : $fieldName should not be zero length\n";
    print main::LOG "REF: See $ref\n" if ($logLevel >= 4);
    return 1;
  } elsif ($vTest ne $vMESA) {
    print main::LOG "ERR: $seg $field $fieldName test value does not equal MESA value\n";
    print main::LOG "ERR: Test value: $vTest\n";
    print main::LOG "ERR: MESA value: $vMESA\n";
    return 1;
  }
  
  return 0;
}

sub evaluate_ADT_A04 {
  my ($logLevel, $mesaADT, $testADT) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_ADT_A04 $mesaADT $testADT\n" if ($logLevel >= 3);
  my $len = 0;

  # PID 3, Patient ID List
  my $patientID =     mesa::getFieldLog($logLevel, $testADT, "PID", "3", "0", "Patient ID");
  #my $mesaPatientID = mesa::getFieldLog($logLevel, $mesaADT, "PID", "3", "0", "Patient ID");
  $len = length ($patientID);
  print main::LOG "CTX: PID  3 Patient ID List:          $patientID, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PID  3: Patient ID List should not be zero length\n";
    print main::LOG "REF: PID  3: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($len > 20) {
    print main::LOG "ERR: PID  3: Patient ID List length is constrained to 20 characters\n";
    print main::LOG "ERR: PID  3: Your patient ID length is $len\n";
    print main::LOG "ERR: Test value: $patientID\n";
    print main::LOG "REF: PID  3: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PID 5, Patient Name
  my $patientName =     mesa::getFieldLog($logLevel, $testADT, "PID", "5", "0", "Patient Name");
  my $mesaPatientName = mesa::getFieldLog($logLevel, $mesaADT, "PID", "5", "0", "Patient Name");
  $len = length ($patientName);
  print main::LOG "CTX: PID  5 Patient Name:             $patientName, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PID  5: Patient Name should not be zero length\n";
    print main::LOG "REF: PID  5: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($patientName ne $mesaPatientName) {
    print main::LOG "ERR: PID  5: Patient Name from your A04 messages does not match MESA value\n";
    print main::LOG "ERR: Test value: $patientName\n";
    print main::LOG "ERR: MESA value: $mesaPatientName\n";
    print main::LOG "REF: PID  5: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PID 8, Patient Sex
  my $patientSex =     mesa::getFieldLog($logLevel, $testADT, "PID", "8", "0", "Patient Sex");
  my $mesaPatientSex = mesa::getFieldLog($logLevel, $mesaADT, "PID", "8", "0", "Patient Sex");
  $len = length ($patientSex);
  print main::LOG "CTX: PID  8 Patient Sex:              $patientSex, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PID  8: Patient Sex should not be zero length\n";
    print main::LOG "REF: PID  8: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($patientSex ne $mesaPatientSex) {
    print main::LOG "ERR: PID  8: Patient Sex from your A04 messages does not match MESA value\n";
    print main::LOG "ERR: Test value: $patientSex\n";
    print main::LOG "ERR: MESA value: $mesaPatientSex\n";
    print main::LOG "REF: PID  8: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PID 10, Patient Race
  my $patientRace =     mesa::getFieldLog($logLevel, $testADT, "PID", "10", "0", "Patient Race");
  my $mesaPatientRace = mesa::getFieldLog($logLevel, $mesaADT, "PID", "10", "0", "Patient Race");
  $len = length ($patientRace);
  print main::LOG "CTX: PID 10 Patient Race:             $patientRace, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PID 10: Patient Race should not be zero length\n";
    print main::LOG "REF: PID 10: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($patientRace ne $mesaPatientRace) {
    print main::LOG "ERR: PID 10: Patient Race from your A04 messages does not match MESA value\n";
    print main::LOG "ERR: Test value: $patientRace\n";
    print main::LOG "ERR: MESA value: $mesaPatientRace\n";
    print main::LOG "REF: PID 10: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PID 11, Patient Address
  my $patientAddress =     mesa::getFieldLog($logLevel, $testADT, "PID", "11", "0", "Patient Address");
  my $mesaPatientAddress = mesa::getFieldLog($logLevel, $mesaADT, "PID", "11", "0", "Patient Address");
  $len = length ($patientAddress);
  print main::LOG "CTX: PID 11 Patient Address:          $patientAddress, length: $len\n" if ($logLevel >= 3);

  if ($patientAddress eq $mesaPatientAddress) {
    # That means they got everything right
  } elsif ($len == 0) {
    print main::LOG "ERR: PID 11: Patient Address should not be zero length\n";
    print main::LOG "ERR: PID 11: MESA Patient Address is $mesaPatientAddress\n";
    print main::LOG "REF: PID 11: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($len > 106) {
    print main::LOG "ERR: PID 11: Patient Address length is constrained to 106 characters\n";
    print main::LOG "ERR: PID 11: Your Patient Address length is $len\n";
    print main::LOG "ERR: Test value: $patientAddress\n";
    print main::LOG "REF: PID 11: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  } else {
    print main::LOG "WARN: PID 11: Patient Address does not match MESA address\n";
    print main::LOG "WARN: PID 11: We assume this is a typo and mark this as a warning\n";
    print main::LOG "WARN: Test value: $patientAddress\n";
    print main::LOG "WARN: MESA value: $mesaPatientAddress\n";
  }

  # PID 18, Patient Account Number
  my $patientAccountNumber =     mesa::getFieldLog($logLevel, $testADT, "PID", "18", "0", "Patient Account Number");
  #my $mesaPatientAccountNumber = mesa::getFieldLog($logLevel, $mesaADT, "PID", "18", "0", "Patient Account Number");
  $len = length ($patientAccountNumber);
  print main::LOG "CTX: PID 18 Patient Account Number:   $patientAccountNumber, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PID 18: Patient Account Number should not be zero length\n";
    print main::LOG "REF: PID 18: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($len > 20) {
    print main::LOG "ERR: PID 18: Patient Account Number length is constrained to 20 characters\n";
    print main::LOG "ERR: PID 18: Your Patient Account Number length is $len\n";
    print main::LOG "ERR: Test value: $patientAccountNumber\n";
    print main::LOG "REF: PID 18: See TF Vol II, Table 4.1-2\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PV1 2, Patient Class
  my $patientClass = mesa::getFieldLog($logLevel, $testADT, "PV1", "2", "0", "Patient Class");
  my $mesaPatientClass = mesa::getFieldLog($logLevel, $mesaADT, "PV1", "2", "0", "Patient Class");
  $len = length ($patientClass);
  print main::LOG "CTX: PV1  2 Patient Class:            $patientClass, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PV1  2: Patient Class should not be zero length\n";
    print main::LOG "REF: PV1  2: See TF Vol II, Table 4.1-3\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($patientClass ne $mesaPatientClass) {
    print main::LOG "ERR: PV1  2: Patient class from your A04 messages does not match MESA value\n";
    print main::LOG "ERR: Test value: $patientClass\n";
    print main::LOG "ERR: MESA value: $mesaPatientClass\n";
    print main::LOG "REF: PV1  2: See TF Vol II, Table 4.1-3\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PV1 7, Attending doctor
  my $attendingDoctor = mesa::getFieldLog($logLevel, $testADT, "PV1", "7", "0", "Attending doctor");
  my $mesaAttendingDoctor = mesa::getFieldLog($logLevel, $mesaADT, "PV1", "7", "0", "Attending doctor");
  $len = length ($attendingDoctor);
  print main::LOG "CTX: PV1  7 Attending Doctor:         $attendingDoctor, length: $len\n" if ($logLevel >= 3);

  if ($len != 0) {
    print main::LOG "ERR: PV1  7: Attending doctor in your A04 messages should be zero length\n";
    print main::LOG "ERR: Test value: $attendingDoctor\n";
    print main::LOG "REF: PV1  7: See TF Vol II, Table 4.1-3 (see notes below table)\n" if ($logLevel >= 4);
    $errorCount++;
  }
  if ($mesaAttendingDoctor ne "") {
    print main::LOG "ERR: MESA Error, PV1 7 Attending doctor in MESA message is not zero length \n";
    print main::LOG "ERR: MESA value: $mesaAttendingDoctor\n";
    print main::LOG "ERR: Please log bug report\n";
    $errorCount++;
  }

  # PV1 8, Referring doctor
  my $referringDoctor =     mesa::getFieldLog($logLevel, $testADT, "PV1", "8", "0", "Referring Doctor");
  my $mesaReferringDoctor = mesa::getFieldLog($logLevel, $mesaADT, "PV1", "8", "0", "ReferringDoctor");
  $len = length ($referringDoctor);
  print main::LOG "CTX: PV1  8 Referring Doctor:         $referringDoctor, length: $len\n" if ($logLevel >= 3);

  if ($len == 0) {
    print main::LOG "ERR: PV1  8: Referring Doctor\n";
    print main::LOG "REF: PV1  8: See TF Vol II, Table 4.1-3 (see notes below table)\n" if ($logLevel >= 4);
    $errorCount++;
  } elsif ($referringDoctor ne $mesaReferringDoctor) {
    print main::LOG "ERR: PV1  8: Referring Doctor from your A04 messages does not match MESA value\n";
    print main::LOG "ERR: Test value: $referringDoctor\n";
    print main::LOG "ERR: MESA value: $mesaReferringDoctor\n";
    print main::LOG "REF: PV1  8: See TF Vol II, Table 4.1-3 (see notes below table)\n" if ($logLevel >= 4);
    $errorCount++;
  }

  # PV1 17, Admitting doctor
  my $admittingDoctor =     mesa::getFieldLog($logLevel, $testADT, "PV1", "17", "0", "Admitting doctor");
  my $mesaAdmittingDoctor = mesa::getFieldLog($logLevel, $mesaADT, "PV1", "17", "0", "Admitting doctor");
  $len = length ($admittingDoctor);
  print main::LOG "CTX: PV1 17 Admitting Doctor:         $admittingDoctor, length: $len\n" if ($logLevel >= 3);

  if ($len != 0) {
    print main::LOG "ERR: PV1 17: Admitting Doctor in your A04 messages should be zero length\n";
    print main::LOG "ERR: Test value: $admittingDoctor\n";
    print main::LOG "REF: PV1 17: See TF Vol II, Table 4.1-3 (see notes below table)\n" if ($logLevel >= 4);
    $errorCount++;
  }
  if ($mesaAdmittingDoctor ne "") {
    print main::LOG "ERR: MESA Error, PV1 17 Admitting doctor in MESA message is not zero length \n";
    print main::LOG "ERR: MESA value: $mesaAttendingDoctor\n";
    print main::LOG "ERR: Please log bug report\n";
    $errorCount++;
  }

  # PV1 19, Visit Number and PID 18 Account Number
  my $visitNumber =         mesa::getFieldLog($logLevel, $testADT, "PV1", "19", "0", "Visit Number");
  my $accountNumber =       mesa::getFieldLog($logLevel, $testADT, "PID", "18", "0", "Account Number");
  print main::LOG "CTX: PV1 19 Visit Number:             $visitNumber\n" if ($logLevel >= 3);
  print main::LOG "CTX: PID 18 Account Number:           $accountNumber\n" if ($logLevel >= 3);
  if (($visitNumber eq "") && ($accountNumber eq "")) {
    print main::LOG "ERR: Both PV1 19 (Visit Number) and PID 18 (Account Number) are 0 length\n";
    print main::LOG "REF: PV1 18: See TF Vol II, Table 4.1-3 (see notes below table)\n" if ($logLevel >= 4);
    $errorCount++;
  }

  return $errorCount;
}

sub evaluate_ADT_A04_extended {
  my ($logLevel, $mesaA04, $testA04) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_ADT_A04_extended $mesaA04 $testA04\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", "20", "Message Control ID     ", "ITI TF-2",
  );
  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx];
    my $field     = $nonZeroFields[$idx+1];
    my $maxLen    = $nonZeroFields[$idx+2];
    my $fieldName = $nonZeroFields[$idx+3];
    my $reference = $nonZeroFields[$idx+4];

    my ($status, $v) = mesa::getFieldLog($logLevel, $testA04, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testA04\n";
      return 1;         # Non-zero error count
    }
    my $len = length ($v);
    print main::LOG "CTX: $segment $field $fieldName: <$v> length: $len\n" if ($logLevel >= 3);

    if ($len == 0) {
      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $v\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    }
    $idx += 5;
  }

  @equivalentFields = (
	"PID", " 3", "5", "250", "Assigning Authority    ", "ITI TF-2 ",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx];
    my $field     = $equivalentFields[$idx+1];
    my $component = $equivalentFields[$idx+2];
    my $maxLen    = $equivalentFields[$idx+3];
    my $fieldName = $equivalentFields[$idx+4];
    my $reference = $equivalentFields[$idx+5];

    ($status, $vTest) = mesa::getFieldLog($logLevel, $testA04, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testA04\n";
      return 1;         # Non-zero error count
    }
    ($status, $vMESA) = mesa::getFieldLog($logLevel, $mesaA04, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaA04\n";
      return 1;         # Non-zero error count
    }
    my $len = length ($vTest);
    print main::LOG "CTX: $segment $field $fieldName: <$vTest> length: $len\n" if ($logLevel >= 3);
    if ($len == 0) {
      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $v\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    $idx += 6;
  }

  return $errorCount;
}

sub evaluate_RSP_K23_baseline {
  my ($logLevel, $mesaRSP, $testRSP) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_RSP_K23_no_PID $mesaRSP $testRSP\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", "20", "Message Control ID     ", "ITI TF-2",
  );
  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx];
    my $field     = $nonZeroFields[$idx+1];
    my $maxLen    = $nonZeroFields[$idx+2];
    my $fieldName = $nonZeroFields[$idx+3];
    my $reference = $nonZeroFields[$idx+4];

    my ($status, $v) = mesa::getFieldLog($logLevel, $testRSP, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testRSP\n";
      return 1;         # Non-zero error count
    }
    my $len = length ($v);
    print main::LOG "CTX: $segment $field $fieldName: <$v> length: $len\n" if ($logLevel >= 3);

    if ($len == 0) {
      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $v\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    }
    $idx += 5;
  }

  @equivalentFields = (
	"MSH", " 9", "1", "  3", "Message Type           ", "ITI TF-2 ",
	"MSH", " 9", "2", "  3", "Message Type           ", "ITI TF-2 ",
	"MSH", "11", "0", "  3", "Processing ID          ", "ITI TF-2",
	"MSH", "12", "0", " 60", "Version ID             ", "ITI TF-2",
	"MSA", " 1", "0", "  2", "Acknowledgment Code    ", "ITI TF-2 Table C.1-2",
	"QAK", " 2", "0", "  2", "Query Reponse Status   ", "ITI TF-2 Table 3.9-4",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx];
    my $field     = $equivalentFields[$idx+1];
    my $component = $equivalentFields[$idx+2];
    my $maxLen    = $equivalentFields[$idx+3];
    my $fieldName = $equivalentFields[$idx+4];
    my $reference = $equivalentFields[$idx+5];

    ($status, $vTest) = mesa::getFieldLog($logLevel, $testRSP, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testRSP\n";
      return 1;         # Non-zero error count
    }
    ($status, $vMESA) = mesa::getFieldLog($logLevel, $mesaRSP, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaRSP\n";
      return 1;         # Non-zero error count
    }
    my $len = length ($vTest);
    print main::LOG "CTX: $segment $field $fieldName: <$vTest> length: $len\n" if ($logLevel >= 3);
    if ($len == 0) {
      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $v\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    $idx += 6;
  }

  return $errorCount;
}

sub evaluate_RSP_K23_PID {
  my ($logLevel, $mesaRSP, $testRSP) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_RSP_K23_PID $mesaRSP $testRSP\n" if ($logLevel >= 3);
  my $len = 0;

  my $idx = 0;

  @equivalentFields = (
	"PID", " 3", "1", " 20",  "Patient ID List (PID 3.1)", "ITI TF-2",
	"PID", " 3", "4", " 200", "Patient ID List (PID 3.4)", "ITI TF-2",
	"PID", " 3", "5", " 200", "Patient ID List (PID 3.5)", "ITI TF-2",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx];
    my $field     = $equivalentFields[$idx+1];
    my $component = $equivalentFields[$idx+2];
    my $maxLen    = $equivalentFields[$idx+3];
    my $fieldName = $equivalentFields[$idx+4];
    my $reference = $equivalentFields[$idx+5];

    ($status, $vTest) = mesa::getFieldLog($logLevel, $testRSP, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testRSP\n";
      return 1;         # Non-zero error count
    }
    ($status, $vMESA) = mesa::getFieldLog($logLevel, $mesaRSP, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaRSP\n";
      return 1;         # Non-zero error count
    }
    my $len = length ($vTest);
    print main::LOG "CTX: $segment $field $fieldName: <$vTest> length: $len\n" if ($logLevel >= 3);
    if ($len == 0) {
      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $v\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    $idx += 6;
  }

  return $errorCount;
}

sub evaluate_RSP_K23_ERR {
  my ($logLevel, $mesaRSP, $testRSP) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_RSP_K23_PID $mesaRSP $testRSP\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"ERR", " 4", " 2", "Severity               ", "HL7 2.5 Ch 2 2.15.5",
  );
  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx];
    my $field     = $nonZeroFields[$idx+1];
    my $maxLen    = $nonZeroFields[$idx+2];
    my $fieldName = $nonZeroFields[$idx+3];
    my $reference = $nonZeroFields[$idx+4];

    my ($status, $v) = mesa::getFieldLog($logLevel, $testRSP, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testRSP\n";
      return 1;         # Non-zero error count
    }
    my $len = length ($v);
    print main::LOG "CTX: $segment $field $fieldName: <$v> length: $len\n" if ($logLevel >= 3);

    if ($len == 0) {
      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $v\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    }
    $idx += 5;
  }

  @equivalentFields = (
	"ERR", " 2", "0", " 80", "Error Location         ", "ITI TF-2 3.9.4.2.2.6",
	"ERR", " 3", "0", " 80", "Error Code             ", "ITI TF-2 3.9.4.2.2.6",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx];
    my $field     = $equivalentFields[$idx+1];
    my $component = $equivalentFields[$idx+2];
    my $maxLen    = $equivalentFields[$idx+3];
    my $fieldName = $equivalentFields[$idx+4];
    my $reference = $equivalentFields[$idx+5];

    ($status, $vTest) = mesa::getFieldLog($logLevel, $testRSP, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testRSP\n";
      return 1;         # Non-zero error count
    }
    ($status, $vMESA) = mesa::getFieldLog($logLevel, $mesaRSP, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaRSP\n";
      return 1;         # Non-zero error count
    }
    my $len = length ($vTest);
    print main::LOG "CTX: $segment $field $fieldName: <$vTest> length: $len\n" if ($logLevel >= 3);
    if ($len == 0) {
      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $v\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    $idx += 6;
  }

  return $errorCount;
}

sub evaluate_PDQ_ACK {
  my ($logLevel, $mesaACK, $testACK) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_evaluate_PDQ_ACK $mesaACK $testACK\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", "20", "Message Control ID     ", "ITI TF-2",
  );
  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx];
    my $field     = $nonZeroFields[$idx+1];
    my $maxLen    = $nonZeroFields[$idx+2];
    my $fieldName = $nonZeroFields[$idx+3];
    my $reference = $nonZeroFields[$idx+4];

    my ($status, $v) = mesa::getFieldLog($logLevel, $testACK, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testACK\n";
      return 1;         # Non-zero error count
    }
    my $len = length ($v);
    print main::LOG "CTX: $segment $field $fieldName: <$v> length: $len\n" if ($logLevel >= 3);

    if ($len == 0) {
      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $v\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    }
    $idx += 5;
  }

  @equivalentFields = (
#	"MSH", " 9", "0", "  7", "Message Type           ", "ITI TF-2 ",
	"MSH", " 9", "1", "  3", "Message Type           ", "ITI TF-2 ",
	"MSH", " 9", "2", "  3", "Message Type           ", "ITI TF-2 ",
	"MSH", "11", "0", "  3", "Processing ID          ", "ITI TF-2",
	"MSH", "12", "0", " 60", "Version ID             ", "ITI TF-2",
	"MSA", " 1", "0", "  2", "Acknowledgment Code    ", "ITI TF-2 Table C.1-2",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx];
    my $field     = $equivalentFields[$idx+1];
    my $component = $equivalentFields[$idx+2];
    my $maxLen    = $equivalentFields[$idx+3];
    my $fieldName = $equivalentFields[$idx+4];
    my $reference = $equivalentFields[$idx+5];

    ($status, $vTest) = mesa::getFieldLog($logLevel, $testACK, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testRSP\n";
      return 1;         # Non-zero error count
    }
    ($status, $vMESA) = mesa::getFieldLog($logLevel, $mesaACK, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaRSP\n";
      return 1;         # Non-zero error count
    }
    my $len = length ($vTest);
    print main::LOG "CTX: $segment $field $fieldName: <$vTest> length: $len\n" if ($logLevel >= 3);
    if ($len == 0) {
      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $v\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    $idx += 6;
  }

  return $errorCount;
}

sub evaluate_PDQ_RSP_K22_baseline {
  my ($logLevel, $mesaRSP, $testRSP) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_PDQ_RSP_K22 $mesaRSP $testRSP\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", "20", "Message Control ID     ", "ITI TF-2",
  );
  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx];
    my $field     = $nonZeroFields[$idx+1];
    my $maxLen    = $nonZeroFields[$idx+2];
    my $fieldName = $nonZeroFields[$idx+3];
    my $reference = $nonZeroFields[$idx+4];

#    my ($status, $v) = mesa::getFieldLog($logLevel, $testRSP, $segment, $field, "0", $fieldName);
    my ($status, $v) = mesa_get::getHL7Field($logLevel, $testRSP, $segment, $field, "0", $fieldName, "2.5");
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testRSP\n";
      return 1;         # Non-zero error count
    }
    my $len = length ($v);
    print main::LOG "CTX: $segment $field $fieldName: <$v> length: $len\n" if ($logLevel >= 3);

    if ($len == 0) {
      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $v\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    }
    $idx += 5;
  }

  @equivalentFields = (
#	"MSH", " 9", "0", "  7", "Message Type           ", "ITI TF-2 ",
	"MSH", " 9", "1", "  3", "Message Type           ", "ITI TF-2 ",
	"MSH", " 9", "2", "  3", "Message Type           ", "ITI TF-2 ",
	"MSH", "11", "0", "  3", "Processing ID          ", "ITI TF-2",
	"MSH", "12", "0", " 60", "Version ID             ", "ITI TF-2",
	"QAK", " 2", "0", "  2", "Query Reponse Status   ", "ITI TF-2 Table 3.9-4",
	"QPD", " 1", "0", " 60", "Message Query Name     ", "ITI TF-2 Table 3.21-2",
	"QPD", " 3", "0", " 60", "Demographics Field     ", "ITI TF-2 Table 3.21-2",
	"QPD", " 8", "0", " 60", "Domains returned       ", "ITI TF-2 Table 3.21-2",
	"MSA", " 1", "0", "  2", "Acknowledgment Code    ", "ITI TF-2 Table C.1-2",
	"PID", " 3", "0", "250", "PID List               ", "ITI TF-2 Table 3.8-2",
	"PID", " 5", "0", "250", "Name                   ", "ITI TF-2 Table 3.8-2",
	"PID", " 7", "0", " 26", "DOB                    ", "ITI TF-2 Table 3.8-2",
	"PID", " 8", "0", "  1", "Administrative Sex     ", "ITI TF-2 Table 3.8-2",
	"PID", "11", "0", "250", "Patient Address        ", "ITI TF-2 Table 3.8-2",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx];
    my $field     = $equivalentFields[$idx+1];
    my $component = $equivalentFields[$idx+2];
    my $maxLen    = $equivalentFields[$idx+3];
    my $fieldName = $equivalentFields[$idx+4];
    my $reference = $equivalentFields[$idx+5];

    ($status, $vTest) = mesa::getFieldLog($logLevel, $testRSP, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testRSP\n";
      return 1;         # Non-zero error count
    }
    ($status, $vMESA) = mesa::getFieldLog($logLevel, $mesaRSP, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaRSP\n";
      return 1;         # Non-zero error count
    }
    if ($segment eq "PID") {
      $vTest =~ tr/a-z/A-Z/;
      $vMESA =~ tr/a-z/A-Z/;
    }
    my $len = length ($vTest);
    print main::LOG "CTX: $segment $field $fieldName: <$vTest> length: $len\n" if ($logLevel >= 3);

    if ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    $idx += 6;
  }

  return $errorCount;
}

# Evaluate a PDQ reponse but do not evaluate any data in the PID

sub evaluate_PDQ_RSP_K22_no_PID {
  my ($logLevel, $mesaRSP, $testRSP) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_PDQ_RSP_K22_no_PID $mesaRSP $testRSP\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", "20", "Message Control ID     ", "ITI TF-2",
  );
  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx];
    my $field     = $nonZeroFields[$idx+1];
    my $maxLen    = $nonZeroFields[$idx+2];
    my $fieldName = $nonZeroFields[$idx+3];
    my $reference = $nonZeroFields[$idx+4];

    my ($status, $v) = mesa::getFieldLog($logLevel, $testRSP, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testRSP\n";
      return 1;         # Non-zero error count
    }
    my $len = length ($v);
    print main::LOG "CTX: $segment $field $fieldName: <$v> length: $len\n" if ($logLevel >= 3);

    if ($len == 0) {
      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $v\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    }
    $idx += 5;
  }

  @equivalentFields = (
#	"MSH", " 9", "0", "  7", "Message Type           ", "ITI TF-2 ",
	"MSH", " 9", "1", "  3", "Message Type           ", "ITI TF-2 ",
	"MSH", " 9", "2", "  3", "Message Type           ", "ITI TF-2 ",
	"MSH", "11", "0", "  3", "Processing ID          ", "ITI TF-2",
	"MSH", "12", "0", " 60", "Version ID             ", "ITI TF-2",
	"QAK", " 2", "0", "  2", "Query Reponse Status   ", "ITI TF-2 Table 3.9-4",
	"QPD", " 1", "0", " 60", "Message Query Name     ", "ITI TF-2 Table 3.21-2",
	"QPD", " 3", "0", " 60", "Demographics Field     ", "ITI TF-2 Table 3.21-2",
	"QPD", " 8", "0", " 60", "Domains returned       ", "ITI TF-2 Table 3.21-2",
	"MSA", " 1", "0", "  2", "Acknowledgment Code    ", "ITI TF-2 Table C.1-2",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx];
    my $field     = $equivalentFields[$idx+1];
    my $component = $equivalentFields[$idx+2];
    my $maxLen    = $equivalentFields[$idx+3];
    my $fieldName = $equivalentFields[$idx+4];
    my $reference = $equivalentFields[$idx+5];

    ($status, $vTest) = mesa::getFieldLog($logLevel, $testRSP, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testRSP\n";
      return 1;         # Non-zero error count
    }
    ($status, $vMESA) = mesa::getFieldLog($logLevel, $mesaRSP, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaRSP\n";
      return 1;         # Non-zero error count
    }
    my $len = length ($vTest);
    print main::LOG "CTX: $segment $field $fieldName: <$vTest> length: $len\n" if ($logLevel >= 3);

    if ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    $idx += 6;
  }

  return $errorCount;
}

sub evaluate_PDQ_RSP_K22_Continuation {
  my ($logLevel, $mesaRSP, $testRSP) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_PDQ_RSP_K22_Continuation $mesaRSP $testRSP\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", "20", "Message Control ID     ", "ITI TF-2",
	"DSC", "1", "180", "Continuation Pointer   ", "ITI TF-2 3.21.4.1.2.4",
  );
  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx];
    my $field     = $nonZeroFields[$idx+1];
    my $maxLen    = $nonZeroFields[$idx+2];
    my $fieldName = $nonZeroFields[$idx+3];
    my $reference = $nonZeroFields[$idx+4];

    my ($status, $v) = mesa::getFieldLog($logLevel, $testRSP, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testRSP\n";
      return 1;         # Non-zero error count
    }
    my $len = length ($v);
    print main::LOG "CTX: $segment $field $fieldName: <$v> length: $len\n" if ($logLevel >= 3);

    if ($len == 0) {
      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $v\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    }
    $idx += 5;
  }

  @equivalentFields = (
#	"MSH", " 9", "0", "  7", "Message Type           ", "ITI TF-2 ",
	"MSH", " 9", "1", "  3", "Message Type           ", "ITI TF-2 ",
	"MSH", " 9", "2", "  3", "Message Type           ", "ITI TF-2 ",
	"MSH", "11", "0", "  3", "Processing ID          ", "ITI TF-2",
	"MSH", "12", "0", " 60", "Version ID             ", "ITI TF-2",
	"QAK", " 2", "0", "  2", "Query Reponse Status   ", "ITI TF-2 Table 3.9-4",
	"QPD", " 1", "0", " 60", "Message Query Name     ", "ITI TF-2 Table 3.21-2",
	"QPD", " 3", "0", " 60", "Demographics Field     ", "ITI TF-2 Table 3.21-2",
	"QPD", " 8", "0", " 60", "Domains returned       ", "ITI TF-2 Table 3.21-2",
	"MSA", " 1", "0", "  2", "Acknowledgment Code    ", "ITI TF-2 Table C.1-2",
	"DSC", " 2", "0", "  1", "Continuation Style     ", "ITI TF-2 Table 3.21-9",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx];
    my $field     = $equivalentFields[$idx+1];
    my $component = $equivalentFields[$idx+2];
    my $maxLen    = $equivalentFields[$idx+3];
    my $fieldName = $equivalentFields[$idx+4];
    my $reference = $equivalentFields[$idx+5];

    ($status, $vTest) = mesa::getFieldLog($logLevel, $testRSP, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testRSP\n";
      return 1;         # Non-zero error count
    }
    ($status, $vMESA) = mesa::getFieldLog($logLevel, $mesaRSP, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaRSP\n";
      return 1;         # Non-zero error count
    }
    my $len = length ($vTest);
    print main::LOG "CTX: $segment $field $fieldName: <$vTest> length: $len\n" if ($logLevel >= 3);

    if ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    $idx += 6;
  }

  return $errorCount;
}

sub evaluate_PDQ_QBP_Q22 {
  my ($logLevel, $mesaQ22, $testQ22) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_PDQ_QBP_Q22 $mesaQ22 $testQ22\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", "20", "Message Control ID     ", "ITI TF-2",
  );
  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx];
    my $field     = $nonZeroFields[$idx+1];
    my $maxLen    = $nonZeroFields[$idx+2];
    my $fieldName = $nonZeroFields[$idx+3];
    my $reference = $nonZeroFields[$idx+4];

    my ($status, $v) = mesa::getFieldLog($logLevel, $testQ22, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testQ22\n";
      return 1;         # Non-zero error count
    }
    my $len = length ($v);
    print main::LOG "CTX: $segment $field $fieldName: <$v> length: $len\n" if ($logLevel >= 3);

    if ($len == 0) {
      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $v\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    }
    $idx += 5;
  }

  @equivalentFields = (
#	"MSH", " 9", "0", " 15", "Message Type           ", "ITI TF-2 ",
	"MSH", " 9", "1", "  3", "Message Type           ", "ITI TF-2 ",
	"MSH", " 9", "2", "  3", "Message Type           ", "ITI TF-2 ",
	"MSH", "11", "0", "  3", "Processing ID          ", "ITI TF-2",
	"MSH", "12", "0", " 60", "Version ID             ", "ITI TF-2",
	"QPD", " 1", "0", "250", "Message Query Name     ", "ITI TF-2",
	"QPD", " 3", "0", " 60", "Demographics Field     ", "ITI TF-2",
	"QPD", " 8", "0", " 60", "Domains returned       ", "ITI TF-2",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx];
    my $field     = $equivalentFields[$idx+1];
    my $component = $equivalentFields[$idx+2];
    my $maxLen    = $equivalentFields[$idx+3];
    my $fieldName = $equivalentFields[$idx+4];
    my $reference = $equivalentFields[$idx+5];

    ($status, $vTest) = mesa::getFieldLog($logLevel, $testQ22, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testQ22\n";
      return 1;         # Non-zero error count
    }
    ($status, $vMESA) = mesa::getFieldLog($logLevel, $mesaQ22, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaQ22\n";
      return 1;         # Non-zero error count
    }
    my $len = length ($vTest);
    print main::LOG "CTX: $segment $field $fieldName: <$vTest> length: $len\n" if ($logLevel >= 3);
#    if ($len == 0) {
#      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
#      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
#      $errorCount++;
#    }
    if ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    $idx += 6;
  }

  return $errorCount;
}

sub evaluate_PDQ_QBP_Q22_continuation {
  my ($logLevel, $mesaQ22, $testQ22) = @_;
  my $errorCount = 0;

  print main::LOG "CTX: mesa::evaluate_PDQ_QBP_Q22_continuation $mesaQ22 $testQ22\n" if ($logLevel >= 3);
  my $len = 0;

  @nonZeroFields = (
	"MSH", "10", "20", "Message Control ID     ", "ITI TF-2",
  );
  my $idx = 0;
  while ($idx < scalar(@nonZeroFields)) {
    my $segment   = $nonZeroFields[$idx];
    my $field     = $nonZeroFields[$idx+1];
    my $maxLen    = $nonZeroFields[$idx+2];
    my $fieldName = $nonZeroFields[$idx+3];
    my $reference = $nonZeroFields[$idx+4];

    my ($status, $v) = mesa::getFieldLog($logLevel, $testQ22, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testQ22\n";
      return 1;         # Non-zero error count
    }
    my $len = length ($v);
    print main::LOG "CTX: $segment $field $fieldName: <$v> length: $len\n" if ($logLevel >= 3);

    if ($len == 0) {
      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $v\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    }
    $idx += 5;
  }

  @equivalentFields = (
#	"MSH", " 9", "0", " 15", "Message Type           ", "ITI TF-2 ",
	"MSH", " 9", "1", "  3", "Message Type           ", "ITI TF-2 ",
	"MSH", " 9", "2", "  3", "Message Type           ", "ITI TF-2 ",
	"MSH", "11", "0", "  3", "Processing ID          ", "ITI TF-2",
	"MSH", "12", "0", " 60", "Version ID             ", "ITI TF-2",
	"QPD", " 1", "0", "250", "Message Query Name     ", "ITI TF-2",
	"QPD", " 3", "0", " 60", "Demographics Field     ", "ITI TF-2",
	"QPD", " 8", "0", " 60", "Domains returned       ", "ITI TF-2",
	"DSC", " 1", "0", "180", "Continuation Pointer   ", "ITI TF-2 Table 3.21-9",
	"DSC", " 2", "0", "  1", "Continuation Style     ", "ITI TF-2 Table 3.21-9",
  );

  $idx = 0;
  while ($idx < scalar(@equivalentFields)) {
    my $segment   = $equivalentFields[$idx];
    my $field     = $equivalentFields[$idx+1];
    my $component = $equivalentFields[$idx+2];
    my $maxLen    = $equivalentFields[$idx+3];
    my $fieldName = $equivalentFields[$idx+4];
    my $reference = $equivalentFields[$idx+5];

    ($status, $vTest) = mesa::getFieldLog($logLevel, $testQ22, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $testQ22\n";
      return 1;         # Non-zero error count
    }
    ($status, $vMESA) = mesa::getFieldLog($logLevel, $mesaQ22, $segment, $field, $component, $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $mesaQ22\n";
      return 1;         # Non-zero error count
    }
    my $len = length ($vTest);
    print main::LOG "CTX: $segment $field $fieldName: <$vTest> length: $len\n" if ($logLevel >= 3);
#    if ($len == 0) {
#      print main::LOG "ERR: $segment $field : $fieldName List should not be zero length\n";
#      print main::LOG "REF: See $reference\n" if ($logLevel >= 4);
#      $errorCount++;
#    }
    if ($len > $maxLen) {
      print main::LOG "ERR: $segment $field: $fieldName length is constrained to $maxLen characters\n";
      print main::LOG "ERR: $segment $field: Your length is $len\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "REF: $reference\n" if ($logLevel >= 4);
      $errorCount++;
    } elsif ($vTest ne $vMESA) {
      print main::LOG "ERR: $segment $field $fieldName test value does not equal MESA value\n";
      print main::LOG "ERR: Test value: $vTest\n";
      print main::LOG "ERR: MESA value: $vMESA\n";
      $errorCount++;
    }
    $idx += 6;
  }

  return $errorCount;
}


sub dumpQBPMessage {
  my ($logLevel, $qbpMessage) = @_;

  @fieldNames = (
	"QPD", " 1", "250", "Message Query Name     ", "ITI TF-2 Table 3.9-2 ",
	"QPD", " 2", " 32", "Query Tag              ", "ITI TF-2 Table 3.9-2",
	"QPD", " 3", "250", "Person Identifier      ", "ITI TF-2 Table 3.9-2",
	"QPD", " 4", "250", "What Domains Returned  ", "ITI TF-2 Table 3.9-2",
  );

  print main::LOG "$qbpMessage\n";

  $idx = 0;
  while ($idx < scalar(@fieldNames)) {
    my $segment   = $fieldNames[$idx];
    my $field     = $fieldNames[$idx+1];
    my $maxLen    = $fieldNames[$idx+2];
    my $fieldName = $fieldNames[$idx+3];
    my $reference = $fieldNames[$idx+4];

    ($status, $vTest) = mesa::getFieldLog($logLevel, $qbpMessage, $segment, $field, "0", $fieldName);
    if ($status != 0) {
      print main::LOG "Could not get HL7 Field for $segment, $field, $fieldName\n";
      print main::LOG "File name is $qbpMessage\n";
      return 1;         # Non-zero error count
    }
    print main::LOG "$segment $field $fieldName $vTest\n";
    $idx += 5;
  }
  return 0;
}

sub validate_xml_schema {
  my $level = shift(@_);
  my $schema = shift(@_);
  my $navFile = shift(@_);

  $rtnValueEval = 1;

  print "\nEvaluating $navFile\n";
  print main::LOG "\nEvaluating $navFile\n";
  my $x = "$main::MESA_TARGET/bin/mesa_xml_eval ";
  $x .= " -l $level ";
  $x .= " -s $schema ";
  $x .= " $navFile";

  print main::LOG "$x \n";
  print main::LOG `$x`;
  if ($? == 0) {
    $rtnValueEval = 0;
  } else {
    print main::LOG "NAV xml document manifest $navFile does not pass evaluation.\n";
  }

  return $rtnValueEval;
}

1;
