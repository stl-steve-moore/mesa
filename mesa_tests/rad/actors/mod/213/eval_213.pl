#!/usr/local/bin/perl -w

# Evaluate images, storage commitment and MPPS messages
# sent by a modality for test 213.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require mod;
require mesa_common;
require mesa_evaluate;

sub dummy {}

sub goodbye { }

sub x_213_1 {
  print LOG "CTX Modality Test 213.1 \n";
  print LOG "CTX  Evaluation of Composite Object \n";
  print LOG "CTX  PPS X8A/X8A_A1 \n";

  my ($level, $language) = @_;
  my $v = 0;
  $v = 1 if ($level > 2);

  my $masterFile = "$MESA_STORAGE/modality/T213_8a/x1.dcm";

  $x = "$MESA_TARGET/bin/dcm_print_element -s 0040 0275 0040 0009 $masterFile";
  print LOG "CTX $x\n" if ($level >= 3);
  my $spsID = `$x`;
  chomp $spsID;
  print LOG "CTX Patient ID: MM213, SPS ID: $spsID \n";

  my @testImages = mod::find_images_by_patient_sps_id($v, "MM213", $spsID);

  $count = scalar(@testImages);
  print LOG "CTXFound $count images for Patient ID MM213, SPS ID $spsID \n" if ($level >= 3);

  if (scalar(@testImages) == 0) {
    print LOG "ERR No images are found for Patient ID MM213, SPS ID $spsID \n";
    print LOG "ERR Failure for Performed Procedure X8A/X8A_A1 \n";
    return 1;
  }

  $testFile = $testImages[0];
  print LOG "CTX $testFile \n" if ($level >= 3);

  if ($language eq "Japanese") {
    $rtnValue = mesa::eval_image_scheduled_Japanese($level, $masterFile, $testFile);
  } else {
    $rtnValue = mod::eval_image_scheduled($level, $v, $masterFile, $testFile);
  }

  print LOG "\n";
  return $rtnValue;
}

sub x_213_2 {
  print LOG "CTX Modality Test 213.2 \n";
  print LOG "CTX  Evaluation of Composite Object \n";
  print LOG "CTX  PPS X8B/X8B_A1 \n";

  my ($level, $language) = @_;
  my $v = 0;
  $v = 1 if ($level > 2);
  my $masterFile = "$MESA_STORAGE/modality/T213_8b/x1.dcm";

  $x = "$MESA_TARGET/bin/dcm_print_element -s 0040 0275 0040 0009 $masterFile";
  print LOG "CTX $x\n" if $verbose;
  my $spsID = `$x`;
  chomp $spsID;
  print LOG "CTX  Patient ID: MM213, SPS ID: $spsID \n";

  my @testImages = mod::find_images_by_patient_sps_id($v, "MM213", $spsID);

  $count = scalar(@testImages);
  print LOG "CTX Found $count images for Patient ID MM213, SPS ID $spsID \n" if $verbose;

  if (scalar(@testImages) == 0) {
    print LOG "ERR No images are found for Patient ID MM213, SPS ID $spsID \n";
    print LOG "ERR Failure for Performed Procedure X8A/X8A_A1 \n";
    return 1;
  }

  $testFile = $testImages[0];
  print LOG "CTX $testFile \n" if $verbose;

  if ($language eq "Japanese") {
    $rtnValue = mesa::eval_image_scheduled_Japanese($level, $masterFile, $testFile);
  } else {
    $rtnValue = mod::eval_image_scheduled($level, $v, $masterFile, $testFile);
  }

  print LOG "\n";
  return $rtnValue;
}

sub x_213_3 {
  print LOG "CTX Modality Test 213.3 \n";
  print LOG "CTX Looking for PPS X8A/X8A_A1 \n";

  my ($level, $language, $aet, $protocolFlag) = @_;
  my $masterFile = "$MESA_STORAGE/modality/T213_8a/mpps.status";

  $spsID = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 0009 $masterFile`;
  chomp $spsID;

  my @mpps = mod::find_mpps_dir_by_patient_id_sps_id(0, $aet, "MM213", $spsID);
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "ERR Found $count MPPS directories for patient ID MM213, SPS ID $spsID \n";
    print LOG "ERR Expected to find exactly 1 MPPS directories.\n";
    print LOG "ERR You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  $testFile = "$mpps[0]/mpps.dcm";

  my $rtnValue = 0;
  if ($language eq "Japanese") {
    $rtnValue = mesa::evaluate_mpps_modality_Japanese($level, $aet, $masterFile, $testFile);
  } else {
    $rtnValue =  mesa::eval_mpps_scheduled($level, $protocolFlag, $aet, $masterFile, $testFile);
  }

  print LOG "\n";
  return $rtnValue;
}

sub x_213_4 {
  print LOG "CTX Modality Test 213.4 \n";
  print LOG "CTX Looking for PPS X8B/X8B_A1 \n";

  my ($level, $language, $aet, $protocolFlag) = @_;
  my $masterFile = "$MESA_STORAGE/modality/T213_8b/mpps.status";

  $spsID = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 0009 $masterFile`;
  chomp $spsID;

  my @mpps = mod::find_mpps_dir_by_patient_id_sps_id(0, $aet, "MM213", $spsID);
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "ERR Found $count MPPS directories for patient ID MM213, SPS ID $spsID \n";
    print LOG "ERR Expected to find exactly 1 MPPS directories.\n";
    print LOG "ERR You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  $testFile = "$mpps[0]/mpps.dcm";

  my $rtnValue = 0;
  if ($language eq "Japanese") {
    $rtnValue = mesa::evaluate_mpps_modality_Japanese($level, $aet, $masterFile, $testFile);
  } else {
    $rtnValue =  mesa::eval_mpps_scheduled($level, $protocolFlag, $aet, $masterFile, $testFile);
  }

  print LOG "\n";
  return $rtnValue;
}

sub x_213_5 {
  print LOG "CTX Modality Test 213.5 \n";
  print LOG "CTX Modality should create different PPS ID for different MPPS\n";

  my ($level, $language, $aet, $protocolFlag) = @_;
  my $masterFile = "$MESA_STORAGE/modality/T213_8a/mpps.status";

  $spsID = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 0009 $masterFile`;
  chomp $spsID;

  my @mpps = mod::find_mpps_dir_by_patient_id_sps_id(0, $aet, "MM213", $spsID);
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "ERR Found $count MPPS directories for patient ID MM213, SPS ID $spsID \n";
    print LOG "ERR Expected to find exactly 1 MPPS directories.\n";
    print LOG "ERR You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  $testFilePPS1 = "$mpps[0]/mpps.dcm";
  $masterFile = "$MESA_STORAGE/modality/T213_8b/mpps.status";

  $spsID = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 0009 $masterFile`;
  chomp $spsID;

  @mpps = mod::find_mpps_dir_by_patient_id_sps_id(0, $aet, "MM213", $spsID);
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "ERR Found $count MPPS directories for patient ID MM213, SPS ID $spsID \n";
    print LOG "ERR Expected to find exactly 1 MPPS directories.\n";
    print LOG "ERR You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  $testFilePPS2 = "$mpps[0]/mpps.dcm";

  if ($level >= 3) {
    print LOG "CTX: Test file 1 $testFilePPS1\n";
    print LOG "CTX: Test file 2 $testFilePPS2\n";
  }

  my $rtnStatus = 0;
  $ppsID1 = `$MESA_TARGET/bin/dcm_print_element 0040 0253 $testFilePPS1`;
  chomp $ppsID1;
  $ppsID2 = `$MESA_TARGET/bin/dcm_print_element 0040 0253 $testFilePPS2`;
  chomp $ppsID2;

  if ($level >= 3) {
    print LOG "CTX: Performed Procedure Step ID 1: $ppsID1\n";
    print LOG "CTX: Performed Procedure Step ID 2: $ppsID2\n";
  }
  if ($ppsID1 eq $ppsID2) {
    print LOG "ERR Modality used the same Performed Procedure Step ID for 2 different MPPS: $ppsID1\n";
    $rtnStatus = 1;
  }
  return $rtnStatus;
}

### Main starts here
die "Usage: <log level> <AE title of MPPS SCU> [Protocol Code Flag] [Japanese] \n" if (scalar(@ARGV) < 3);

$outputLevel = $ARGV[0];
$aeTitle = $ARGV[1];
$protocolCodeFlag = $ARGV[2];
$language = "";
$language = $ARGV[3] if (scalar(@ARGV) > 3);

die "Usage: <log level> <AE title of MPPS SCU> [Japanese] \n" if (scalar(@ARGV) < 2);

open LOG, ">213/grade_213.txt" or die "?!";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    213\n";
print LOG "CTX: Actor:   MOD\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

#$diff += x_213_1($outputLevel, $language);
#$diff += x_213_2($outputLevel, $language);

$diff += x_213_3($outputLevel, $language, $aeTitle, $protocolCodeFlag);
$diff += x_213_4($outputLevel, $language, $aeTitle, $protocolCodeFlag);
$diff += x_213_5($outputLevel, $language, $aeTitle, $protocolCodeFlag);

$logLevel = $outputLevel;
if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("213/grade_213.txt", "213/mir_mesa_213.xml",
        $logLevel, "213", "MOD", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "\nThis test completed with zero errors; that means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 213/grade_213.txt and 213/mir_mesa_213.xml\n";
}

print "If you are submitting a result file to Kudu, submit 213/mir_mesa_213.xml\n\n";

