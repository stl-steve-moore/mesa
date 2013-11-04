#!/usr/local/bin/perl -w

# Evaluate images, storage commitment and MPPS messages
# sent by a modality for test 215.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require mod;
require mesa_common;
require mesa_evaluate;

sub dummy {}

sub goodbye {}

sub x_215_1 {
  print LOG "Modality Test 215.1 \n";
  print LOG " Evaluation of Composite Object \n";
  print LOG " Scheduled X10, performed X2 \n";

  my $level   = shift(@_);
  my $verbose = shift(@_);
  my $masterFile = "$MESA_STORAGE/modality/T215/x1.dcm";

  $x = "$MESA_TARGET/bin/dcm_print_element -s 0040 0275 0040 0009 $masterFile";
  print LOG "$x\n" if $verbose;
  my $spsID = `$x`;
  chomp $spsID;
  print LOG " Patient ID: MM215, SPS ID: $spsID \n";

  my @testImages = mod::find_images_by_patient_sps_id($verbose, "MM215", $spsID);

  $count = scalar(@testImages);
  print LOG "Found $count images for Patient ID MM215, SPS ID $spsID \n" if $verbose;

  if (scalar(@testImages) == 0) {
    print LOG "No images are found for Patient ID MM215, SPS ID $spsID \n";
    print LOG "Failure for Performed Procedure X2/X2_A1 \n";
    return 1;
  }

  $testFile = $testImages[0];
  print LOG "$testFile \n" if $verbose;
  undef @testImages;

  $rtnValue = mod::eval_image_scheduled($level, $verbose, $masterFile, $testFile);

  print LOG "\n";
  return $rtnValue;
}

sub x_215_2 {
  print LOG "Modality Test 215.2 \n";
  print LOG "Looking for PPS X2/X2_A1 \n";

  my $level      = shift(@_);
  my $verbose    = shift(@_);
  my $aet        = shift(@_);
  my $masterFile = "$MESA_STORAGE/modality/T215/mpps.status";

  $spsID = `$MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 0009 $masterFile`;
  chomp $spsID;

  my @mpps = mod::find_mpps_dir_by_patient_id_sps_id($verbose, $aet, "MM215", $spsID);
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "Found $count MPPS directories for patient ID MM215, SPS ID $spsID \n";
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

if (scalar(@ARGV) < 1) {
  print "Usage: <log level> <AE title of MPPS SCU> \n";
  exit 1;
}

$verbose = 0;
$outputLevel = $ARGV[0];
$verbose = 1 if ($outputLevel >= 3);
$aeTitle = $ARGV[1];


open LOG, ">215/grade_215.txt" or die "?!";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    215\n";
print LOG "CTX: Actor:   MOD\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";
$diff = 0;

$diff += x_215_1($outputLevel, $verbose);

$diff += x_215_2($outputLevel, $verbose, $aeTitle);

$logLevel = $outputLevel;
if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("215/grade_215.txt", "215/mir_mesa_215.xml",
        $logLevel, "215", "MOD", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "\nThis test completed with zero errors; that means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 215/grade_215.txt and 215/mir_mesa_215.xml\n";
}

print "If you are submitting a result file to Kudu, submit 215/mir_mesa_215.xml\n\n";

