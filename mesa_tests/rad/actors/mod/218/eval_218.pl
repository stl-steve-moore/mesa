#!/usr/local/bin/perl -w

# Evaluate images, storage commitment and MPPS messages
# sent by a modality for test 218.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require mod;
require mesa_common;
require mesa_evaluate;

sub dummy {}

sub goodbye {}

sub x_218_1 {
  print LOG "CTX Modality Test 218.1 \n";

  my $level      = shift(@_);
  my $aet        = shift(@_);

  my $masterFile = "$MESA_STORAGE/modality/T218/mpps.status";
  my @mpps = mod::find_mpps_dir_by_patient_id(0, $aet, "MM218");
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "ERR Found $count MPPS directories for patient ID MM218 and AE Title $aet \n";
    print LOG "ERR Expected to find exactly 1 MPPS directory.\n";
    print LOG "ERR You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  $testFile = "$mpps[0]/mpps.dcm";

  my $rtnValue = mod::eval_mpps_billing_material_option($level, $aet, $masterFile, $testFile);

  print LOG "\n";
  return $rtnValue;
}

### Main starts here

die "Usage: <log level: 1-4> <AE title of MPPS SCU> \n" if (scalar(@ARGV) < 2);

$logLevel = $ARGV[0];
$aeTitle  = $ARGV[1];

open LOG, ">218/grade_218.txt" or die "?!";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    218\n";
print LOG "CTX: Actor:   MOD\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

$diff += x_218_1($logLevel, $aeTitle);

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("218/grade_218.txt", "218/mir_mesa_218.xml",
        $logLevel, "218", "MOD", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "\nThis test completed with zero errors; that means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 218/grade_218.txt and 218/mir_mesa_218.xml\n";
}

print "If you are submitting a result file to Kudu, submit 218/mir_mesa_218.xml\n\n";

