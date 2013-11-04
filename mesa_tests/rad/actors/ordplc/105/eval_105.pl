#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require ordplc;

sub goodbye {}

sub x_105_1 {
  print LOG "CTX: Order Placer 105.1\n";
  print LOG "CTX: Evaluate O02 message sent to MESA Order Filler.\n";
  $diff += mesa::evaluate_hl7(
		$logLevel,
		$verbose,
		"../../msgs/order/105", "105.116.o02.hl7",
		"$MESA_STORAGE/ordfil", "1002.hl7",
		"ini_files/orr_o02_format.ini", "ini_files/orr_o02_compare.ini");
  print LOG "\n";
}

## Main starts here

open LOG, ">105/grade_105.txt" or die "?!";
$diff = 0;
$verbose = 0;
die "Usage: perl 105/eval_105.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

x_105_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 105/grade_105.txt \n";

exit $diff;
