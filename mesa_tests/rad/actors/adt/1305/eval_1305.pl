#!/usr/local/bin/perl -w

# This script evaluates ADT and BAR messages sent by ADT
# system for test 1305.

use Env;
use lib "scripts";
require adt;

sub goodbye {}

sub x_1305_1 {
  print LOG "CTX: ADT 1305.1\n";
  print LOG "CTX: Evaluate BAR P01 message sent to MESA Order Filler.\n";
  $diff += mesa::evaluate_BAR_P01(
	$logLevel,
	"../../msgs/chg/1305/1305.102.p01.hl7",
	"$MESA_STORAGE/chgp/hl7/1001.hl7");
  print LOG "\n";
}

sub x_1305_2 {
  print LOG "CTX: ADT 1305.2\n";
  print LOG "CTX: Evaluate A01 admit message sent to MESA Order Filler.\n";
  my $verbose = 0;
  $diff += mesa::evaluate_hl7(
	$logLevel,
	$verbose,
	"../../msgs/adt/1305", "1305.106.a01.hl7",
	"$MESA_STORAGE/ordfil", "1001.hl7",
	"ini_files/adt_a01_format.ini", "ini_files/adt_a01_compare.ini");
  print LOG "\n";
}

### Main starts here

# Compare input ADT and BAR messages with expected values.

open LOG, ">1305/grade_1305.txt" or die "Cout not open output file 1305/grade_1305.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";
$diff = 0;
die "Usage: perl 1305/eval_1305.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

x_1305_1;
x_1305_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 1305/grade_1305.txt \n";

exit $diff;
