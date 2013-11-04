#!/usr/local/bin/perl -w

# Script evaluates test 11101.
# This is the test for generating an audit STARTUP message.

use Env;

use lib "scripts";
use lib "../common/scripts";
require secure;
require mesa;

sub goodbye() {
  exit 1;
}

if (scalar(@ARGV) != 2) {
  die "Usage: <output level> <schema: INTERIM or IETF>";
  exit 1;
}
$outputLevel = $ARGV[0];
$testType = $ARGV[1];

open LOG, ">11101/grade_11101.txt" or die "?!";
$diff = 0;
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";


print LOG "CTX: Secure Node test 11101\n";
print LOG "CTX: Test type: $testType\n";

if ($testType eq "INTERIM") {
  $diff += secure::validate_xml_schema($outputLevel, "$MESA_TARGET/logs/syslog/last_log.xml");
} elsif ($testType eq "IETF") {
  $diff += secure::validate_atna_xml_schema($outputLevel, "$MESA_TARGET/logs/syslog/last_log.xml");
} else {
  print LOG "ERR: Unrecognized test type: $testType\n";
  print LOG "ERR: Should be INTERIM or IETF\n";
  $diff = 1;
}

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 11101/grade_11101.txt \n";

exit $diff;
