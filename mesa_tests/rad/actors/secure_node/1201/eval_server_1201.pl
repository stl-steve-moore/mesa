#!/usr/local/bin/perl -w

# Script evaluates server test 1201.
# This is the test for generating an audit STARTUP message.

use Env;

use lib "scripts";
require secure;

sub goodbye() {
  exit 1;
}

if (scalar(@ARGV) != 2) {
  print "Usage: <output level (1-4)> <INTERIM or IETF> \n";
  exit 1;
}
$outputLevel = $ARGV[0];
$testType    = $ARGV[1];

open LOG, ">1201/grade_server_1201.txt" or die "?!";
$diff = 0;

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

print "Logs stored in 1201/grade_server_1201.txt \n";

exit $diff;
