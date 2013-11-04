#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
use lib "../../../common/scripts";
require imgmgr;
require mesa_common;

sub goodbye() {
  exit 1;
}

# Examine the MPPS messages forwarded by the Image Manager

sub x_50000_1 {
  print LOG "\nCTX: Image Manager 50000.1 \n";
  print LOG "CTX: MPPS messages for EYECARE-200 forwarded to Order Filler \n";
  $diff += mesa::evaluate_mpps_mpps_mgr(
		$logLevel,
		"$MESA_STORAGE/modality/T50000",
		"$MESA_STORAGE/ordfil/mpps/$titleMPPSMgr",
		"1"
		);
  print LOG "\n";
}

# These are the tests for Storage Commitment

sub x_50000_2 {
  print LOG "\nCTX: Image Manager 50000.2 \n";

  mesa::create_hash_test_messages(1, "$titleSC");
  mesa::read_mesa_sc_messages();
  $diff += mesa::evaluate_storage_commit_nevents($logLevel);
}

die "Usage <log level: 1-4> <AE Title MPPS Mgr> <AE Title Storage Commit SCP>" if (scalar(@ARGV) < 3);

$logLevel     = $ARGV[0];
$titleMPPSMgr = $ARGV[1];
$titleSC      = $ARGV[2];
open LOG, ">50000/grade_50000.txt" or die "Could not open output file: 50000/grade_50000.txt";
my $mesaVersion = mesa_get::getMESAVersion();
my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
print LOG "CTX: $mesaVersion \n";
print LOG "CTX: current date/time $date $timeToMinute\n";

$diff = 0;

x_50000_1;
x_50000_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 50000/grade_50000.txt \n";

exit $diff;
