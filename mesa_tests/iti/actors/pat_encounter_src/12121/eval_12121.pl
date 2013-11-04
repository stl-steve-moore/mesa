#!/usr/local/bin/perl -w

# This script evaluates ADT messages that should be
# sent by a Patient Encounter Source system for test 12121.

use Env;
use lib "scripts";
require pat_encounter_src;

sub x_12121_1 {
  print LOG "CTX: ADT 12121.1\n";
  print LOG "CTX: Evaluate A04 message\n";
  $diff += mesa::evaluate_ADT_A04_PAM (
	$logLevel,
	"../../msgs/adt/12121/12121.110.a04.hl7",
	"$MESA_STORAGE/ordplc/1001.hl7");
  print LOG "\n";
}

# Main starts here
die "Usage: perl 12121/eval_12121.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);

open LOG, ">12121/grade_12121.txt" or die "Could not open output file 12121/grade_12121.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";

$diff = 0;
$logLevel = $ARGV[0];

x_12121_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 12121/grade_12121.txt \n";

exit $diff;
