#!/usr/local/bin/perl -w

use Env;

use lib "../../../rad/actors/common/scripts";
require mesa;

sub goodbye() {
  exit 1;
}

sub evaluate_ORU_PDF {
  my ($logLevel, $testORU) = @_;
  my $errorCount = 0;
  print main::LOG "CTX: mesa::evaluate_ORU_PDF $testORU\n" if ($logLevel >= 3);
  my $len = 0;

  my $obr25 = mesa::getField($testORU, "OBR", "25", "0", "Result Status");
  print main::LOG "CTX: OBR 25: Result Status retrieved from HL7 message is $obr25 \n"if ($logLevel >= 3);
  if ($obr25 ne "R" && $obr25 ne "P" && $obr25 ne "F" && $obr25 ne "C"){
    print main::LOG "ERR: OBR 25: ORB Result Status should be R/P/F/C\n";
    print main::LOG "REF: OBR 25: See TF Vol II, Table 4.7-6\n" if ($logLevel >= 4);
    $errorCount++;
  }
  print main::LOG "\n";
  my $index = 1;
  while($index <= 2){
    my $obx2 = mesa::getHL7FieldWithSegmentIndex($logLevel, $testORU, "OBX", $index, "2", "0", "Value Type");
    if ($obx2 eq "HD"){
      print main::LOG "CTX: OBX segment $index: Value Type HD\n"if ($logLevel >= 3);
      $errorCount += checkOBXWithSID($logLevel,$testORU,$index);
    }elsif ($obx2 eq "ED") {
      print main::LOG "CTX: OBX segment $index: Value Type ED\n"if ($logLevel >= 3);
      $errorCount += checkOBXWithPDF($logLevel,$testORU,$index,$obr25);
    }else{
      # the OBX segment is not with Dicom Study Instance UID or with Encapulated PDF, and will not be processed.
    }
    $index++;
  }
  return $errorCount;
}

sub checkOBXWithPDF{
  my ($logLevel,$testORU,$index,$obr25) = @_;
		  
  my $errorCount = 0;
  my $obx3 = mesa::getHL7FieldWithSegmentIndex($logLevel, $testORU, "OBX", $index, "3", "0", "Observation Identifier");
  my $found = 0;
  my @rpt_titles = ('18745-0^Cardiac Catheterization Report^LN',
		  '18750-0^Cardiac Electrophysiology Report^LN',
		  '18747-6^CT Report^LN',
		  '11540-2^CT Abdomen Report^LN',
		  '11538-6^CT Chest Report^LN',
		  '11539-4^CT Head Report^LN',
		  '18748-4^Diagnostic Imaging Report^LN',
		  '11522-0^Echocardiography Report^LN',
		  '11524-0^ECG Report^LN',
		  '18752-6^Exercise Stress Test Report^LN',
		  '18754-2^Holter Study Report^LN',
		  '18755-9^MRI Report^LN',
		  '77541-0^MRI Head Report^LN',
		  '18756-7^MRI Spine Report^LN',
		  '18757-5^Nuclear Medicine Report^LN',
		  '18758-3^PET Scan Report^LN',
		  '11528-7^Radiology Report^LN',
		  '18760-9^Ultrasound Report^LN',
		  '11525-3^Ultrasound Obstetric and Gyn Report^LN');
  foreach $t (@rpt_titles){
    #print main::LOG "CTX: $t\n" if ($logLevel >= 3);
    if($t eq $obx3){
      $found = 1;
      last;
    }
  }
  print main::LOG "CTX: OBX 3: Observation Identifier retrieved from HL7 message is \"$obx3\" \n"if ($logLevel >= 3);
  if(!$found){
    print main::LOG "ERR: OBX 3: OBX Observation Identifier shall as a default use document names from HIPPA attachments class of the LOINC coding scheme,i.e.,terms with scale \"DOC\".\n";
    print main::LOG "REF: OBX 3: See TF Vol II, Appendix D\n" if ($logLevel >= 4);
    $errorCount++;
  }
  print main::LOG "\n";
  
  my $obx5_1 = mesa::getHL7FieldWithSegmentIndex($logLevel, $testORU, "OBX", $index, "5", "1", "Observation Value Source Application ID");
  my $obx5_2 = mesa::getHL7FieldWithSegmentIndex($logLevel, $testORU, "OBX", $index, "5", "2", "Observation Value Type of Data");
  my $obx5_3 = mesa::getHL7FieldWithSegmentIndex($logLevel, $testORU, "OBX", $index, "5", "3", "Observation Value Data Subtype");
  print main::LOG "CTX: OBX 5: OBX Source Application ID for Observation Value should include a valid ISO OID\n";
  print main::LOG "CTX: OBX 5: OBX Source Application ID for Observation Value in this message is \"$obx5_1\"\n";
  if ($obx5_2 ne "Application"){
    print main::LOG "ERR: OBX 5: OBX Type of Data for Observation Value should be \"Application\"\n";
    print main::LOG "ERR: OBX 5: OBX Type of Date retrieved from HL7 message is \"$obx5_2\"\n";
    print main::LOG "REF: OBX 5: See TF Vol II, Table 4.7-8\n" if ($logLevel >= 4);
    $errorCount++;
  }
  if ($obx5_3 ne "PDF"){
    print main::LOG "ERR: OBX 5: OBX Data Subtype for Observation Value should be \"PDF\"\n";
    print main::LOG "ERR: OBX 5: OBX Type Subtype for Observation Value retrieved from HL7 message is \"$obx5_3\"\n";
    print main::LOG "REF: OBX 5: See TF Vol II, Table 4.7-8\n" if ($logLevel >= 4);
    $errorCount++;
  }
  print main::LOG "\n";
  
  #Check OBX11
  my $obx11 = mesa::getHL7FieldWithSegmentIndex($logLevel, $testORU, "OBX", $index, "11", "0", "Observation Result Status");
  print main::LOG "CTX: OBX 11: OBX Observation Result Status retrieved from HL7 message is \"$obx11\"\n" if ($logLevel >= 3);
  if ($obx11 ne $obr25){
    print main::LOG "ERR: OBX 11: OBX Observation Result Status should match OBR25: $obr25\n";
    $errorCount++;
  }
  if ($obx11 ne "R" && $obx11 ne "P" && $obx11 ne "F" && $obx11 ne "C"){
    print main::LOG "ERR: OBX 11: OBX Observation Result Status should be \"R\" or \"P\" or \"F\" or \"C\"\n";
    print main::LOG "REF: OBX 11: See TF Vol II, Table 4.7-9\n" if ($logLevel >= 4);
    $errorCount++;
  }
  print main::LOG "\n";
  return $errorCount;
}

sub checkOBXWithSID{
  my ($logLevel,$testORU,$index) = @_;
  my $errorCount = 0;
  my $obx3 = mesa::getHL7FieldWithSegmentIndex($logLevel, $testORU, "OBX", $index, "3", "0", "Observation Identifier");
  
  print main::LOG "CTX: OBX 3: OBX Observation Identifier retrieved from HL7 message is \"$obx3\" \n"if ($logLevel >= 3);
  if ($obx3 ne "113014^DICOM Study^DCM"){
    print main::LOG "ERR: OBX 3: OBX Observation Identifier should be \"113014^DICOM Study^DCM\"\n";
    print main::LOG "REF: OBX 3: See TF Vol II, Table 4.7-7\n" if ($logLevel >= 4);
    $errorCount++;
  }
  print main::LOG "\n";
  
  my $obx5 = mesa::getHL7FieldWithSegmentIndex($logLevel, $testORU, "OBX", $index, "5", "0", "Observation Value");
  print main::LOG "CTX: OBX 5: OBX Observation Value should include Study Instance UID as ISO OID\n";
  print main::LOG "CTX: OBX 5: The OBX Observation Value retrieved from HL7 message is \"$obx5\"\n";
  print main::LOG "\n";
  
  my $obx11 = mesa::getHL7FieldWithSegmentIndex($logLevel, $testORU, "OBX", $index, "11", "0", "Observation Result Status");
  print main::LOG "CTX: OBX 11: OBX Observation Result Status retrieved from HL7 message is \"$obx11\" \n"if ($logLevel >= 3);
  if ($obx11 ne "O"){
    print main::LOG "ERR: OBX 11: OBX Observation Result Status should be \"O\"\n";
    print main::LOG "REF: OBX 11: See TF Vol II, Table 4.7-7\n" if ($logLevel >= 4);
    $errorCount++;
  }
  print main::LOG "\n";
  
  return $errorCount;
}

### Main starts here
die "Usage: <log level: 1-4>" if (scalar(@ARGV) < 1);

$logLevel     = $ARGV[0];
open LOG, ">20501/grade_20501.txt" or die "?!";
$diff = 0;

$diff += evaluate_ORU_PDF($logLevel, "$MESA_STORAGE/ordplc/1001.hl7");

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 20501/grade_20501.txt \n";
print "Please check OBX-5 which is stored in 20501/grade_20501.txt \n";

exit $diff;
