#!/usr/local/bin/perl -w

# Script evaluates client test 11121.
# This is the test for generating an audit STARTUP message.

use Env;

use lib "scripts";
require secure;

sub goodbye() {
  exit 1;
}

if (scalar(@ARGV) != 1) {
  print "This script requires one argument: <output level (1-4)> \n";
  exit 1;
}
$outputLevel = $ARGV[0];


open LOG, ">11121/grade_client_11121.txt" or die "?!";
$diff = 0;

$diff += secure::validate_atna_xml_schema($outputLevel, "$MESA_TARGET/logs/syslog/last_log.xml");

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 11121/grade_client_11121.txt \n";

exit $diff;
