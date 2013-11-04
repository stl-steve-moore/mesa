#!/usr/local/bin/perl -w

use Env;

use lib "../../../rad/actors/common/scripts";
require evaluate;
require mesa;

sub goodbye() {
  exit 1;
}

# Examine the MPPS messages forwarded by the Image Manager

sub x_20106_1 {
  print LOG "CTX: Image Manager 20106.1 \n";
  print LOG "CTX: Evaluating MPPS messages produced and forwarded for CATH.O01/YY-20011 \n";
  $diff += mesa::evaluate_mpps_mpps_mgr(
		$logLevel,
		"$MESA_STORAGE/modality/T20106",
		"$MESA_STORAGE/ordfil/mpps/$titleMPPSMgr",
		"1"
		);
  print LOG "\n";
}


#die "Usage <log level: 1-4> <AE Title MPPS Mgr> <AE Title Storage Commit SCP>" if (scalar(@ARGV) < 2);
die "Usage <log level: 1-4> <AE Title MPPS Mgr>" if (scalar(@ARGV) < 2);

$logLevel     = $ARGV[0];
$titleMPPSMgr = $ARGV[1];
#$titleSC      = $ARGV[2];
open LOG, ">20106/grade_20106.txt" or die "Could not open output grade file: 20106/grade_20106.txt";

$diff = 0;
#$testNum = 1;
#$actor = "Image Manager";
#$testSenario = "20106";

x_20106_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 20106/grade_20106.txt \n";

exit $diff;
