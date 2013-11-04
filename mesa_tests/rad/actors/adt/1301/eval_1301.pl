#!/usr/local/bin/perl -w

# This script evaluates BAR messages sent by ADT
# system for test 1301.

use Env;
use lib "scripts";
require adt;

sub goodbye {}

sub x_1301_1 {
  print LOG "ADT 1301.1\n";
  $diff += mesa::evaluate_BAR_P01(
	$logLevel,
	"../../msgs/chg/1301/1301.102.p01.hl7",
	"$MESA_STORAGE/chgp/hl7/1001.hl7");
  print LOG "\n";
}

#sub x_1301_2 {
#  print LOG "ADT 1301.2\n";
#  $verbose = 1;
#  $diff += adt::evaluate_hl7(
#	$logLevel,
#	$verbose,
#	"../../msgs/chg/1301", "1301.102.p01.hl7",
#	"$MESA_STORAGE/chgp/hl7", "1001.hl7",
#	"ini_files/bar_p01_format.ini", "ini_files/bar_p01_compare.ini");
#  print LOG "\n";
#}


### Main starts here

# Compare input BAR messages with expected values.

open LOG, ">1301/grade_1301.txt" or die "Could not open output file: 1301/grade_1301.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";
$diff = 0;
die "Usage: perl 1301/eval_1301.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

x_1301_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 1301/grade_1301.txt \n";

exit $diff;
