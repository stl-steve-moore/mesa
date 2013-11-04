#!/usr/local/bin/perl -w

# This script evaluates ADT messages that should be
# sent by ADT system for test 105.

use Env;
use lib "scripts";
require adt;

sub goodbye {}

sub x_105_1 {
  print LOG "CTX: ADT 105.1\n";
  print LOG "CTX: A04 Registration for unidentified patient\n";
  $diff += mesa::evaluate_ADT_A04 (
	$logLevel,
	"../../msgs/adt/105/105.102.a04.hl7",
	"$MESA_STORAGE/ordfil/1001.hl7");
  print LOG "\n";
}

sub x_105_2 {
  print LOG "ADT 105.2\n";
  print LOG "CTX: A08 Rename message after patient is identified\n";
  $diff += mesa::evaluate_ADT_A08(
	$logLevel,
	"../../msgs/adt/105/105.121.a08.hl7",
	"$MESA_STORAGE/ordfil/1002.hl7");
  print LOG "\n";
}

# Compare input ADT messages with expected values.

open LOG, ">105/grade_105.txt" or die "?!";
$diff = 0;
#$verbose = 0;
die "Usage: perl 105/eval_105.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

x_105_1;
x_105_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 105/grade_105.txt \n";

exit $diff;
