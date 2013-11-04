#!/usr/local/bin/perl -w

# This script evaluates BAR messages sent by ADT
# system for test 1303.

use Env;
use lib "scripts";
require adt;

sub goodbye{}

sub x_1303_1 {
  print LOG "CTX: ADT 1303.1\n";
  print LOG "CTX: Evaluate BAR P01 message sent to MESA Order Filler.\n";
  $diff += mesa::evaluate_BAR_P01(
	$logLevel,
	"../../msgs/chg/1303/1303.102.p01.hl7",
	"$MESA_STORAGE/chgp/hl7/1001.hl7");
  print LOG "\n";
}

sub x_1303_2 {
  print LOG "CTX: ADT 1303.2\n";
  print LOG "CTX: Evaluate A01 admit message sent to MESA Order Filler.\n";
  my $verbose = 0;
  $diff += mesa::evaluate_hl7(
	$logLevel,
	$verbose,
	"../../msgs/adt/1303", "1303.106.a01.hl7",
	"$MESA_STORAGE/ordfil", "1001.hl7",
	"ini_files/adt_a01_format.ini", "ini_files/adt_a01_compare.ini");
  print LOG "\n";
}

sub x_1303_3 {
  print LOG "CTX: ADT 1303.3\n";
  print LOG "CTX: Evaluate BAR P06 message sent to MESA Order Filler.\n";
  $diff += mesa::evaluate_BAR_P06(
	$logLevel,
	"../../msgs/chg/1303/1303.110.p06.hl7",
	"$MESA_STORAGE/chgp/hl7/1002.hl7");
  print LOG "\n";
}


### Main starts here

# Compare input BAR messages with expected values.

open LOG, ">1303/grade_1303.txt" or die "Could not open output file: 1303/grade_1303.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";
$diff = 0;
die "Usage: perl 1303/eval_1303.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

x_1303_1;
x_1303_2;
x_1303_3;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 1303/grade_1303.txt \n";

exit $diff;
