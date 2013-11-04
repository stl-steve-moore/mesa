#!/usr/local/bin/perl -w

# Evaluate images, storage commitment and MPPS messages
# sent by a modality for test 214.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require mod;
require mesa_common;
require mesa_evaluate;

sub dummy {}

sub goodbye {}

sub x_214_1 {
  print LOG "CTX Modality Test 214.1 \n";
  print LOG "CTX  Evaluation of Composite Object \n";
  print LOG "CTX  PPS X4A/X4A_A1 \n";

  my $level   = shift(@_);
  my $verbose = shift(@_);
  my $masterFile = "$MESA_STORAGE/modality/T214_4a/x1.dcm";

  $x = "$MESA_TARGET/bin/dcm_print_element -s 0040 0275 0040 0009 $masterFile";
  print LOG "CTX $x\n" if $verbose;
  my $spsID = `$x`;
  chomp $spsID;
  print LOG "CTX  Patient ID: MM214, SPS ID: $spsID \n";

  my @testImages = mod::find_images_by_patient_sps_id($verbose, "MM214", $spsID);

  $count = scalar(@testImages);
  print LOG "CTX Found $count images for Patient ID MM214, SPS ID $spsID \n" if $verbose;

  if (scalar(@testImages) == 0) {
    print LOG "ERR No images are found for Patient ID MM214, SPS ID $spsID \n";
    print LOG "ERR Failure for Performed Procedure X4A/X4A_A1 \n";
    return 1;
  }

  $testFile = $testImages[0];
  print LOG "CTX $testFile \n" if $verbose;
  undef @testImages;

  $rtnValue = mod::eval_image_scheduled($level, $verbose, $masterFile, $testFile);

  print LOG "\n";
  return $rtnValue;
}

sub x_214_2 {
  print LOG "CTX Modality Test 214.2 \n";
  print LOG "CTX  Evaluation of Composite Object \n";
  print LOG "CTX  PPS X4B/X4B_A1,X4B_A2 \n";

  my $level   = shift(@_);
  my $verbose = shift(@_);
  my $masterFile = "$MESA_STORAGE/modality/T214_4b/x1.dcm";

  $x = "$MESA_TARGET/bin/dcm_print_element -s 0040 0275 0040 0009 $masterFile";
  print LOG "CTX $x\n" if $verbose;
  my $spsID = `$x`;
  chomp $spsID;
  print LOG "CTX  Patient ID: MM214, SPS ID: $spsID \n";

  my @testImages = mod::find_images_by_patient_sps_id($verbose, "MM214", $spsID);

  $count = scalar(@testImages);
  print LOG "CTX Found $count images for Patient ID MM214, SPS ID $spsID \n" if $verbose;

  if (scalar(@testImages) == 0) {
    print LOG "ERR No images are found for Patient ID MM214, SPS ID $spsID \n";
    print LOG "ERR Failure for Performed Procedure X4B/X4B_A1,X4B_A2 \n";
    return 1;
  }

  $testFile = $testImages[0];
  print LOG "CTX $testFile \n" if $verbose;
  undef @testImages;

  $rtnValue = mod::eval_image_scheduled($level, $verbose, $masterFile, $testFile);

  print LOG "\n";
  return $rtnValue;
}


sub x_214_3 {
  print LOG "CTX Modality Test 214.3 \n";
  print LOG "CTX Looking for PPS X4A/X4A_A1 \n";

  my ($level, $language, $aet, $protocolFlag) = @_;
  my $masterFile = "$MESA_STORAGE/modality/T214_4a/mpps.status";

  $spsID = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 0009 $masterFile`;
  chomp $spsID;

  my @mpps = mod::find_mpps_dir_by_patient_id_sps_id($verbose, $aet, "MM214", $spsID);
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "ERR Found $count MPPS directories for patient ID MM214, SPS ID $spsID \n";
    print LOG "ERR Expected to find exactly 1 MPPS directories.\n";
    print LOG "ERR You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  $testFile = "$mpps[0]/mpps.dcm";

  my $rtnValue = mesa::eval_mpps_scheduled($level, $protocolFlag, $aet, $masterFile, $testFile);

  print LOG "\n";
  return $rtnValue;
}

sub x_214_4 {
  print LOG "CTX Modality Test 214.4 \n";
  print LOG "CTX Looking for PPS X4B/X4B_A1,X4B_A2 \n";

  my ($level, $language, $aet, $protocolFlag) = @_;
  my $masterFile = "$MESA_STORAGE/modality/T214_4b/mpps.status";

  $spsID = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 0009 $masterFile`;
  chomp $spsID;

  my @mpps = mod::find_mpps_dir_by_patient_id_sps_id($verbose, $aet, "MM214", $spsID);
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "ERR Found $count MPPS directories for patient ID MM214, SPS ID $spsID \n";
    print LOG "ERR Expected to find exactly 1 MPPS directories.\n";
    print LOG "ERR You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  $testFile = "$mpps[0]/mpps.dcm";

  my $rtnValue = mesa::eval_mpps_scheduled($level, $protocolFlag, $aet, $masterFile, $testFile);

  print LOG "\n";
  return $rtnValue;
}

sub x_214_5 {
  print LOG "CTX Modality Test 214.5 \n";
  print LOG "CTX Modality should create different PPS ID for different MPPS\n";

  my ($level, $language, $aet, $protocolFlag) = @_;
  my $masterFile = "$MESA_STORAGE/modality/T214_4a/mpps.status";

  $spsID = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 0009 $masterFile`;
  chomp $spsID;

  my @mpps = mod::find_mpps_dir_by_patient_id_sps_id($verbose, $aet, "MM214", $spsID);
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "ERR Found $count MPPS directories for patient ID MM214, SPS ID $spsID \n";
    print LOG "ERR Expected to find exactly 1 MPPS directories.\n";
    print LOG "ERR You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  $testFilePPS1 = "$mpps[0]/mpps.dcm";

  $masterFile = "$MESA_STORAGE/modality/T214_4b/mpps.status";

  $spsID = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 0009 $masterFile`;
  chomp $spsID;

  @mpps = mod::find_mpps_dir_by_patient_id_sps_id($verbose, $aet, "MM214", $spsID);
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "ERR Found $count MPPS directories for patient ID MM214, SPS ID $spsID \n";
    print LOG "ERR Expected to find exactly 1 MPPS directories.\n";
    print LOG "ERR You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  $testFilePPS2 = "$mpps[0]/mpps.dcm";


  if ($level >= 3) {
    print LOG "CTX: Test file 1 $testFilePPS1\n";
    print LOG "CTX: Test file 2 $testFilePPS2\n";
  }

  my $rtnStatus = 0;  $ppsID1 = `$MESA_TARGET/bin/dcm_print_element 0040 0253 $testFilePPS1`;
  chomp $ppsID1;
  $ppsID2 = `$MESA_TARGET/bin/dcm_print_element 0040 0253 $testFilePPS2`;
  chomp $ppsID2;

  if ($level >= 3) {
    print LOG "CTX: Performed Procedure Step ID 1: $ppsID1\n";    print LOG "CTX: Performed Procedure Step ID 2: $ppsID2\n";
  }
  if ($ppsID1 eq $ppsID2) {    print LOG "ERR Modality used the same Performed Procedure Step ID for 2 different MPPS: $ppsID1\n";
    $rtnStatus = 1;
  }

  print LOG "\n";
  return $rtnValue;
}

### Main starts here
die "Usage: <log level> <AE title of MPPS SCU> [Protocol Code Flag] [Japanese] \n" if (scalar(@ARGV) < 3);

$outputLevel = $ARGV[0];
$aeTitle = $ARGV[1];
$protocolCodeFlag = $ARGV[2];
$language = "";
$language = $ARGV[3] if (scalar(@ARGV) > 3);

$verbose = 0;

open LOG, ">214/grade_214.txt" or die "?!";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    214\n";
print LOG "CTX: Actor:   MOD\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";
$diff = 0;

$diff += x_214_1($outputLevel, $verbose);
$diff += x_214_2($outputLevel, $verbose);

$diff += x_214_3($outputLevel, $verbose, $aeTitle, $protocolCodeFlag);
$diff += x_214_4($outputLevel, $verbose, $aeTitle, $protocolCodeFlag);
$diff += x_214_5($outputLevel, $verbose, $aeTitle, $protocolCodeFlag);

$logLevel = $outputLevel;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("214/grade_214.txt", "214/mir_mesa_214.xml",
        $logLevel, "214", "MOD", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "\nThis test completed with zero errors; that means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 214/grade_214.txt and 214/mir_mesa_214.xml\n";
}

print "If you are submitting a result file to Kudu, submit 214/mir_mesa_214.xml\n\n";

