#!/usr/local/bin/perl -w

# Script evaluates Secure Node client test 11126.

use Env;

use lib "scripts";
use lib "../common/scripts";
require secure;
require mesa_xml;

sub goodbye() {
  exit 1;
}

if (scalar(@ARGV) != 3) {
  print "This script requires three arguments: <output level (1-4)> <Audit File> <message #: 1, 2, 3,,,>\n";
  exit 1;
}
my ($outputLevel, $inFile, $messageNumber) = @ARGV;

open LOG, ">11126/grade_client_11126.txt" or die "?!";
$diff = 0;

$outFile = "11126/11126-$messageNumber.html";
$inXSL = "$MESA_TARGET/runtime/MESA-ATNA.xsl";

$diff += mesa_xml::performXSLTransform($outputLevel, $outFile, $inFile, $inXSL, "");

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 11126/grade_client_11126.txt \n";
print "HTML output stored in 11126/11126.html\n";

exit $diff;
