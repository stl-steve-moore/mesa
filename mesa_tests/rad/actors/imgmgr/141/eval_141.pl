#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require imgmgr;

sub goodbye() {
  exit 1;
}

# Examine the MPPS messages forwarded by the Image Manager

sub x_141_1 {
  print LOG "CTX: Image Manager 141.1 \n";
  print LOG "CTX: MPPS messages for P1/X1/X1 forwarded to Order Filler \n";
  $diff += mesa::evaluate_mpps_mpps_mgr_Japanese(
		$logLevel,
		"$MESA_STORAGE/modality/T141",
		"$MESA_STORAGE/ordfil/mpps/$titleMPPSMgr",
		"1"
		);
  print LOG "\n";
}

# These are the tests for Storage Commitment

sub x_141_2 {
  print LOG "CTX: Image Manager 141.2 \n";
  print LOG "CTX: Examining storage commitment N-Event reports\n";

  mesa::create_hash_test_messages(1, "$titleSC");
  mesa::read_mesa_sc_messages();
  $diff += mesa::evaluate_storage_commit_nevents($logLevel);
  print LOG "\n";
}


sub x_141_3 {
  print LOG "CTX: Image Manager 141.3 \n";
  print LOG "CTX: C-Find response \n";

  $diff += mesa::evaluate_cfind_resp_Japanese($logLevel,
                "0020", "000D", "141/cfind_study_mask.txt",
                "141/cfind_q1/test",
                "141/cfind_q1/mesa"
                );
  print LOG "\n";
}



## Main starts here

die "Usage <log level: 1-4> <AE Title MPPS Mgr> <AE Title Storage Commit SCP>" if (scalar(@ARGV) < 3);

$logLevel     = $ARGV[0];
$titleMPPSMgr = $ARGV[1];
$titleSC      = $ARGV[2];
open LOG, ">141/grade_141.txt" or die "Could not open output file: 141/grade_141.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";

$diff = 0;

x_141_1;	# MPPS messages that are forwarded
x_141_2;	# Storage Commitment
x_141_3;	# CFind Response

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 141/grade_141.txt \n";

exit $diff;
