#!/usr/local/bin/perl -w

# Evaluate images, storage commitment and MPPS messages
# sent by a modality for test 50202.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require mod;
require mesa_common;
require mesa_evaluate;

sub goodbye {}

sub x_50202_1 {
  print LOG "CTX Modality Test 50202.1 \n";
  print LOG "CTX  Evaluation of Composite Object \n";
  print LOG "CTX  PPS EYE-200/EYE_PC_200 \n";

  my ($level, $language) = @_;

  my $masterFile = "$MESA_STORAGE/modality/T50202/x1.dcm";

  $x = "$MESA_TARGET/bin/dcm_print_element -s 0040 0275 0040 0009 $masterFile";
  print LOG "CTX $x\n" if $level > 2;
  my $spsID = `$x`;
  chomp $spsID;
  print LOG "CTX Patient ID: 50202, SPS ID: $spsID \n";

  my $v = 0;
  $v = 1 if $level > 2;
  my @testImages = mod::find_images_by_patient_sps_id($v, "50202", $spsID);

  $count = scalar(@testImages);
  print LOG "CTX Found $count images for Patient ID 50202, SPS ID $spsID \n" if $level > 2;

  if (scalar(@testImages) == 0) {
    print LOG "ERR No images are found for Patient ID 50202, SPS ID $spsID \n";
    print LOG "ERR Failure for Performed Procedure X1/X1_A1 \n";
    return 1;
  }

  $testFile = $testImages[0];
  print LOG "CTX $testFile \n" if $level > 2;

  if ($language eq "Japanese") {
    $rtnValue = mesa::eval_image_scheduled_Japanese($level, $masterFile, $testFile);
  } else {
    $rtnValue = mod::eval_image_scheduled($level, $v, $masterFile, $testFile);
  }

  print LOG "\n";
  return $rtnValue;
}

sub x_50202_2 {
  print LOG "CTX Modality Test 50202.2 \n";

  my ($level, $language, $aet, $protocolCodeFlag) = @_;

  my $masterFile = "$MESA_STORAGE/modality/T50202/mpps.status";
  my @mpps = mod::find_mpps_dir_by_patient_id(0, $aet, "50202");
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "ERR Found $count MPPS directories for patient ID 50202 and AE Title $aet \n";
    print LOG "ERR Expected to find exactly 1 MPPS directory.\n";
    print LOG "ERR You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  $testFile = "$mpps[0]/mpps.dcm";

  my $rtnValue = mesa::eval_mpps_scheduled($level, $protocolCodeFlag, $aet, $masterFile, $testFile);

  print LOG "\n";
  return $rtnValue;
}

sub x_50202_3 {
  print LOG "CTX Modality Test 50202.3 \n";
  print LOG "CTX  Extened Evaluation of Composite Object \n";

  my ($level, $language) = @_;

  my $masterFile = "$MESA_STORAGE/modality/T50202/x1.dcm";

  $x = "$MESA_TARGET/bin/dcm_print_element -s 0040 0275 0040 0009 $masterFile";
  print LOG "CTX $x\n" if $level > 2;
  my $spsID = `$x`;
  chomp $spsID;
  print LOG "CTX Patient ID: 50202, SPS ID: $spsID \n";

  my $v = 0;
  $v = 1 if $level > 2;
  my @testImages = mod::find_images_by_patient_sps_id($v, "50202", $spsID);

  $count = scalar(@testImages);
  print LOG "CTX Found $count images for Patient ID 50202, SPS ID $spsID \n" if $level > 2;

  if (scalar(@testImages) == 0) {
    print LOG "ERR No images are found for Patient ID 50202, SPS ID $spsID \n";
    print LOG "ERR Failure for Performed Procedure EYE-200/EYE_PC_200\n";
    return 1;
  }

  $testFile = $testImages[0];
  print LOG "CTX $testFile \n" if $level > 2;

  $rtnValue = mesa::eval_dicom_image_extended($level, $masterFile, $testFile);

  print LOG "\n";
  return $rtnValue;
}

sub x_50202_4 {
  print LOG "CTX Modality Test 50202.4 \n";
  print LOG "CTX Examing Specific Character set in MPPS message\n";

  my ($level, $language, $aet, $protocolCodeFlag) = @_;

  my $masterFile = "$MESA_STORAGE/modality/T50202/mpps.status";
  my @mpps = mod::find_mpps_dir_by_patient_id(0, $aet, "50202");
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "ERR Found $count MPPS directories for patient ID 50202 and AE Title $aet \n";
    print LOG "ERR Expected to find exactly 1 MPPS directory.\n";
    print LOG "ERR You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  $testFile = "$mpps[0]/mpps.dcm";

  my $rtnValue = mesa::eval_mpps_extended($level, $protocolCodeFlag, $aet, $masterFile, $testFile);

  print LOG "\n";
  return $rtnValue;
}

### Main starts here

die "Usage: <log level> <AE title of MPPS SCU> [Protocol Code Flag] [Japanese] \n" if (scalar(@ARGV) < 3);

$logLevel = $ARGV[0];
$aeTitle = $ARGV[1];
$protocolCodeFlag = $ARGV[2];
$language = "";
$language = $ARGV[3] if (scalar(@ARGV) > 3);

open LOG, ">50202/grade_50202.txt" or die "?!";
 my $mesaVersion = mesa_get::getMESAVersion();
 my $numericVersion = mesa_get::getMESANumericVersion();
 my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
print LOG "CTX: Test:    50202\n";
print LOG "CTX: Actor:   MOD\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

$diff += x_50202_1($logLevel, $language);

$diff += x_50202_2($logLevel, $language, $aeTitle, $protocolCodeFlag);
$diff += x_50202_3($logLevel, $language);
$diff += x_50202_4($logLevel, $language, $aeTitle, $protocolCodeFlag);
close LOG;

if ($diff == 0) {
  print "\nCTX: 0 errors implies this test has been passed.\n";
} else {
  print "\nERR: $diff errors implies test FAILURE.\n";
}

open LOG, ">50202/mir_mesa_50202.xml" or die "Could not open XML output file: 50202/mir_mesa_50202.xml";


mesa_evaluate::eval_XML_start($logLevel, "50202", "MOD", $numericVersion, $date);
mesa_evaluate::outputCount($logLevel, $diff);
mesa_evaluate::outputPassFail($logLevel, $diff);
if ($logLevel != 4) {
  $diff += 1;
  mesa_evaluate::outputComment($logLevel,
        "Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.");
}
mesa_evaluate::startDetails($logLevel);

open TMP, "<50202/grade_50202.txt" or die "Could not open 50202/grade_50202.txt
for input";
while ($l = <TMP>) {
 print LOG $l;
}
close TMP;

mesa_evaluate::endDetails($logLevel);
mesa_evaluate::endXML($logLevel);
close LOG;

print "\nLogs stored in 50202/grade_50202.txt \n";
print "Submit 50202/mir_mesa_50202.xml for grading\n";

exit $diff;
