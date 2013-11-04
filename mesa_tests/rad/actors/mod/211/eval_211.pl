#!/usr/local/bin/perl -w

# Evaluate images, storage commitment and MPPS messages
# sent by a modality for test 211.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require mod;
require mesa_common;
require mesa_evaluate;

sub dummy {}

sub goodbye {}

sub x_211_1 {
  print LOG "CTX Modality Test 211.1 \n";
  print LOG "CTX  Evaluation of Composite Object \n";
  print LOG "CTX  PPS X1/X1_A1 \n";

  my ($level, $language) = @_;

  my $masterFile = "$MESA_STORAGE/modality/T211/x1.dcm";

  $x = "$MESA_TARGET/bin/dcm_print_element -s 0040 0275 0040 0009 $masterFile";
  print LOG "CTX $x\n" if $level > 2;
  my $spsID = `$x`;
  chomp $spsID;
  print LOG "CTX Patient ID: MM211, SPS ID: $spsID \n";

  my $v = 0;
  $v = 1 if $level > 2;
  my @testImages = mod::find_images_by_patient_sps_id($v, "MM211", $spsID);

  $count = scalar(@testImages);
  print LOG "CTX Found $count images for Patient ID MM211, SPS ID $spsID \n" if $level > 2;

  if (scalar(@testImages) == 0) {
    print LOG "ERR No images are found for Patient ID MM211, SPS ID $spsID \n";
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

sub x_211_2 {
  print LOG "CTX Modality Test 211.2 \n";

  my ($level, $language, $aet, $protocolCodeFlag) = @_;

  my $masterFile = "$MESA_STORAGE/modality/T211/mpps.status";
  my @mpps = mod::find_mpps_dir_by_patient_id(0, $aet, "MM211");
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "ERR Found $count MPPS directories for patient ID MM211 and AE Title $aet \n";
    print LOG "ERR Expected to find exactly 1 MPPS directory.\n";
    print LOG "ERR You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  $testFile = "$mpps[0]/mpps.dcm";

  my $rtnValue = mesa::eval_mpps_scheduled($level, $protocolCodeFlag, $aet, $masterFile, $testFile);

  print LOG "\n";
  return $rtnValue;
}

sub x_211_3 {
  print LOG "CTX Modality Test 211.3 \n";
  print LOG "CTX  Extened Evaluation of Composite Object \n";

  my ($level, $language) = @_;

  my $masterFile = "$MESA_STORAGE/modality/T211/x1.dcm";

  $x = "$MESA_TARGET/bin/dcm_print_element -s 0040 0275 0040 0009 $masterFile";
  print LOG "CTX $x\n" if $level > 2;
  my $spsID = `$x`;
  chomp $spsID;
  print LOG "CTX Patient ID: MM211, SPS ID: $spsID \n";

  my $v = 0;
  $v = 1 if $level > 2;
  my @testImages = mod::find_images_by_patient_sps_id($v, "MM211", $spsID);

  $count = scalar(@testImages);
  print LOG "CTX Found $count images for Patient ID MM211, SPS ID $spsID \n" if $level > 2;

  if (scalar(@testImages) == 0) {
    print LOG "ERR No images are found for Patient ID MM211, SPS ID $spsID \n";
    print LOG "ERR Failure for Performed Procedure X1/X1_A1 \n";
    return 1;
  }

  $testFile = $testImages[0];
  print LOG "CTX $testFile \n" if $level > 2;

  $rtnValue = mesa::eval_dicom_image_extended($level, $masterFile, $testFile);

  print LOG "\n";
  return $rtnValue;
}

sub x_211_4 {
  print LOG "CTX Modality Test 211.4 \n";
  print LOG "CTX Examing Specific Character set in MPPS message\n";

  my ($level, $language, $aet, $protocolCodeFlag) = @_;

  my $masterFile = "$MESA_STORAGE/modality/T211/mpps.status";
  my @mpps = mod::find_mpps_dir_by_patient_id(0, $aet, "MM211");
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "ERR Found $count MPPS directories for patient ID MM211 and AE Title $aet \n";
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

$outputLevel = $ARGV[0];
$logLevel = $outputLevel;
$aeTitle = $ARGV[1];
$protocolCodeFlag = $ARGV[2];
$language = "";
$language = $ARGV[3] if (scalar(@ARGV) > 3);

open LOG, ">211/grade_211.txt" or die "?!";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);
        
print LOG "CTX: Test:    211\n";
print LOG "CTX: Actor:   MOD\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

$diff += x_211_1($outputLevel, $language);

$diff += x_211_2($outputLevel, $language, $aeTitle, $protocolCodeFlag);
$diff += x_211_3($outputLevel, $language);
$diff += x_211_4($outputLevel, $language, $aeTitle, $protocolCodeFlag);

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("211/grade_211.txt", "211/mir_mesa_211.xml",
        $logLevel, "211", "MOD", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "\nThis test completed with zero errors; that means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 211/grade_211.txt and 211/mir_mesa_211.xml\n";
}

print "If you are submitting a result file to Kudu, submit 211/mir_mesa_211.xml\n\n";


