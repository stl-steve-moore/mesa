#!/usr/local/bin/perl -w

# This script evaluates ADT messages that should be
# sent by ADT system for test 104.

use Env;
use lib "scripts";
require adt;

sub x_104_1 {
  print LOG "ADT 104.1\n";
  $diff += adt::evaluate_hl7(
	$verbose,
	"../../msgs/adt/104", "104.102.a04.hl7",
	"$MESA_STORAGE/ordfil", "1001.hl7",
	"ini_files/adt_a04_format.ini", "ini_files/adt_a04_compare.ini");
  print LOG "\n";
}

sub x_104_2 {
  print LOG "ADT 104.2\n";
  $diff += adt::evaluate_hl7(
	$verbose,
	"../../msgs/adt/104", "104.142.a04.hl7",
	"$MESA_STORAGE/ordfil", "1002.hl7",
	"ini_files/adt_a04_format.ini", "ini_files/adt_a04_compare.ini");
  print LOG "\n";
}

sub x_104_3 {
  print LOG "ADT 104.3\n";
  $diff += adt::evaluate_hl7(
	$verbose,
	"../../msgs/adt/104", "104.182.a40.hl7",
	"$MESA_STORAGE/ordfil", "1003.hl7",
	"ini_files/adt_a40_format.ini", "ini_files/adt_a40_compare.ini");
  print LOG "\n";
}

# Compare input ADT messages with expected values.

die "ADT test 104 is retired as of May, 2003.\n";

open LOG, ">104/grade_104.txt" or die "?!";
$diff = 0;
$verbose = grep /^-v/, @ARGV;

x_104_1;
x_104_2;
x_104_3;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 104/grade_104.txt \n";

exit $diff;
