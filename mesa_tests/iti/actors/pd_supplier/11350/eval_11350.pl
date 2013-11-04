#!/usr/local/bin/perl -w

# This script evaluates RSP^K22 messages sent by a
# PD Supplier for test 11350.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require pd_supplier;
require mesa_common;
require mesa_evaluate;

sub dummy {}

sub x_11350_1 {
  print LOG "\nCTX: PD Supplier 11350.1\n";
  print LOG "CTX: Evaluate RSP K22 response to query 11350.\n";
  print LOG "CTX: Evaluate baseline response.\n";
  my $x = mesa::evaluate_PDQ_RSP_K22_baseline(
        $logLevel,
        "11350/mesa/1000.hl7",
        "11350/test/1000.hl7");

  print LOG "\n";
  return $x;
}


sub x_11350_2 {
  print LOG "\nCTX: PD Supplier 11350.2\n";
  print LOG "CTX: Check for correct number of responses\n";

  my $rtnValue = 0;
  if (! -e "11350/mesa/1000.hl7") {
    print LOG "ERR: There should be 1 result in MESA directory: 11350/mesa\n";
    print LOG "ERR: zip/tar all files in 11350/mesa and log a bug report\n";
    $rtnValue += 1;
  }
  if (-e "11350/mesa/1001.hl7") {
    print LOG "ERR: There should be 1 result in MESA directory: 11350/mesa\n";
    print LOG "ERR: zip/tar all files in 11350/mesa and log a bug report\n";
    $rtnValue += 1;
  }

  if (! -e "11350/test/1000.hl7") {
    print LOG "ERR: There should be 1 result in TEST directory: 11350/test\n";
    print LOG "ERR: This should include 1000.hl7\n";
    $rtnValue += 1;
  }

  if (-e "11350/test/1001.hl7") {
    print LOG "ERR: There should be only 1 result in TEST directory: 11350/test\n";
    print LOG "ERR: This should include 1000.hl7\n";
    print LOG "ERR: We found a result 1001, check if this is an empty response\n";
    $rtnValue += 1;
  }

  print LOG "\n";
  return $rtnValue;
}

sub x_11350_3 {
  print LOG "\nCTX: PD Supplier 11350.3\n";
  print LOG "CTX: Check for patient names in responses\n";
  my $rtnValue = 0;

  my %hText;
  print LOG "CTX: Look for and print 1 expected responses\n";
  my $testCount = 0;
  my $fieldVal = "X";
  for ($x = 1; $x <= 10 && $fieldVal ne ""; $x += 1) {
    $fileName = "11350/test/1000.hl7";
    if (-e $fileName) {
      $fieldVal =  mesa::getFieldRepeatedSegment($logLevel, $fileName, "PID", $x, "5", "0", "Name");
      print LOG "CTX: $fileName: $x <$fieldVal>\n";
      if ($fieldVal ne "") {
	$hTest{$fieldVal} = $x;
	$testCount++;
      }
    }
  }

  if ($testCount != 1) {
    print LOG "ERR: Found $testCount demographic responses; expected exactly 1\n";
    return 1;
  }

  print LOG "\n";
  print LOG "CTX: Check for patient names in MESA responses\n";
  print LOG "CTX: With each MESA response, look for corresponding name in TEST response\n";
  my %hMESA;
  for ($x = 1; $x <= 1; $x += 1) {
    $fileName = "11350/mesa/1000.hl7";
    if (-e $fileName) {
      $y =  mesa::getFieldRepeatedSegment($logLevel, $fileName, "PID", $x, "5", "0", "Name");
      print LOG "CTX: $fileName: $y\n";
      $hMESA{$y} = $x;
      my $z = $hTest{$y};
      if (! $z) {
	print LOG "ERR: MESA expects a response with name $y\n";
	print LOG "ERR: Did not find an entry for $y in the TEST response\n";
	$rtnValue += 1;
      } else {
	print LOG "CTX: Found an entry for $y in the test response; this is expected\n";
      }
    }
  }

  print LOG "\n";
  return $rtnValue;
}


### Main starts here

# Compare input RSP K22 messages with expected values.
die "Usage: perl 11350/eval_11350.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

open LOG, ">11350/grade_11350.txt" or die "Cout not open output file 11350/grade_11350.txt";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    11350\n";
print LOG "CTX: Actor:   PDS\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

$diff += x_11350_1;
$diff += x_11350_2;
$diff += x_11350_3;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("11350/grade_11350.txt", "11350/mir_mesa_11350.xml",
        $logLevel, "11350", "PDS", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "\nThis test completed with zero errors; that means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 11350/grade_11350.txt and 11350/mir_mesa_11350.xml\n";
}

print "If you are submitting a result file to Kudu, submit 11350/mir_mesa_11350.xml\n\n";

