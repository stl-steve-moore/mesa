#!/usr/local/bin/perl -w

# This script evaluates ADT messages that should be
# sent by ADT system for test 102.

use Env;
use lib "scripts";
require adt;

sub x_102_1 {
  print LOG "ADT 102.1\n";
  $diff += adt::evaluate_hl7(
	$verbose,
	"../../msgs/adt/102", "102.102.a05.hl7",
	"$MESA_STORAGE/ordfil", "1001.hl7",
	"ini_files/adt_a05_format.ini", "ini_files/adt_a05_compare.ini");
  print LOG "\n";
}

sub x_102_2 {
  print LOG "ADT 102.2\n";
  $diff += adt::evaluate_hl7(
	$verbose,
	"../../msgs/adt/102", "102.108.a01.hl7",
	"$MESA_STORAGE/ordfil", "1002.hl7",
	"ini_files/adt_a01_format.ini", "ini_files/adt_a01_compare.ini");
  print LOG "\n";
}

sub x_102_3 {
  print LOG "ADT 102.3\n";
  $diff += adt::evaluate_hl7(
	$verbose,
	"../../msgs/adt/102", "102.136.a03.hl7",
	"$MESA_STORAGE/ordfil", "1003.hl7",
	"ini_files/adt_a03_format.ini", "ini_files/adt_a03_compare.ini");
  print LOG "\n";
}

# Compare input ADT messages with expected values.

die "ADT test 102 is retired as of May, 2003\n";

open LOG, ">102/grade_102.txt" or die "?!";
$diff = 0;
$verbose = grep /^-v/, @ARGV;

x_102_1;
x_102_2;
x_102_3;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 102/grade_102.txt \n";

exit $diff;
