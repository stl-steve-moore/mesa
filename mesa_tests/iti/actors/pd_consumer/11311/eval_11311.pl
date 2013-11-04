#!/usr/local/bin/perl -w

# This script evaluates QBP Q22 requests sent by a
# PD Consumer for test 11311.

use Env;
use lib "scripts";
require pd_consumer;
use lib "../../../common/scripts";
require mesa_common;
require mesa_evaluate;

sub dummy {}


sub x_11311_1 {
  print LOG "\nCTX: PD Consumer 11311.1\n";
  print LOG "CTX: Print query for visual evaluation.\n";
  my $x = "$MESA_TARGET/bin/hl7_to_txt -d ihe-iti $MESA_STORAGE/pd_supplier/hl7/query.hl7";
  print LOG "$x\n";
  print LOG `$x`;

  print LOG "\n";
}

sub x_11311_2 {
  print LOG "\nCTX: PD Supplier 11311.2\n";
  print LOG "CTX: Evaluate QBP Q22 query 11311.\n";
  $diff += mesa::evaluate_PDQ_QBP_Q22 (
	$logLevel,
	"../../msgs/pdq/11311/11311.102.q22.hl7",
	"$MESA_STORAGE/pd_supplier/hl7/query.hl7");
  print LOG "\n";
}


### Main starts here

# Compare input QBP Q22 messages with expected values.
die "Usage: perl 11311/eval_11311.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

open LOG, ">11311/grade_11311.txt" or die "Could not open output file 11311/grade_11311.txt";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    11311\n";
print LOG "CTX: Actor:   PDC\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

x_11311_1;
x_11311_2;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("11311/grade_11311.txt", "11311/mir_mesa_11311.xml",
        $logLevel, "11311", "PDC", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "\nThis test completed with zero errors; that means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 11311/grade_11311.txt and 11311/mir_mesa_11311.xml\n";
}

print "If you are submitting a result file to Kudu, submit 11311/mir_mesa_11311.xml\n\n";

