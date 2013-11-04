#!/usr/local/bin/perl -w

# Script evaluates test 11103.
# This is the test for an actor specific message.

use Env;

use lib "scripts";
use lib "../common/scripts";
require secure;
require mesa;

sub goodbye() {
  exit 1;
}

if (scalar(@ARGV) != 3) {
  die "Usage: <output level> <schema: INTERIM or IETF> FILE";
  exit 1;
}
$outputLevel = $ARGV[0];
$testType = $ARGV[1];
$fileName = $ARGV[2];

open LOG, ">11103/grade_11103.txt" or die "?!";
$diff = 0;
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";


print LOG "CTX: Secure Node test 11103\n";
print LOG "CTX: Test type: $testType\n";
print LOG "CTX: File name: $fileName\n";

if ($testType eq "INTERIM") {
  $diff += secure::validate_xml_schema($outputLevel, $fileName);
} elsif ($testType eq "IETF") {
  $diff += secure::validate_atna_xml_schema($outputLevel, $fileName);
} else {
  print LOG "ERR: Unrecognized test type: $testType\n";
  print LOG "ERR: Should be INTERIM or IETF\n";
  $diff = 1;
}

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 11103/grade_11103.txt \n";

exit $diff;
