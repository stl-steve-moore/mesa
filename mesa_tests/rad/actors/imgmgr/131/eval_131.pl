#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require imgmgr;

use lib "../../../common/scripts";
require mesa_common;
require mesa_evaluate;

sub goodbye() {
  exit 1;
}

sub dummy {}

# Examine the MPPS messages forwarded by the Image Manager

sub x_131_1 {
  print LOG "CTX: Image Manager 131.1 \n";
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

sub x_131_2 {
  print LOG "CTX: Image Manager 131.2 \n";

  mesa::create_hash_test_messages(1, "$titleSC");
  mesa::read_mesa_sc_messages();
  $diff += mesa::evaluate_storage_commit_nevents($logLevel);
}

die "Usage <log level: 1-4> <AE Title MPPS Mgr> <AE Title Storage Commit SCP>" if (scalar(@ARGV) < 3);

$logLevel     = $ARGV[0];
$titleMPPSMgr = $ARGV[1];
$titleSC      = $ARGV[2];
open LOG, ">131/grade_131.txt" or die "Could not open output file: 131/grade_131.txt";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    131\n";
print LOG "CTX: Actor:   IM\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

x_131_1;
x_131_2;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("131/grade_131.txt", "131/mir_mesa_131.xml",
        $logLevel, "131", "IM", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "Test completed with zero errors means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 131/grade_131.txt and 131/mir_mesa_131.xml\n";
}

print "If you are submitting a result file to Kudu, submit 131/mir_mesa_131.xml\n\n";

