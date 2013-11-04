#!/usr/local/bin/perl -w

# This script evaluates ADT messages that should be
# sent by ADT system for test 1240.

use Env;
use lib "scripts";
require adt;

sub x_1240_1 {
  print LOG "CTX: ADT 1240.1\n";
  print LOG "CTX: Evaluate A04 message for known patient\n";
  $diff += mesa::evaluate_ADT_A04 (
	$logLevel,
	"../../msgs/adt/1240/1240.102.a04.hl7",
	"$MESA_STORAGE/ordfil/1001.hl7");
  print LOG "\n";
}

# Main starts here
die "Usage: perl 1240/eval_1240.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);

open LOG, ">1240/grade_1240.txt" or die "Could not open output file 1240/grade_1240.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";
$diff = 0;
$logLevel = $ARGV[0];

x_1240_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 1240/grade_1240.txt \n";

exit $diff;
