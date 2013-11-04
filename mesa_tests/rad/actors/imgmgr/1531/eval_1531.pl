#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require imgmgr;

sub goodbye() {
  exit 1;
}

# Examine the MPPS messages forwarded by the Image Manager

sub x_1531_1 {
  print LOG "CTX: Image Manager 1531.1 \n";
  print LOG "CTX: MPPS messages for P1/X1/X1 forwarded to Order Filler \n";
  $diff += mesa::evaluate_mpps_mpps_mgr(
		$logLevel,
		"$MESA_STORAGE/modality/T131",
		"$MESA_STORAGE/ordfil/mpps/$titleMPPSMgr",
		"1"
		);
  print LOG "\n";
}

# These are the tests for Storage Commitment

sub x_1531_2 {
  print LOG "CTX: Image Manager 1531.2 \n";

  mesa::create_hash_test_messages(1, "$titleSC");
  mesa::read_mesa_sc_messages();
  $diff += mesa::evaluate_storage_commit_nevents($logLevel);
}

die "Usage <log level: 1-4> <AE Title MPPS Mgr> <AE Title Storage Commit SCP>" if (scalar(@ARGV) < 3);

$logLevel     = $ARGV[0];
$titleMPPSMgr = $ARGV[1];
$titleSC      = $ARGV[2];
open LOG, ">1531/grade_1531.txt" or die "Could not open output file: 1531/grade_1531.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";

$diff = 0;

x_1531_1;
x_1531_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1531/grade_1531.txt \n";

exit $diff;
