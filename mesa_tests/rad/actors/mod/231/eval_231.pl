#!/usr/local/bin/perl -w

# Evaluate images, storage commitment and MPPS messages
# sent by a modality for test 231.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require mod;
require mesa_common;
require mesa_evaluate;

sub dummy {}

sub goodbye {}

sub x_231_3 {
  print LOG "Modality Test 231.3 \n";
  print LOG "Looking for PPS X5/X5_A1 \n";

  my ($level, $language, $aet, $protocolCodeFlag) = @_;

  my $v = 0;
  $v = 1 if ($level > 2);
  my $masterFile = "$MESA_STORAGE/modality/T231_orig/mpps.status";

  $aiCode = `$MESA_TARGET/bin/dcm_print_element -s 0040 0260 0008 0100 $masterFile`;
  chomp $aiCode;

  my @mpps = mod::find_mpps_dir_by_patient_id(0, $aet, "MM231");
  $count = scalar(@mpps);
  if ($count != 2) {
    print LOG "Found $count MPPS directories for patient ID MM231, AI Code $aiCode \n";
    print LOG "Expected to find exactly 2 MPPS directories.\n";
    print LOG "You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  $testFile1 = "$mpps[0]/mpps.dcm";

  my $rtnValue = 0;
  if ($language eq "Japanese") {
    $rtnValue = mesa::eval_image_scheduled_Japanese($level, $masterFile, $testFile1);
  } else {
    $rtnValue = mod::eval_image_scheduled($level, $v, $masterFile, $testFile1);
  }

  print LOG "\n";
  return $rtnValue;
}

sub x_231_4 {
  print LOG "Modality Test 231.4 \n";
  print LOG "Looking for PPS X5/X5_A1 \n";

  my ($level, $language, $aet, $protocolCodeFlag) = @_;
  my $v = 0;
  $v = 1 if ($level > 2);
  my $masterFile = "$MESA_STORAGE/modality/T231_orig/mpps.status";

  $aiCode = `$MESA_TARGET/bin/dcm_print_element -s 0040 0260 0008 0100 $masterFile`;
  chomp $aiCode;

  my @mpps = mod::find_mpps_dir_by_patient_id(0, $aet, "MM231");
  $count = scalar(@mpps);
  if ($count != 2) {
    print LOG "ERR: Found $count MPPS directories for patient ID MM231, AI Code $aiCode\n";
    print LOG "ERR: Expected to find exactly 2 MPPS directories.\n";
    print LOG "ERR: You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  if ($level >= 3) {
    print LOG "CTX: Found 2 MPPS objects for patient MM231; that is expected\n";
  }

  $testFile1 = "$mpps[0]/mpps.dcm";

  my $rtnValue1 = 0;
  if ($language eq "Japanese") {
    $rtnValue1 = mesa::evaluate_mpps_modality_Japanese($level, $masterFile, $testFile1);
  } else {
    $rtnValue1 = mesa::eval_mpps_scheduled($level, $protocolCodeFlag, $aet, $masterFile, $testFile1);
  }

  $testFile2 = "$mpps[1]/mpps.dcm";
  my $rtnValue2 = 0;
  if ($language eq "Japanese") {
    $rtnValue2 = mesa::evaluate_mpps_modality_Japanese($level, $masterFile, $testFile2);
  } else {
    $rtnValue2 = mesa::eval_mpps_scheduled($level, $protocolCodeFlag, $aet, $masterFile, $testFile2);
  }

  print LOG "\n";
  $rtnValue = 0;
  $rtnValue = 1 if ($rtnValue1 != 0 || $rtnValue2 != 0);
  return $rtnValue;
}

sub x_231_5 {
  print LOG "CTX: Modality Test 231.5 \n";
  print LOG "CTX: Modality should create different PPS ID for different MPPS\n";

  my ($level, $language, $aet, $protocolCodeFlag) = @_;
  my $v = 0;
  $v = 1 if ($level > 2);
  my $masterFile = "$MESA_STORAGE/modality/T231_orig/mpps.status";

  $aiCode = `$MESA_TARGET/bin/dcm_print_element -s 0040 0260 0008 0100 $masterFile`;
  chomp $aiCode;

  my @mpps = mod::find_mpps_dir_by_patient_id(0, $aet, "MM231");
  $count = scalar(@mpps);
  if ($count != 2) {
    print LOG "ERR: Found $count MPPS directories for patient ID MM231, AI Code $aiCode\n";
    print LOG "ERR: Expected to find exactly 2 MPPS directories.\n";
    print LOG "ERR: You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  if ($level >= 3) {
    print LOG "CTX: Found 2 MPPS objects for patient MM231; that is expected\n";
  }

  $testFilePPS1 = "$mpps[0]/mpps.dcm";
  $testFilePPS2 = "$mpps[1]/mpps.dcm";
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
  print LOG "\n";
  return $rtnStatus;
}
### Main starts here

die "Usage: <log level> <AE title of MPPS SCU> [Protocol Code Flag] [Japanese] \n" if (scalar(@ARGV) < 3);

$outputLevel = $ARGV[0];
$aeTitle = $ARGV[1];
$protocolCodeFlag = $ARGV[2];
$language = "";
$language = $ARGV[3] if (scalar(@ARGV) > 3);

open LOG, ">231/grade_231.txt" or die "?!";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    231\n";
print LOG "CTX: Actor:   MOD\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";
$diff = 0;

#$diff += x_231_1($verbose);
#$diff += x_231_2($verbose);

#$diff += x_231_3($outputLevel, $language, $aeTitle, $protocolCodeFlag);
$diff += x_231_4($outputLevel, $language, $aeTitle, $protocolCodeFlag);
$diff += x_231_5($outputLevel, $language, $aeTitle, $protocolCodeFlag);

$logLevel = $outputLevel;
if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("231/grade_231.txt", "231/mir_mesa_231.xml",
        $logLevel, "231", "MOD", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "\nThis test completed with zero errors; that means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 231/grade_231.txt and 231/mir_mesa_231.xml\n";
}

print "If you are submitting a result file to Kudu, submit 231/mir_mesa_231.xml\n\n";

