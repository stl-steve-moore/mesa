#!/usr/local/bin/perl -w

# Evaluate images, storage commitment and MPPS messages
# sent by a modality for test 222.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require mod;
require mesa_common;
require mesa_evaluate;

sub dummy {}

sub goodbye {}

sub x_222_1 {
  print LOG "Modality Test 222.1 \n";
  print LOG " Evaluation of Composite Object \n";
  print LOG " PPS X6/X6_A1, X7/X7_A1 \n";

  my ($level, $language)= @_;

  my $masterFile = "$MESA_STORAGE/modality/T222/x1.dcm";

  print LOG " Patient ID: MM222\n";

  my $v = 0;
  $v = 1 if ($level > 2);
  my @testImages = mod::find_images_by_patient($v, "MM222");

  $count = scalar(@testImages);
  print LOG "Found $count images for Patient ID MM222\n" if $verbose;

  if (scalar(@testImages) == 0) {
    print LOG "No images are found for Patient ID MM222\n";
    print LOG "Failure for Performed Procedure X6/X6_A1, X7/X7_A1 \n";
    return 1;
  }

  $testFile = $testImages[0];
  print LOG "$testFile \n" if $verbose;

  if ($language eq "Japanese") {
    $rtnValue = mesa::eval_image_scheduled_group_case_Japanese(
		$level, $masterFile, $testFile);
  } else {
    $rtnValue = mod::eval_image_scheduled_group_case($level, $verbose, $masterFile, $testFile);
  }


  print LOG "\n";
  return $rtnValue;
}

sub x_222_2 {
  print LOG "Modality Test 222.2 \n";
  print LOG " MPPS Group Case, two requested procedures, two SPS \n";

  my ($level, $language, $masterFile, $aet) = @_;
  my $v = 0;
  $v = 1 if ($level > 2);

  my @mpps = mod::find_mpps_dir_by_patient_id($v, $aet, "MM222");
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "Found $count MPPS directories for patient ID MM222 and AE Title $aet \n";
    print LOG "Expected to find exactly 1 MPPS directory.\n";
    print LOG "You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  $testFile = "$mpps[0]/mpps.dcm";

  my $rtnValue = 0;
  if ($language eq "Japanese") {
    $rtnValue = mesa::evaluate_mpps_modality_group_Japanese(
		$level, $aet, $masterFile, $testFile);
  } else {
    $rtnValue = mod::eval_mpps_group($v, $aet, $masterFile, $testFile);
  }

  print LOG "\n";
  return $rtnValue;
}

### Main starts here
die "Usage: <log level> <AE title of MPPS SCU> [Japanese] \n" if (scalar(@ARGV) < 2);

$outputLevel = $ARGV[0];
$aeTitle = $ARGV[1];
$language = "";
$language = $ARGV[2] if (scalar(@ARGV) > 2);

open LOG, ">222/grade_222.txt" or die "?!";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    222\n";
print LOG "CTX: Actor:   MOD\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

$diff += x_222_1($outputLevel, $language);

$diff += x_222_2($outputLevel, $language,
	, "$MESA_STORAGE/modality/T222/mpps.status", $aeTitle);

$logLevel = $outputLevel;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("222/grade_222.txt", "222/mir_mesa_222.xml",
        $logLevel, "222", "MOD", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "\nThis test completed with zero errors; that means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 222/grade_222.txt and 222/mir_mesa_222.xml\n";
}

print "If you are submitting a result file to Kudu, submit 222/mir_mesa_222.xml\n\n";

