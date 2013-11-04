#!/usr/local/bin/perl -w

# This script evaluates ADT messages that should be
# sent by an Identity Source system for test 10512.

use Env;
use lib "scripts";
require id_src;

sub x_10512_1 {
  print LOG "CTX: ADT 10512.1\n";
  print LOG "CTX: Evaluate A04 message\n";
  $diff += mesa::evaluate_ADT_A04_PIX (
	$logLevel,
	"../../msgs/adt/10512/10512.102.a04.hl7",
	"$MESA_STORAGE/xref/hl7/1001.hl7");
  print LOG "\n";
}

# Main starts here
die "Test 10512 is replaced by 10512a, 10512b, 10512c";
#die "Usage: perl 10512/eval_10512.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
#
#open LOG, ">10512/grade_10512.txt" or die "Could not open output file 10512/grade_10512.txt";
#my $mesaVersion = mesa::getMESAVersion();
#print LOG "CTX: $mesaVersion \n";
#
$diff = 0;
$logLevel = $ARGV[0];
#
#x_10512_1;
#
#print LOG "\nTotal Differences: $diff \n";
#print "\nTotal Differences: $diff \n";
#print "Logs stored in 10512/grade_10512.txt \n";
#
#exit $diff;
