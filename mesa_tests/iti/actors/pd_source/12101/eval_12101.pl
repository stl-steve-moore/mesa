#!/usr/local/bin/perl -w

# This script evaluates ADT messages that should be
# sent by a Patient Demographics Source system for test 12101.

use Env;
use lib "scripts";
require pds_pam;

sub goodbye () {}

sub x_12101_1 {
  print LOG "CTX: ADT 12101.1\n";
  print LOG "CTX: Evaluate A28 message\n";
  $diff += mesa::evaluate_ADT_A28 (
	$logLevel,
	"../../msgs/adt/12101/12101.102.a28.hl7",
	"$MESA_STORAGE/ordfil/1001.hl7");
  print LOG "\n";
}

# Main starts here
die "Usage: perl 12101/eval_12101.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);

open LOG, ">12101/grade_12101.txt" or die "Could not open output file 12101/grade_12101.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";

$diff = 0;
$logLevel = $ARGV[0];

x_12101_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 12101/grade_12101.txt \n";

exit $diff;
