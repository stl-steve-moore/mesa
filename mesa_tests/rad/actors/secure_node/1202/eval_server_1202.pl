#!/usr/local/bin/perl -w

# Script evaluates server test 1202.
# This is the test for generating an audit Actor-config message.

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


open LOG, ">1202/grade_server_1202.txt" or die "?!";
$diff = 0;

$diff += secure::validate_xml_schema($outputLevel, "$MESA_TARGET/logs/syslog/last_log.xml");

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1202/grade_server_1202.txt \n";

exit $diff;
