#!/usr/local/bin/perl -w

# This script evaluates ADT messages sent by ADT
# system for test 101.

use Env;
use lib "scripts";
require adt;

sub x_101_1 {
  print LOG "ADT 101.1\n";
  $diff += adt::evaluate_hl7(
	$verbose,
	"../../msgs/adt/101", "101.102.a04.hl7",
	"$MESA_STORAGE/ordfil", "1001.hl7",
	"ini_files/adt_a04_format.ini", "ini_files/adt_a04_compare.ini");
  print LOG "\n";
}

sub x_101_2 {
  print LOG "ADT 101.2\n";
  $diff += adt::evaluate_hl7(
	$verbose,
	"../../msgs/adt/101", "101.126.a06.hl7",
	"$MESA_STORAGE/ordfil", "1002.hl7",
	"ini_files/adt_a06_format.ini", "ini_files/adt_a06_compare.ini");
  print LOG "\n";
}

sub x_101_3 {
  print LOG "ADT 101.3\n";
  $diff += adt::evaluate_hl7(
	$verbose,
	"../../msgs/adt/101", "101.130.a03.hl7",
	"$MESA_STORAGE/ordfil", "1003.hl7",
	"ini_files/adt_a03_format.ini", "ini_files/adt_a03_compare.ini");
  print LOG "\n";
}

sub x_101_4 {
  print LOG "ADT 101.4\n";
  $diff += adt::evaluate_hl7(
	$verbose,
	"../../msgs/adt/101", "101.160.a04.hl7",
	"$MESA_STORAGE/ordfil", "1004.hl7",
	"ini_files/adt_a04_format.ini", "ini_files/adt_a04_compare.ini");
  print LOG "\n";
}

sub x_101_5 {
  print LOG "ADT 101.5\n";
  $diff += adt::evaluate_hl7(
	$verbose,
	"../../msgs/adt/101", "101.166.a40.hl7",
	"$MESA_STORAGE/ordfil", "1005.hl7",
	"ini_files/adt_a40_format.ini", "ini_files/adt_a40_compare.ini");
  print LOG "\n";
}

### Main starts here

# Compare input ADT messages with expected values.

die "ADT test 101 is retired as August, 2003\n";

open LOG, ">101/grade_101.txt" or die "?!";
$diff = 0;
$verbose = grep /^-v/, @ARGV;

x_101_1;
x_101_2;
x_101_3;
x_101_4;
x_101_5;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 101/grade_101.txt \n";

exit $diff;
