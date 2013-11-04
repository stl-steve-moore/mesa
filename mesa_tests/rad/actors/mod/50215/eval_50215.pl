#!/usr/local/bin/perl -w

# Evaluate images, storage commitment and MPPS messages
# sent by a modality for test 50215.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require mod;
require mesa_common;
require mesa_evaluate;

sub goodbye {}

sub x_50215_1 {
  print LOG "Modality Test 50215.1 \n";
  print LOG " Evaluation of Composite Object \n";
  print LOG " Scheduled EYE_PC_200, performed EYE_PC_201 \n";

  my $level   = shift(@_);
  my $verbose = shift(@_);
  my $masterFile = "$MESA_STORAGE/modality/T50215/x1.dcm";

  $x = "$MESA_TARGET/bin/dcm_print_element -s 0040 0275 0040 0009 $masterFile";
  print LOG "$x\n" if $verbose;
  my $spsID = `$x`;
  chomp $spsID;
  print LOG " Patient ID: 50215, SPS ID: $spsID \n";

  my @testImages = mod::find_images_by_patient_sps_id($verbose, "50215", $spsID);

  $count = scalar(@testImages);
  print LOG "Found $count images for Patient ID 50215, SPS ID $spsID \n" if $verbose;

  if (scalar(@testImages) == 0) {
    print LOG "No images are found for Patient ID 50215, SPS ID $spsID \n";
    print LOG "Failure for Performed Procedure EYE_PC_201 \n";
    return 1;
  }

  $testFile = $testImages[0];
  print LOG "$testFile \n" if $verbose;
  undef @testImages;

  $rtnValue = mod::eval_image_scheduled($level, $verbose, $masterFile, $testFile);

  print LOG "\n";
  return $rtnValue;
}

sub x_50215_2 {
  print LOG "Modality Test 50215.2 \n";
  print LOG "Looking for PPS EYE_PC_201 \n";

  my $level      = shift(@_);
  my $verbose    = shift(@_);
  my $aet        = shift(@_);
  my $masterFile = "$MESA_STORAGE/modality/T50215/mpps.status";

  $spsID = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 0009 $masterFile`;
  chomp $spsID;

  my @mpps = mod::find_mpps_dir_by_patient_id_sps_id($verbose, $aet, "50215", $spsID);
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "Found $count MPPS directories for patient ID 50215, SPS ID $spsID \n";
    print LOG "Expected to find exactly 1 MPPS directories.\n";
    print LOG "You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  $testFile = "$mpps[0]/mpps.dcm";

  my $rtnValue = mod::eval_mpps_scheduled($level, $verbose, $aet, $masterFile, $testFile);

  print LOG "\n";
  return $rtnValue;
}

### Main starts here

if (scalar(@ARGV) < 2) {
  print "Usage: <log level> <AE title of MPPS SCU> \n";
  exit 1;
}

$verbose = 0;
$logLevel = $ARGV[0];
$verbose = 1 if ($logLevel >= 3);
$aeTitle = $ARGV[1];

open LOG, ">50215/grade_50215.txt" or die "?!";
 my $mesaVersion = mesa_get::getMESAVersion();
 my $numericVersion = mesa_get::getMESANumericVersion();
 my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
print LOG "CTX: Test:    50215\n";
print LOG "CTX: Actor:   MOD\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;
$diff += x_50215_1($logLevel, $verbose);
$diff += x_50215_2($logLevel, $verbose, $aeTitle);
close LOG;

open LOG, ">50215/mir_mesa_50215.xml" or die "Could not open XML output file: 50215/mir_mesa_50215.xml";

mesa_evaluate::eval_XML_start($logLevel, "50215", "MOD", $numericVersion, $date);

if ($logLevel != 4) {
  $diff += 1;
  mesa_evaluate::outputComment($logLevel,
        "Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.");
}
mesa_evaluate::outputCount($logLevel, $diff);
mesa_evaluate::outputPassFail($logLevel, $diff);

if ($diff == 0) {
  print "\nCTX: 0 errors implies this test has been passed.\n";
} else {
  print "\nERR: $diff errors implies test FAILURE.\n";
}
mesa_evaluate::startDetails($logLevel);

open TMP, "<50215/grade_50215.txt" or die "Could not open 50215/grade_50215.txt
for input";
while ($l = <TMP>) {
 print LOG $l;
}
close TMP;

mesa_evaluate::endDetails($logLevel);
mesa_evaluate::endXML($logLevel);
close LOG;

print "\nLogs stored in 50215/grade_50215.txt \n";
print "Submit 50215/mir_mesa_50215.xml for grading\n";

exit $diff;

