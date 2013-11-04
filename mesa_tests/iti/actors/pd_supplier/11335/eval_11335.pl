#!/usr/local/bin/perl -w

# This script evaluates RSP^K22 messages sent by a
# PD Supplier for test 11335.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require pd_supplier;
require mesa_common;
require mesa_evaluate;

sub dummy {}


sub x_11335_2 {
  print LOG "CTX: PD Supplier 11335.2\n";
  print LOG "CTX: Check for correct number of responses\n";

  if (! -e "11335/mesa/1000.hl7") {
    print LOG "ERR: There should be 1 result in MESA directory: 11335/mesa\n";
    print LOG "ERR: zip/tar all files in 11335/mesa and log a bug report\n";
    $diff += 1;
  }
  if (-e "11335/mesa/1001.hl7") {
    print LOG "ERR: There should be 1 result in MESA directory: 11335/mesa\n";
    print LOG "ERR: zip/tar all files in 11335/mesa and log a bug report\n";
    $diff += 1;
  }

  if (! -e "11335/test/1000.hl7") {
    print LOG "ERR: There should be 1 result in TEST directory: 11335/test\n";
    print LOG "ERR: This should include 1000.hl7\n";
    $diff += 1;
  }

  if (-e "11335/test/1001.hl7") {
    print LOG "ERR: There should be only 1 result in TEST directory: 11335/test\n";
    print LOG "ERR: This should include 1000.hl7\n";
    print LOG "ERR: We found a result 1001, check if this is an empty response\n";
    $diff += 1;
  }

  print LOG "\n";
}

sub x_11335_3 {
  print LOG "CTX: PD Supplier 11335.3\n";
  print LOG "CTX: Check for patient names in responses\n";

  my %hText;
  print LOG "CTX: Look for and print 5 expected responses\n";
  for ($x = 1; $x <= 5; $x += 1) {
    $fileName = "11335/test/1000.hl7";
    if (-e $fileName) {
      $y =  mesa::getFieldRepeatedSegment($logLevel, $fileName, "PID", $x, "5", "0", "Name");
      print LOG "CTX: $fileName: $y\n";
      $hTest{$y} = $x;
    }
  }

  print LOG "\n";
  print LOG "CTX: Check for patient names in MESA responses\n";
  print LOG "CTX: With each MESA response, look for corresponding name in TEST response\n";
  my %hMESA;
  for ($x = 1; $x <= 5; $x += 1) {
    $fileName = "11335/mesa/1000.hl7";
    if (-e $fileName) {
      $y =  mesa::getFieldRepeatedSegment($logLevel, $fileName, "PID", $x, "5", "0", "Name");
      print LOG "CTX: $fileName: $y\n";
      $hMESA{$y} = $x;
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

open LOG, ">11335/grade_11335.txt" or die "Cout not open output file 11335/grade_11335.txt";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    11335\n";
print LOG "CTX: Actor:   PDS\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$logLevel = $ARGV[0];
$diff = 0;

x_11335_2;
x_11335_3;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("11335/grade_11335.txt", "11335/mir_mesa_11335.xml",
        $logLevel, "11335", "PDS", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "\nThis test completed with zero errors; that means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 11335/grade_11335.txt and 11335/mir_mesa_11335.xml\n";
}

print "If you are submitting a result file to Kudu, submit 11335/mir_mesa_11335.xml\n\n";


