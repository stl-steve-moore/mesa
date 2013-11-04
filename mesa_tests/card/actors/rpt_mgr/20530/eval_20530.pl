#!/usr/local/bin/perl -w

use Env;

use lib "../../../rad/actors/common/scripts";
require evaluate_tfcte;
require mesa;

sub goodbye() {
  exit 1;
}

sub validatePDFReport {
  my ($logLevel, $mesaMsg, $testMsg) = @_;
  
  # From MESA message
  $mesaPatientIDInfo = mesa::getField($mesaMsg, "PID", "3", "0", "Patient ID");
  $mesaPatientIDInfo =~ /(.*)\^\^\^/;
  $mesaPatientID = $1;
  $mesaPatientName = mesa::getField($mesaMsg, "PID", "5", "0", "Patient Name");
  $mesaStudyUID = mesa::getHL7FieldWithSegmentIndex($logLevel, $mesaMsg, "OBX", "1", "5", "0", "Observation Value");
  $mesaReportTitle = mesa::getHL7FieldWithSegmentIndex($logLevel, $mesaMsg, "OBX", "2", "3", "0", "Observation Identifier");
  $mesaReportStatus = mesa::getHL7FieldWithSegmentIndex($logLevel, $mesaMsg, "OBX", "2", "11", "0", "Observation Result Status");

#print $mesaPatientID.  "\n".$mesaPatientName.  "\n".$mesaStudyUID.  "\n".$mesaReportTitle.  "\n".$mesaReportStatus.  "\n\n";

  # From Test system message
  $testPatientID = mesa::getDICOMAttribute($logLevel, "$testMsg", "0010 0020");
  $testPatientName = mesa::getDICOMAttribute($logLevel, "$testMsg", "0010 0010");
  $testStudyUID = mesa::getDICOMAttribute($logLevel, "$testMsg", "0020 000D");
  $testReportStatus = mesa::getDICOMAttribute($logLevel, "$testMsg", "0040 A493");

  mesa::delete_directory($logLevel, "$main::MESA_STORAGE/tmp");
  mesa::create_directory($logLevel, "$main::MESA_STORAGE/tmp");
  my $dumpOutput = "$main::MESA_STORAGE/tmp/contenceSeqItem.dcm";

  $x = "$main::MESA_TARGET/bin/dcm_dump_element -i 1 0040 a043 \"$testMsg\" $dumpOutput";
  `$x`;

  my ($errorCode1, $code1) = mesa::getDICOMAttribute($logLevel, $dumpOutput, "0008 0100");
  if ($errorCode1) {
        print "Problem finding DICOM Attribute\n";
        return 1;
    }

  my ($errorCode2, $code2) = mesa::getDICOMAttribute($logLevel, $dumpOutput, "0008 0102");
  if ($errorCode2) {
        print "Problem finding DICOM Attribute\n";
        return 1;
    }

  my ($errorCode3, $code3) = mesa::getDICOMAttribute($logLevel, $dumpOutput, "0008 0104");
  if ($errorCode3) {
        print "Problem finding DICOM Attribute\n";
        return 1;
    }

  $testReportTitle = $code1."^".$code3."^".$code2;

# print $testPatientID.  "\n".$testPatientName.  "\n".$testStudyUID.  "\n".$testReportStatus.  "\n".$testReportTitle.  "\n";
  
  # Patient ID
  print LOG "CTX: MESA message has Patient ID:: $mesaPatientID\n";
  print LOG "CTX: Test System message has Patient ID:: $testPatientID\n";
  if ($mesaPatientID eq $testPatientID) {
	print LOG "CTX: Test System has same Patient ID as in MESA \n\n";
  } else {
	print LOG "ERR: Test System has Patient ID which differs from that in MESA \n\n";
    $diff++;
  }

# Patient name
  print LOG "CTX: MESA message has Patient Name:: $mesaPatientName\n";
  print LOG "CTX: Test System message has Patient Name:: $testPatientName\n";
  if ($mesaPatientName eq $testPatientName) {
	print LOG "CTX: Test System has same Patient Name as in MESA \n\n";
  } else {
	print LOG "ERR: Test System has Patient Name which differs from that in MESA \n\n";
    $diff++;
  }

# Study Instance UID
  print LOG "CTX: MESA message has Study Instance UID:: $mesaStudyUID\n";
  print LOG "CTX: Test System message has Study Instance UID:: $testStudyUID\n";
  if ($mesaStudyUID eq $mesaStudyUID) {
	print LOG "CTX: Test System has same Study Instance UID as in MESA \n\n";
  } else {
	print LOG "ERR: Test System has Study Instance UID which differs from that in MESA \n\n";
    $diff++;
  }

# Report Title
  print LOG "CTX: MESA message has Report Title:: $mesaReportTitle\n";
  print LOG "CTX: Test System message has Report Title:: $testReportTitle\n";
  if ($mesaReportTitle eq $testReportTitle) {
	print LOG "CTX: Test System has same Report Title as in MESA \n\n";
  } else {
	print LOG "ERR: Test System has Report Title which differs from that in MESA \n\n";
    $diff++;
  }

# Report Status
  print LOG "CTX: MESA message has Report Status:: $mesaReportStatus\n";
  print LOG "CTX: Test System message has Report Status:: $testReportStatus\n";
  if ($mesaReportStatus =~ /F|C/) {
    if ($testReportStatus eq "VERIFIED") {
	  print LOG "CTX: Test System has VERIFIED \n\n";
    } else {
	  print LOG "CTX: Test System has UNVERIFIED \n\n";
      $diff++;
    }
  } elsif ($mesaReportStatus =~ /P|R/) {
    if ($testReportStatus eq "UNVERIFIED") {
	  print LOG "CTX: Test System has UNVERIFIED \n\n";
    } else {
	  print LOG "CTX: Test System has VERIFIED \n\n";
      $diff++;
    }
  }
  return $diff;
}

die "Usage <log level: 1-4> " if (scalar(@ARGV) < 1);

$logLevel     = $ARGV[0];

open LOG, ">20530/grade_20530.txt" or die "Could not open output file: 20530/grade_20530.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";

#$pdfClassUID = "1.2.840.10008.5.1.4.1.1.104.1";
$diff = 0;
$testSenario = "20530";

# rpt_manager
# Search the database for the set of composite objects sent by the Report Manager under test
# to the MESA Report Repository
($status, @rep_rpt) = mesa::db_table_retrieval($logLevel,"rpt_repos", "sopins", "filnam");
print LOG "CTX: During test $testSenario, MESA Report Repository has received encapsulated PDF report as DICOM object and is stored at $rep_rpt[0]\n";

$mesaHL7Msg = "../../msgs/rpt/20530/20530.102.r01.hl7";
$testDCMObj = $rep_rpt[0];

$diff += validatePDFReport ($logLevel, $mesaHL7Msg, $testDCMObj);

print LOG "\n";

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 20530/grade_20530.txt \n";

exit $diff;
