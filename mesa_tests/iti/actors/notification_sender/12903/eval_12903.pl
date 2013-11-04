#!/usr/local/bin/perl -w

# Script evaluates test 12903.
# This is the test for generating an audit STARTUP message.

use Env;

use lib "scripts";
use lib "../common/scripts";
require mesa;

sub goodbye() {
  exit 1;
}

if (scalar(@ARGV) != 3) {
  die "Usage: <output level> <schema> FILE";
  exit 1;
}
$outputLevel = $ARGV[0];
$schema = $ARGV[1];
$fileName = $ARGV[2];

open LOG, ">12903/grade_12903.txt" or die "?!";
$diff = 0;
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";


print LOG "CTX: NAV test 12903\n";
print LOG "CTX: Schema: $schema\n";
print LOG "CTX: File name: $fileName\n";

$diff += mesa::validate_xml_schema($outputLevel, $schema, $fileName);

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 12903/grade_12903.txt \n";

exit $diff;
