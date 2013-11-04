#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require ordfil;

sub goodbye() {
  exit 1;
}

# Compare input HL7 messages with expected values.

sub x_1305_1 {
 print LOG "CTX: Order Filler 1305.1 \n";
 print LOG "CTX: Evaluating HL7 DFT message to Charge Processor for Technical Component \n";

 $diff += mesa::evaluate_hl7 (
		$logLevel,
		$verbose,
		"../../msgs/chg/1305", "1305.126.p03.hl7",
		"$MESA_STORAGE/chgp/hl7", "1001.hl7",
		"ini_files/dft_p03_format.ini", "ini_files/dft_p03_compare.ini");
 print LOG "\n";
}

sub x_1305_2 {
 print LOG "CTX: Order Filler 1305.2 \n";
 print LOG "CTX:  Evaluating HL7 DFT message to Charge Processor for Professional Component \n";

 $diff += mesa::evaluate_hl7 (
		$logLevel,
		$verbose,
		"../../msgs/chg/1305", "1305.128.p03.hl7",
		"$MESA_STORAGE/chgp/hl7", "1002.hl7",
		"ini_files/dft_p03_format.ini", "ini_files/dft_p03_compare.ini");
 print LOG "\n";
}


### Main starts here
die "Usage: <log level: 1-4> <AE Title of your MPPS Mgr>" if (scalar(@ARGV) < 2);

$logLevel = $ARGV[0];
#$titleMPPSMgr = $ARGV[1];
$verbose = 0;

open LOG, ">1305/grade_1305.txt" or die "Could not open output file 1305/grade_1305.txt";
$diff = 0;

x_1305_1;
x_1305_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1305/grade_1305.txt \n";

exit $diff;
