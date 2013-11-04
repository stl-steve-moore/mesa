#!/usr/local/bin/perl -w

# This script evaluates ADT messages that should be
# sent by ADT system for test 50002.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require adt;
require mesa_common;

sub goodbye {}

sub x_50002_1 {
  print LOG "\nCTX: ADT 50002.1\n";
  print LOG "CTX: A04 Registration \n";
  my $x = mesa::evaluate_ADT_A04 (
	$logLevel,
	"../../msgs/adt/50002/50002.120.a04.hl7",
	"$MESA_STORAGE/ordfil/1001.hl7");
  print LOG "\n";
  return $x;
}

sub x_50002_2 {
  print LOG "\nADT 50002.2\n";
  print LOG "CTX: A08 Rename message after patient is identified\n";
  my $x = mesa::evaluate_ADT_A08(
        $logLevel,
        "../../msgs/adt/50002/50002.190.a08.hl7",
        "$MESA_STORAGE/ordfil/1002.hl7");
  print LOG "\n";
  return $x;
}


# Compare input ADT messages with expected values.

die "Usage: perl 50002/eval_50002.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

open LOG, ">50002/grade_50002.txt" or die "?!";
my $mesaVersion = mesa_get::getMESAVersion();
my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
print LOG "CTX: $mesaVersion \n";
print LOG "CTX: current date/time $date $timeToMinute\n";
print LOG "CTX: Log Level $logLevel\n";

$diff = 0;
$diff += x_50002_1;
$diff += x_50002_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 50002/grade_50002.txt \n";

exit $diff;
