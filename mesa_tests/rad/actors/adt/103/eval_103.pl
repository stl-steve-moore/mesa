#!/usr/local/bin/perl -w

# This script evaluates ADT messages that should be
# sent by ADT system for test 103.

use Env;
use lib "scripts";
require adt;

sub goodbye {}

#sub x_103_1 {
#  print LOG "CTX: ADT 103.1\n";
#  $diff += mesa::evaluate_hl7(
#	$logLevel,
#	$verbose,
#	"../../msgs/adt/103", "103.102.a04.hl7",
#	"$MESA_STORAGE/ordfil", "1001.hl7",
#	"ini_files/adt_a04_format.ini", "ini_files/adt_a04_compare.ini");
#  print LOG "\n";
#}

sub x_103_2 {
  print LOG "ADT 103.2\n";
  $diff += mesa::evaluate_ADT_A04(
	$logLevel,
	"../../msgs/adt/103/103.103.a04.hl7",
	"$MESA_STORAGE/ordfil/1001.hl7");
  print LOG "\n";
}

#sub x_103_3 {
#  print LOG "ADT 103.3\n";
#  $diff += mesa::evaluate_hl7(
#	$logLevel,
#	$verbose,
#	"../../msgs/adt/103", "103.130.a08.hl7",
#	"$MESA_STORAGE/ordfil", "1002.hl7",
#	"ini_files/adt_a08_format.ini", "ini_files/adt_a08_compare.ini");
#  print LOG "\n";
#}

sub x_103_4 {
  print LOG "ADT 103.4\n";
  $diff += mesa::evaluate_ADT_A08(
	$logLevel,
	"../../msgs/adt/103/103.130.a08.hl7",
	"$MESA_STORAGE/ordfil/1002.hl7");
  print LOG "\n";
}

# Compare input ADT messages with expected values.

open LOG, ">103/grade_103.txt" or die "?!";
$diff = 0;
#$verbose = 0;
die "Usage: perl 103/eval_103.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];


#x_103_1;
x_103_2;	# This is the first ADT A04
x_103_4;	# This is the ADT A08

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 103/grade_103.txt \n";

exit $diff;
