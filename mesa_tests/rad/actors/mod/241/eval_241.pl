#!/usr/local/bin/perl -w

# Evaluate images, storage commitment and MPPS messages
# sent by a modality for test 241.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require mod;
require mesa_common;
require mesa_evaluate;

sub dummy {}

sub goodbye {}

sub x_241_2 {
  print LOG "Modality Test 241.2 \n";
  print LOG " MPPS: Abandoned case \n";

  my ($level, $language, $aet, $protocolCodeFlag) = @_;
  my $v = 0;
  $v = 1 if ($level > 2);

  my $masterFile = "$MESA_STORAGE/modality/T241/mpps.status";

  my @mpps = mod::find_mpps_dir_by_patient_id($v, $aet, "MM241");
  $count = scalar(@mpps);
  if ($count != 1) {
    print LOG "Found $count MPPS directories for patient ID MM241 and AE Title $aet \n";
    print LOG "Expected to find exactly 1 MPPS directory.\n";
    print LOG "You should clear the MESA Image Manager and resend images/MPPS events.\n";
    return 1;
  }

  $testFile = "$mpps[0]/mpps.dcm";

  my $rtnValue = 0;
  if ($language eq "Japanese") {
    $rtnValue = mesa::evaluate_mpps_modality_Japanese($level, $aet, $masterFile, $testFile);
  } else {
    $rtnValue =  mesa::eval_mpps_scheduled($level, $protocolCodeFlag, $aet, $masterFile, $testFile);
  }


  print LOG "\n";
  return $rtnValue;
}

### Main starts here
die "Usage: <log level> <AE title of MPPS SCU> <protocol code flag> [Japanese] \n" if (scalar(@ARGV) < 3);

$outputLevel = $ARGV[0];
$aeTitle = $ARGV[1];
$protocolCodeFlag = $ARGV[2];
$language = "";
$language = $ARGV[3] if (scalar(@ARGV) > 3);

open LOG, ">241/grade_241.txt" or die "?!";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    241\n";
print LOG "CTX: Actor:   MOD\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

$diff += x_241_2($outputLevel, $language, $aeTitle, $protocolCodeFlag);

$logLevel = $outputLevel;
if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("241/grade_241.txt", "241/mir_mesa_241.xml",
        $logLevel, "241", "MOD", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "\nThis test completed with zero errors; that means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 241/grade_241.txt and 241/mir_mesa_241.xml\n";
}

print "If you are submitting a result file to Kudu, submit 241/mir_mesa_241.xml\n\n";

