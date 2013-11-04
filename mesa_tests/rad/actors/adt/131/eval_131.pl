#!/usr/local/bin/perl -w

# This script evaluates ADT messages sent by ADT
# system for test 131

use Env;
use lib "scripts";
require adt;

sub goodbye {}

sub x_131_1 {
  print LOG "CTX: ADT 131.1\n";
  print LOG "CTX: Evaluating A04 registration message to MESA Order Filler.\n";
  my $verbose = 0;
  $diff += mesa::evaluate_hl7(
	$logLevel,
	$verbose,
	"../../msgs/adt/131", "131.103.a04.hl7",
	"$MESA_STORAGE/ordfil", "1001.hl7",
	"ini_files/adt_a04_format.ini", "ini_files/adt_a04_compare.ini");
  print LOG "\n";
}

### Main starts here

# Compare input ADT messages with expected values.

die "Usage: perl 131/eval_131.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

open LOG, ">131/grade_131.txt" or die "Could not open output file: 131/grade_131.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";
$diff = 0;

x_131_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 131/grade_131.txt \n";

exit $diff;
