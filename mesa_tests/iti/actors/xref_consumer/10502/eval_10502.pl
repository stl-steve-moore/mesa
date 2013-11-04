#!/usr/local/bin/perl -w

# This script evaluates QBP^Q23 messages sent by a
# PIX Cross Reference Consumer for test 10502.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require xref_cons;
require mesa_common;
require mesa_evaluate;

sub dummy {}

sub x_10502_0 {
  print LOG "CTX: XREF 10502.0\n";
  print LOG "CTX: Evaluate QBP Q23 query\n";
  $queryNumber = 1003;
  if (-e "$MESA_STORAGE/xref/hl7/$queryNumber.hl7") {
    print LOG "Good, found at least one file we think is a query in $MESA_STORAGE/xref/hl7.\n";
    print LOG "No evaluation performed in this step; we are just looking for files.\n";
  } else {
    print LOG "Did not find a query from your PIX Consumer in $MESA_STORAGE/xref/hl7.\n";
    print LOG "There may be files in that directory, but 1001-1002 are ADT messages \n";
    print LOG " from the test script. Please rerun the test and submit queries.\n";
    $diff += 1;
  }
  print LOG "\n";
}

sub x_10502_1 {
  print LOG "CTX: XREF 10502.1\n";
  print LOG "CTX: Evaluate QBP Q23 query\n";
  $queryNumber = 1003;
  while (-e "$MESA_STORAGE/xref/hl7/$queryNumber.hl7") {
    $diff += mesa::dumpQBPMessage(
		$logLevel,
		"$MESA_STORAGE/xref/hl7/$queryNumber.hl7");
    $queryNumber += 1;
    print LOG "\n";
  }
}


### Main starts here
die "Usage: perl 10502/eval_10502.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);


open LOG, ">10502/grade_10502.txt" or die "Cout not open output file 10502/grade_10502.txt";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    10502\n";
print LOG "CTX: Actor:   PAT_IDENTITY_CONSUMER\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;
$logLevel = $ARGV[0];

x_10502_0;
x_10502_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 10502/grade_10502.txt \n";

print "This will be evaluated by visual inspection by the Manager.\n";
print "If you did not receive valid PIX responses, you need to get that working.\n";
print "You do need to submit grade_10502.txt for evaluation\n";

close LOG;

