#!/usr/local/bin/perl -w

# This script evaluates ADT messages sent by ADT
# system for test 142

use Env;
use lib "scripts";
require adt;

sub x_142_1 {
  print LOG "CTX: ADT 142.1\n";
  print LOG "CTX: Evaluate A01 admit message sent to MESA Order Filler.\n";
  my $verbose = 0;
  $diff += mesa::evaluate_ADT_A01_Japanese(
	$logLevel,
	"../../msgs/adt/142/142.104.a01.hl7",
	"$MESA_STORAGE/ordfil/1001.hl7");
  print LOG "\n";
}

### Main starts here

# Compare input ADT messages with expected values.

die "Usage: perl 142/eval_142.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

open LOG, ">142/grade_142.txt" or die "?!";
$diff = 0;

x_142_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 142/grade_142.txt \n";

exit $diff;
