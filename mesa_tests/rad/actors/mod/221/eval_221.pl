#!/usr/local/bin/perl -w

# Evaluate images, storage commitment and MPPS messages
# sent by a modality for test 221.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require mod;
require mesa_common;
require mesa_evaluate;

sub dummy {}

sub goodbye {}

sub x_221_1 {
  my ($level, $language, $index) = @_;

  print LOG "Modality Test 221.1 \n";
  print LOG " Evaluation of Composite Object \n";
  print LOG " PPS X3A/X3A_A1, X3B/X3B_A1 \n";

  my $masterFile = "$MESA_STORAGE/modality/T221/x1.dcm";

  $x = "$MESA_TARGET/bin/dcm_print_element -i $index -s 0040 0275 0040 0009 $masterFile";
  print LOG "$x\n" if $level > 2;
  my $spsID = `$x`;
  chomp $spsID;
  print LOG " Patient ID: MM221, SPS ID: $spsID \n";

  my @testImages = mod::find_images_by_patient_sps_id(0, "MM221", $spsID);

  $count = scalar(@testImages);
  print LOG "Found $count images for Patient ID MM221, SPS ID $spsID \n" if $verbose;

  if (scalar(@testImages) == 0) {
    print LOG "No images are found for Patient ID MM221, SPS ID $spsID \n";
    print LOG "Failure for Performed Procedure X3A/X3A_A1, X3B/X3B_A1 \n";
    return 1;
  }

  $testFile = $testImages[0];
  print LOG "$testFile \n" if $verbose;

  my $rtnValue = 0;
  my $v = 0;
  $v = 1 if ($outputLevel > 2);
  print LOG "Lang: $language\n";
  if ($language eq "Japanese") {
    $rtnValue = mesa::eval_image_scheduled_group_case_Japanese($outputLevel, $masterFile, $testFile);
  } else {
    $rtnValue = mod::eval_image_scheduled_group_case($outputLevel, $v, $masterFile, $testFile);
  }

  print LOG "\n";
  return $rtnValue;
}

sub x_221_2 {
  print LOG "Modality Test 221.2 \n";
  print LOG " MPPS Group Case, one requested procedure, two SPS \n";

  my ($level, $language, $masterFile, $aet) = @_;

  my $v = 0;
  $v = 1 if ($level> 2);

  my @mpps = mod::find_mpps_dir_by_patient_id($v, $aet, "MM221");
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "Found $count MPPS directories for patient ID MM221 and AE Title $aet \n";
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

open LOG, ">221/grade_221.txt" or die "?!";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    221\n";
print LOG "CTX: Actor:   MOD\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

#$diff += x_221_1($outputLevel, $language, "1");
#if ($diff == 1) {
#  print LOG "Failed 221_1 test with index 1, trying with index 2\n";
#  $diff += x_221_1($outputLevel, $language, "2");
#
#  if ($diff == 1) {
#    print LOG "OK, your sequences are in a different order than \n";
#    print LOG " the MESA sequences. This is OK\n";
#    $diff -= 1;
#  }
#}

$diff += x_221_2($outputLevel, $language,
	"$MESA_STORAGE/modality/T221/mpps.status", $aeTitle);

$logLevel = $outputLevel;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("221/grade_221.txt", "221/mir_mesa_221.xml",
        $logLevel, "221", "MOD", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "\nThis test completed with zero errors; that means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 221/grade_221.txt and 221/mir_mesa_221.xml\n";
}

print "If you are submitting a result file to Kudu, submit 221/mir_mesa_221.xml\n\n";

