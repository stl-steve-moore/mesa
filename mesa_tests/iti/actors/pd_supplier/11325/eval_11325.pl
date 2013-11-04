#!/usr/local/bin/perl -w

# This script evaluates RSP^K22 messages sent by a
# PD Supplier for test 11325.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require pd_supplier;
require mesa_common;
require mesa_evaluate;

sub dummy {}

#sub x_11325_1 {
#  print LOG "CTX: PD Supplier 11325.1\n";
#  print LOG "CTX: Evaluate RSP K22 response to query 11325.\n";
#  print LOG "CTX: Evaluate ACK message.\n";
#  $diff += mesa::evaluate_PDQ_ACK (
#	$logLevel,
#	"11325/mesa/1000.hl7",
#	"11325/test/1000.hl7");
#  print LOG "\n";
#}

sub x_11325_2 {
  print LOG "CTX: PD Supplier 11325.2\n";
  print LOG "CTX: Evaluate RSP K22 response to query 11325.\n";
  print LOG "CTX: Evaluate baseline response.\n";
  $diff += mesa::evaluate_PDQ_RSP_K22_baseline(
	$logLevel,
	"11325/mesa/1000.hl7",
	"11325/test/1000.hl7");
  print LOG "\n";
}


### Main starts here

# Compare input RSP K22 messages with expected values.

open LOG, ">11325/grade_11325.txt" or die "Cout not open output file 11325/grade_11325.txt";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    11325\n";
print LOG "CTX: Actor:   PDS\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$logLevel = $ARGV[0];

#x_11325_1;
x_11325_2;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("11325/grade_11325.txt", "11325/mir_mesa_11325.xml",
        $logLevel, "11325", "PDS", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "\nThis test completed with zero errors; that means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 11325/grade_11325.txt and 11325/mir_mesa_11325.xml\n";
}

print "If you are submitting a result file to Kudu, submit 11325/mir_mesa_11325.xml\n\n";


