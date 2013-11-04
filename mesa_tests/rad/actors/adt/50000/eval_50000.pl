#!/usr/local/bin/perl -w

# This script evaluates ADT messages that should be
# sent by ADT system for test 50000.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require adt;
require mesa_common;

sub goodbye {}

sub x_50000_1 {
  print LOG "\nCTX: ADT 50000.1\n";
  print LOG "CTX: A04 Registration \n";
  $diff += mesa::evaluate_ADT_A04 (
	$logLevel,
	"../../msgs/adt/50000/50000.120.a04.hl7",
	"$MESA_STORAGE/ordfil/1001.hl7");
  print LOG "\n";
}

# Compare input ADT messages with expected values.

$diff = 0;
die "Usage: perl 50000/eval_50000.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

open LOG, ">50000/grade_50000.txt" or die "?!";
my $mesaVersion = mesa_get::getMESAVersion();
my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
print LOG "CTX: $mesaVersion \n";
print LOG "CTX: current date/time $date $timeToMinute\n";
print LOG "CTX: Log Level $logLevel\n";

x_50000_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 50000/grade_50000.txt \n";

exit $diff;
