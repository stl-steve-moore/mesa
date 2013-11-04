#!/usr/local/bin/perl -w

# This script evaluates QBP Q22 requests sent by a
# PD Consumer for test 11365.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require pd_consumer;
require mesa_common;
require mesa_evaluate;

sub dummy {}

sub x_11365_1 {
  print LOG "\nCTX: PD Consumer 11365.1\n";
  print LOG "CTX: Print query for visual evaluation.\n";
  my $x = "$MESA_TARGET/bin/hl7_to_txt -d ihe-iti $MESA_STORAGE/pd_supplier/hl7/query.hl7";
  print LOG "$x\n";
  print LOG `$x`;

  print LOG "\n";
}

sub x_11365_2 {
  print LOG "\nCTX: PD Supplier 11365.2\n";
  print LOG "CTX: Evaluate QBP Q22 query 11365.\n";
  $diff += mesa::evaluate_PDQ_QBP_Q22 (
	$logLevel,
	"../../msgs/pdq/11365/11365.102.q22.hl7",
	"$MESA_STORAGE/pd_supplier/hl7/query.hl7");
  print LOG "\n";
}

sub x_11365_3 {
  print LOG "\nCTX: PD Supplier 11365.3\n";
  print LOG "CTX: Evaluate QBP Q22 query 11365.\n";
  print LOG "CTX: Looking for Continuation Pointer information\n";
  $diff += mesa::evaluate_PDQ_QBP_Q22_continuation (
	$logLevel,
	"../../msgs/pdq/11365/11365.110.q22.hl7",
	"$MESA_STORAGE/pd_supplier/hl7/1002.hl7");
  print LOG "\n";
}


### Main starts here

# Compare input QBP Q22 messages with expected values.
die "Usage: perl 11365/eval_11365.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

open LOG, ">11365/grade_11365.txt" or die "Cout not open output file 11365/grade_11365.txt";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    11365\n";
print LOG "CTX: Actor:   PDC\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

x_11365_1;
x_11365_2;
x_11365_3;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("11365/grade_11365.txt", "11365/mir_mesa_11365.xml",
        $logLevel, "11365", "PDC", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "\nThis test completed with zero errors; that means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 11365/grade_11365.txt and 11365/mir_mesa_11365.xml\n";
}

print "If you are submitting a result file to Kudu, submit 11365/mir_mesa_11365.xml\n\n";

