#!/usr/local/bin/perl -w

# Evaluate images, storage commitment and MPPS messages
# sent by a modality for test 201.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require mod;
require mesa_common;
require mesa_evaluate;

sub dummy {}

sub goodbye {}

sub x_201_1 {
  print LOG "CTX Modality Test 201.1 \n";

  my ($level, $language, $fileName) = @_;

  $x = "$MESA_TARGET/bin/dcm_print_element 0020 000D $fileName";
  print LOG "CTX $x\n" if ($level >= 3);

  my $study_UID = `$x`;
  chop $study_UID;
  print LOG "CTX Study UID = $study_UID \n" if ($level >= 3);

  if ($language eq "Japanese") {
    $rtnValue = mesa::eval_image_unscheduled_Japanese($level, "201/x1.dcm", $fileName);
  } else {
    $rtnValue = mod::eval_image_unscheduled($level, 0, "201/x1.dcm", $fileName);
  }


  print LOG "\n";
  return $rtnValue;
}

sub x_201_2 {
  print LOG "CTX Modality Test 201.2 \n";

  my ($level, $language, $fileName) = @_;

  $rtnValue = mesa::eval_dicom_image_extended($level, "201/x1.dcm", $fileName);

  print LOG "\n";
  return $rtnValue;
}

sub eval_storage_commitment {
  my $aet = shift(@_);
  print " scripts/eval_storage_commit.csh MODALITY1 \n";
  print ` scripts/eval_storage_commit.csh MODALITY1`;
  if ($?) {
    print "ERR Problems noted in storage commitment.\n";
    print "ERR Look in grade_storage_commit.log.\n";
  }
}

sub x_201_3 {
  print LOG "CTX Modality Test 201.3 \n";

  my $level      = shift(@_);
  my $verbose    = shift(@_);
  my $aet        = shift(@_);

  my @mpps = mod::find_mpps_dir_by_patient_id($verbose, $aet, "583020");
  my $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "ERR Found $count MPPS directories for patient ID 583020 and AE Title $aet \n";
    print LOG "ERR Expected to find exactly 1 MPPS directory.\n";
    print LOG "ERR You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  my $testFile = "$mpps[0]/mpps.dcm";

  if ($testFile eq "") {
    print LOG "ERR Could not find matching MPPS files for patient ID 583020 \n";
    return 1;
  }

  $rtnValue = mod::eval_mpps_unscheduled($level, $verbose, $aet,
	"201/mpps.status", $testFile);

  print LOG "\n";
  return $rtnValue;
}

### Main starts here

if (scalar(@ARGV) < 2) {
  print "Usage: <log level> <AE title of MPPS SCU> [Japanese] \n";
  exit 1;
}

$outputLevel = $ARGV[0];
$aeTitle = $ARGV[1];
$language = "";
# $verbose = 0;
$language = $ARGV[2] if (scalar(@ARGV) > 2);

open LOG, ">201/grade_201.txt" or die "?!";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    201\n";
print LOG "CTX: Actor:   MOD\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

@studyUID = mod::lookup_study_uid_by_patient_id($verbose, "583020");
if (scalar(@studyUID) == 0) {
  print "Found no matching Study Instance UID for patient ID 583020 \n";
  print LOG "Found no matching Study Instance UID for patient ID 583020 \n";
  exit 1;
}

if (scalar(@studyUID) != 1) {
  $count = scalar(@studyUID);
  print "Found $count studies for patient ID 583020.\n" .
	"You need to clear the MESA image manager and run the tests again.\n";
  print LOG "ERR Found $count studies for patient ID 583020.\n" .
	"ERR You need to clear the MESA image manager and run the tests again.\n";
  exit 1;
}

@seriesUID = mod::lookup_series_uid_by_study_uid($verbose, $studyUID[0]);
if (scalar(@seriesUID) == 0) {
  print "Found no matching Series Instance UID for patient ID 583020 \n";
  print LOG "ERR Found no matching Series Instance UID for patient ID 583020 \n";
  exit 1;
}

@fileNames = mod::lookup_filnam_uid_by_series_uid($verbose, $seriesUID[0]);
if (scalar(@fileNames) == 0) {
  print "Found no matching SOP Instances for patient ID 583020 \n";
  print LOG "ERR Found no matching SOP Instances for patient ID 583020 \n";
  exit 1;
}

my $firstImage = 1;
foreach $f (@fileNames) {
  $diff += x_201_1($outputLevel, $language, $f);
  if ($firstImage == 1) {
    $diff += x_201_2($outputLevel, $language, $f);
    $firstImage = 0;
  }
}

$diff += x_201_3($outputLevel, $verbose, $aeTitle);

$logLevel = $outputLevel;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("201/grade_201.txt", "201/mir_mesa_201.xml",
        $logLevel, "201", "MOD", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "\nThis test completed with zero errors; that means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 201/grade_201.txt and 201/mir_mesa_201.xml\n";
}

print "If you are submitting a result file to Kudu, submit 201/mir_mesa_201.xml\n\n";

