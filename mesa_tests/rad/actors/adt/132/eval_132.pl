#!/usr/local/bin/perl -w

# This script evaluates ADT messages sent by ADT
# system for test 132

use Env;
use lib "scripts";
require adt;

sub goodbye {}

sub x_132_1 {
  print LOG "CTX: ADT 132.1\n";
  print LOG "CTX: Evaluate A01 admit message sent to MESA Order Filler.\n";
  my $verbose = 0;
  $diff += mesa::evaluate_hl7(
	$logLevel,
	$verbose,
	"../../msgs/adt/132", "132.103.a01.hl7",
	"$MESA_STORAGE/ordfil", "1001.hl7",
	"ini_files/adt_a01_format.ini", "ini_files/adt_a01_compare.ini");
  print LOG "\n";
}

sub x_132_2 {
  print LOG "CTX: ADT 132.2\n";
  print LOG "CTX: Evaluate A03 discharge message sent to MESA Order Filler.\n";
  my $verbose = 0;
  $diff += mesa::evaluate_hl7(
	$logLevel,
	$verbose,
	"../../msgs/adt/132", "132.143.a03.hl7",
	"$MESA_STORAGE/ordfil", "1002.hl7",
	"ini_files/adt_a03_format.ini", "ini_files/adt_a03_compare.ini");
  print LOG "\n";
}

### Main starts here

# Compare input ADT messages with expected values.

die "Usage: perl 132/eval_132.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

open LOG, ">132/grade_132.txt" or die "?!";
$diff = 0;

x_132_1;
x_132_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 132/grade_132.txt \n";

exit $diff;
