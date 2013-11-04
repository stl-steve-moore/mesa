#!/usr/local/bin/perl -w

# This script evaluates BAR messages sent by ADT
# system for test 1302.

use Env;
use lib "scripts";
require adt;

sub goodbye {}

sub x_1302_1 {
  print LOG "ADT 1302.1\n";
  $diff += mesa::evaluate_BAR_P01(
	$logLevel,
	"../../msgs/chg/1302/1302.102.p01.hl7",
	"$MESA_STORAGE/chgp/hl7/1001.hl7");
  print LOG "\n";
}

sub x_1302_2 {
  print LOG "CTX: ADT 1302.2\n";
  print LOG "CTX: Evaluate A01 admit message sent to MESA Order Filler.\n";
  my $verbose = 0;
  $diff += mesa::evaluate_hl7(
	$logLevel,
	$verbose,
	"../../msgs/adt/1302", "1302.106.a01.hl7",
	"$MESA_STORAGE/ordfil", "1001.hl7",
	"ini_files/adt_a01_format.ini", "ini_files/adt_a01_compare.ini");
  print LOG "\n";
}

sub x_1302_3 {
  print LOG "ADT 1303.2\n";
  $diff += mesa::evaluate_BAR_P05(
	$logLevel,
	"../../msgs/chg/1302/1302.110.p05.hl7",
	"$MESA_STORAGE/chgp/hl7/1002.hl7");
  print LOG "\n";
}


### Main starts here

# Compare input BAR messages with expected values.

open LOG, ">1302/grade_1302.txt" or die "Could not open output file: 1302/grade_1302.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";
$diff = 0;
die "Usage: perl 1302/eval_1302.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

x_1302_1;
x_1302_2;
x_1302_3;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 1302/grade_1302.txt \n";

exit $diff;
