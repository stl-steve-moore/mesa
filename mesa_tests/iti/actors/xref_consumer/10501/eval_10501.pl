#!/usr/local/bin/perl -w

# This script evaluates QBP^Q23 messages sent by a
# PIX Cross Reference Consumer for test 10501.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require xref_cons;
require mesa_common;
require mesa_evaluate;

sub dummy {}

sub x_10501_0 {
  print LOG "CTX: XREF 10501.0\n";
  print LOG "CTX: Evaluate QBP Q23 query\n";
  $queryNumber = 1004;
  if (-e "$MESA_STORAGE/xref/hl7/$queryNumber.hl7") {
    print LOG "Good, found at least one file we think is a query in $MESA_STORAGE/xref/hl7.\n";
    print LOG "No evaluation performed in this step; we are just looking for files.\n";
  } else {
    print LOG "Did not find a query from your PIX Consumer in $MESA_STORAGE/xref/hl7.\n";
    print LOG "There may be files in that directory, but 1001-1003 are ADT messages \n";
    print LOG " from the test script. Please rerun the test and submit queries.\n";
    $diff += 1;
  }
  print LOG "\n";
}

sub x_10501_1 {
  print LOG "CTX: XREF 10501.1\n";
  print LOG "CTX: Evaluate QBP Q23 query\n";
  $queryNumber = 1004;
  while (-e "$MESA_STORAGE/xref/hl7/$queryNumber.hl7") {
    $diff += mesa::dumpQBPMessage(
		$logLevel,
		"$MESA_STORAGE/xref/hl7/$queryNumber.hl7");
    $queryNumber += 1;
    print LOG "\n";
  }
}


### Main starts here
die "Usage: perl 10501/eval_10501.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);

open LOG, ">10501/grade_10501.txt" or die "Cout not open output file 10501/grade_10501.txt";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    10501\n";
print LOG "CTX: Actor:   PAT_IDENTITY_CONSUMER\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";



$diff = 0;
$logLevel = $ARGV[0];

x_10501_0;
x_10501_1;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 10501/grade_10501.txt \n";

print "This will be evaluated by visual inspection by the Manager.\n";
print "If you did not receive valid PIX responses, you need to get that working.\n";
print "You do need to submit the grade_10501.txt file to Kudu for evaluation.\n";

close LOG;

