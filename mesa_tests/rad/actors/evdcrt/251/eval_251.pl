#!/usr/local/bin/perl -w

# Evaluate images, storage commitment and MPPS messages
# sent by a modality for test 251.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
#require mod;
require mesa_common;

sub goodbye {}

sub x_251_1 {
  print LOG "Modality Test 251.1 \n";
  print LOG " Association Negotiation for Storage Commitment \n";

  $rtnValue = 0;
  $commitHost = $configHash{"TEST_STORAGE_COMMIT_HOST"};
  $commitPort = $configHash{"TEST_STORAGE_COMMIT_PORT"};
  $commitTitle= $configHash{"TEST_STORAGE_COMMIT_AE"};
  if (! $commitHost )  {
   print LOG "ERR: No value in configuration file for TEST_STORAGE_COMMIT_HOST\n";
   return 1;
  }

  $x = "$MESA_TARGET/bin/sc_scp_association -a MESA_IMG_MGR -c $commitTitle";
  $x .= " -v " if ($logLevel >= 2);
  $x .= " $commitHost $commitPort";

  print LOG "$x\n";
  print LOG `$x`;
  $rtnValue = 1 if ($?);

  return $rtnValue;
}


### Main starts here
if (scalar(@ARGV) < 1) {
  print "Usage: <log level> \n";
  exit 1;
}
$logLevel = $ARGV[0];

#($modality, $modalityAE, $modalityHost, $modalityPort,
# $modalityStationName) =
#  mod::read_config_params("mod_test.cfg");
 %configHash = mesa_get::get_config_params("evdcrt_test.cfg");


open LOG, ">251/grade_251.txt" or die "?!";
my $mesaVersion = mesa_get::getMESAVersion();
my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);

print LOG "CTX: Evidence Creator test 251\n";
print LOG "CTX: $mesaVersion \n";
print LOG "CTX: current date/time $date $timeToMinute\n";
print LOG "CTX: Log level: $logLevel\n";

$diff = 0;

$diff += x_251_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 251/grade_251.txt \n";

exit $diff;
