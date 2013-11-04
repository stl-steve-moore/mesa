#!/usr/local/bin/perl -w

# Script evaluates test 11102.
# This is the test for generating an audit STARTUP message.

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

open LOG, ">11102/grade_11102.txt" or die "?!";
$diff = 0;
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";


print LOG "CTX: Secure Node test 11102\n";
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

print "Logs stored in 11102/grade_11102.txt \n";

exit $diff;
