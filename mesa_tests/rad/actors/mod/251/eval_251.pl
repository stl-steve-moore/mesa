#!/usr/local/bin/perl -w

# Evaluate images, storage commitment and MPPS messages
# sent by a modality for test 251.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require mod;
require mesa_common;
require mesa_evaluate;

sub dummy {}

sub goodbye {}

sub x_251_1 {
  print LOG "Modality Test 251.1 \n";
  print LOG " Association Negotiation for Storage Commitment \n";

  my $verbose = shift(@_);
  $rtnValue = 0;

  $x = "$MESA_TARGET/bin/sc_scp_association -a MESA_IMG_MGR -c $modalityAE";
  $x .= " -v " if $verbose;
  $x .= " $modalityHost $modalityPort";

  print LOG "$x\n";
  print LOG `$x`;
  $rtnValue = 1 if ($?);

  return $rtnValue;
}


### Main starts here

($modality, $modalityAE, $modalityHost, $modalityPort,
 $modalityStationName) =
  mod::read_config_params("mod_test.cfg");

die "No value for MODALITY specified \n" if ($modality eq "");
die "No value for TEST_MODALITY_STATION specified \n" if ($modalityStationName eq "");


$verbose = grep /^-v/, @ARGV;

open LOG, ">251/grade_251.txt" or die "?!";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    251\n";
print LOG "CTX: Actor:   MOD\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

$diff += x_251_1($verbose);

$logLevel = 4;
if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("251/grade_251.txt", "251/mir_mesa_251.xml",
        $logLevel, "251", "MOD", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "\nThis test completed with zero errors; that means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 251/grade_251.txt and 251/mir_mesa_251.xml\n";
}

print "If you are submitting a result file to Kudu, submit 251/mir_mesa_251.xml\n\n";

