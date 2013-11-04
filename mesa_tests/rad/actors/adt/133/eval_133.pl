#!/usr/local/bin/perl -w

# This script evaluates ADT messages that should be
# sent by ADT system for test 133.

use Env;
use lib "scripts";
require adt;

sub x_133_1 {
  print LOG "CTX: ADT 133.1\n";
  print LOG "CTX: Evaluate A04 message for known patient\n";
  $diff += mesa::evaluate_ADT_A04 (
	$logLevel,
	"../../msgs/adt/133/133.103.a04.hl7",
	"$MESA_STORAGE/ordfil/1001.hl7");
  print LOG "\n";
}

sub x_133_2 {
  print LOG "CTX: ADT 133.2\n";
  print LOG "CTX: Evaluate A04 message for unknown patient\n";
  $diff += mesa::evaluate_ADT_A04 (
	$logLevel,
	"../../msgs/adt/133/133.143.a04.hl7",
	"$MESA_STORAGE/ordfil/1002.hl7");
  print LOG "\n";
}

sub x_133_3 {
  print LOG "CTX: ADT 133.3\n";
  print LOG "CTX: Evaluate A40 merge message \n";
  $diff += mesa::evaluate_hl7 (
	$logLevel,
	0,		# Verbose flag
	"../../msgs/adt/133", "133.183.a40.hl7",
	"$MESA_STORAGE/ordfil", "1003.hl7",
	"ini_files/adt_a40_format.ini", "ini_files/adt_a40_compare.ini");
  print LOG "\n";
}

# Main starts here
die "Usage: perl 133/eval_133.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);

open LOG, ">133/grade_133.txt" or die "?!";
$diff = 0;
$logLevel = $ARGV[0];

x_133_1;
x_133_2;
x_133_3;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 133/grade_133.txt \n";

exit $diff;
