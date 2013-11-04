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

sub x_103_1 {
  print LOG "CTX: Image Manager 103.1 \n";
  print LOG "CTX: MPPS messages produced for P1/X1 \n";
  $diff += mesa::evaluate_mpps_mpps_mgr($logLevel,
		"$MESA_STORAGE/modality/T103",
		"$MESA_STORAGE/ordfil/mpps/$titleMPPSMgr",
		"1"
		);
  print LOG "\n";
}

sub x_103_2 {
  print LOG "CTX: Image Manager 103.2 \n";
  print LOG "CTX: Storage Commitment evaluation. \n";

  mesa::create_hash_test_messages($logLevel, "$titleSC");
  mesa::read_mesa_sc_messages();
  $diff += mesa::evaluate_storage_commit_nevents($logLevel);
  print LOG "\n";
}

sub x_103_3 {
  print LOG "CTX: Image Manager 103.3 \n";
  print LOG "CTX: C-Find response, Study Level query for DOE\n";
  $diff += mesa::evaluate_cfind_resp(
		$logLevel,
		"0020", "000D", "103/cfind_study_mask.txt",
		"103/cfind_doe/test",
		"103/cfind_doe/mesa"
		);
  print LOG "\n";
}

sub x_103_4 {
  print LOG "CTX: Image Manager 103.4 \n";
  print LOG "CTX: C-Find response, Study Level query for SILVERHEELS after HL7 A08 update\n";
  $diff += mesa::evaluate_cfind_resp(
		$logLevel,
		"0020", "000D", "103/cfind_study_mask.txt",
		"103/cfind_silverheels/test",
		"103/cfind_silverheels/mesa",
		);
  print LOG "\n";
}

### Main starts here

die "Usage: <log level: 1-4> <AE Title of your MPPS Mgr> <AE Title of Storage Commit SCP>" if (scalar(@ARGV) < 3);


$logLevel     = $ARGV[0];
$titleMPPSMgr = $ARGV[1];
$titleSC      = $ARGV[2];

open LOG, ">103/grade_103.txt" or die "Could not open output file 103/grade_103.txt";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    103\n";
print LOG "CTX: Actor:   IM\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

x_103_1;
x_103_2;
x_103_3;
x_103_4;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("103/grade_103.txt", "103/mir_mesa_103.xml",
	$logLevel, "103", "IM", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "Test completed with zero errors means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 103/grade_103.txt and 103/mir_mesa_103.xml\n";
}

print "If you are submitting a result file to Kudu, submit 103/mir_mesa_103.xml\n\n";
