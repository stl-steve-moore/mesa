#!/usr/local/bin/perl -w

# This script evaluates ADT messages that should be
# sent by a Patient Encounter Source system for test 12120.

use Env;
use lib "scripts";
require pat_encounter_src;

sub x_12120_1 {
  print LOG "CTX: ADT 12120.1\n";
  print LOG "CTX: Evaluate A01 message\n";
  $diff += mesa::evaluate_ADT_A01 (
	$logLevel,
	"../../msgs/adt/12120/12120.110.a01.hl7",
	"$MESA_STORAGE/ordplc/1001.hl7");
  print LOG "\n";
}

sub x_12120_2 {
  print LOG "CTX: ADT 12120.2\n";
  print LOG "CTX: Evaluate A03 message\n";
  $diff += mesa::evaluate_ADT_A03 (
	$logLevel,
	"../../msgs/adt/12120/12120.120.a03.hl7",
	"$MESA_STORAGE/ordplc/1002.hl7");
  print LOG "\n";
}

# Main starts here
die "Usage: perl 12120/eval_12120.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);

open LOG, ">12120/grade_12120.txt" or die "Could not open output file 12120/grade_12120.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";

$diff = 0;
$logLevel = $ARGV[0];

x_12120_1;
x_12120_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 12120/grade_12120.txt \n";

exit $diff;
