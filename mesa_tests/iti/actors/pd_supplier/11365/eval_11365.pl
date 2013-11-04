#!/usr/local/bin/perl -w

# This script evaluates RSP^K22 messages sent by a
# PD Supplier for test 11365.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require pd_supplier;
require mesa_common;
require mesa_evaluate;

sub dummy {}

sub x_11365_1 {
  print LOG "CTX: PD Supplier 11365.1\n";
  print LOG "CTX: Evaluate first RSP K22 response to query 11365.\n";
  print LOG "CTX: Evaluate baseline response.\n";
  $diff += mesa::evaluate_PDQ_RSP_K22_Continuation (
        $logLevel,
        "11365/mesa/1000.hl7",
        "11365/test/1000.hl7");
  print LOG "\n";
}

sub x_11365_2 {
  print LOG "CTX: PD Supplier 11365.2\n";
  print LOG "CTX: Evaluate second RSP K22 response to query 11365.\n";
  print LOG "CTX: Evaluate baseline response.\n";
  $diff += mesa::evaluate_PDQ_RSP_K22_Continuation (
        $logLevel,
        "11365/mesa/1001.hl7",
        "11365/test/1001.hl7");
  print LOG "\n";
}


sub x_11365_3 {
  print LOG "CTX: PD Supplier 11365.3\n";
  print LOG "CTX: Check for correct number of responses\n";

  if (! -e "11365/mesa/1003.hl7") {
    print LOG "ERR: There should be 4 results in MESA directory: 11365/mesa\n";
    print LOG "ERR: zip/tar all files in 11365/mesa and log a bug report\n";
    $diff += 1;
  }
  if (-e "11365/mesa/1005.hl7") {
    print LOG "ERR: There should be 4 results in MESA directory: 11365/mesa\n";
    print LOG "ERR: zip/tar all files in 11365/mesa and log a bug report\n";
    $diff += 1;
  }
  print LOG "CTX: Found 4 results in MESA directory: 11365/mesa\n" if ($logLevel >= 3);

  if (! -e "11365/test/1003.hl7") {
    print LOG "ERR: There should be at least 4 results in TEST directory: 11365/test\n";
    print LOG "ERR: This should include 1000.hl7, 1001, 1002, 1003\n";
    $diff += 1;
  }
  print LOG "CTX: Found 4 results in TEST directory: 11365/mesa\n" if ($logLevel >= 3);

  print LOG "\n";
}

sub x_11365_4 {
  print LOG "CTX: PD Supplier 11365.4\n";
  print LOG "CTX: Check for patient names in responses\n";

  my %hText;
  print LOG "CTX: Look for and print 4 expected responses\n";
  for ($x = 0; $x <= 3; $x += 1) {
    $fileName = "11365/test/100$x.hl7";
    if (-e $fileName) {
      $y =  mesa::getFieldRepeatedSegment($logLevel, $fileName, "PID", 1, "5", "0", "Name");
      print LOG "CTX: $fileName: $y\n";
      $hTest{$y} = $fileName;
    }
  }

  print LOG "\n";
  print LOG "CTX: Check for patient names in MESA responses\n";
  print LOG "CTX: With each MESA response, look for corresponding name in TEST response\n";
  my %hMESA;
  for ($x = 0; $x <= 3; $x += 1) {
    $fileName = "11365/mesa/100$x.hl7";
    if (-e $fileName) {
      $y =  mesa::getFieldRepeatedSegment($logLevel, $fileName, "PID", 1, "5", "0", "Name");
      print LOG "CTX: $fileName: $y\n";
      $hMESA{$y} = $fileName;
      my $z = $hTest{$y};
      if (! $z) {
	print LOG "ERR: MESA expects a response with name $y\n";
	print LOG "ERR: Did not find an entry for $y in the TEST response\n";
	$diff += 1;
      } else {
	print LOG "CTX: Found an entry for $y in the test response; this is expected\n";
      }
    }
  }

  print LOG "\n";
}


### Main starts here

# Compare input RSP K22 messages with expected values.
die "Usage: perl 11365/eval_11365.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

open LOG, ">11365/grade_11365.txt" or die "Cout not open output file 11365/grade_11365.txt";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    11365\n";
print LOG "CTX: Actor:   PDS\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

x_11365_1;
x_11365_2;
x_11365_3;
x_11365_4;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("11365/grade_11365.txt", "11365/mir_mesa_11365.xml",
        $logLevel, "11365", "PDS", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "\nThis test completed with zero errors; that means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 11365/grade_11365.txt and 11365/mir_mesa_11365.xml\n";
}

print "If you are submitting a result file to Kudu, submit 11365/mir_mesa_11365.xml\n\n";

