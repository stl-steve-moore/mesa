#!/usr/local/bin/perl -w

# This script evaluates ADT messages sent by ADT
# system for test 141

use Env;
use lib "scripts";
require adt;

sub x_141_1 {
  print LOG "CTX: ADT 141.1\n";
  print LOG "CTX: Evaluating A04 registration message to MESA Order Filler.\n";
  my $verbose = 0;
  $diff += mesa::evaluate_ADT_A04_Japanese(
	$logLevel,
	"../../msgs/adt/141/141.104.a04.hl7",
	"$MESA_STORAGE/ordfil/1001.hl7");
  print LOG "\n";
}

### Main starts here

# Compare input ADT messages with expected values.

die "Usage: perl 141/eval_141.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

open LOG, ">141/grade_141.txt" or die "Could not open output file: 141/grade_141.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";
$diff = 0;

x_141_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 141/grade_141.txt \n";

exit $diff;
