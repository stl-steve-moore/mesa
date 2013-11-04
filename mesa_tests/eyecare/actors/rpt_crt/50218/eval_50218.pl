#!/usr/local/bin/perl -w

# This script ECDR documents produced for test 50218.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require mesa_common;
require mesa_evaluate;


sub x_50218_1 {
  my ($logLevel, $ref, $tst) = @_;

  print LOG "\nCTX: Report Creator 50218.1\n";
  my $rtnValue = 0;

  @entries = (
	"", 0, "0008 0016", "EQUAL", "SOP Instance UID",
	"", 0, "0040 A493", "EQUAL", "Verification Flag",
	"", 0, "0040 A491", "EQUAL", "Completion Flag",
	"0040 A073", 0, "0040 A075", "EQUAL", "Verifying Observer Name",
  );
  $rtnValue = mesa_evaluate::processValueList($logLevel, $ref, $tst, @entries);

  @existenceList = (
	"", 0, "0008 0023", "EXIST", "Content Date",
	"", 0, "0008 0033", "EXIST", "Content Time",
  );

  $rtnValue += mesa_evaluate::processExistenceList($logLevel, $ref, $tst, @existenceList);

  print LOG "\n";
  return $rtnValue;
}

### Main starts here
die "Usage: perl 50218/eval_50218.pl <log level (1-4)> FILE\n" if (scalar(@ARGV) < 2);
$logLevel = $ARGV[0];
$testFile = $ARGV[1];

my $mesaVersion = mesa_get::getMESAVersion();
my $version = mesa_get::getMESANumericVersion();
my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);

open LOG, ">50218/grade_50218.txt" or die "Cout not open output file 50218/grade_50218.txt";

print LOG "CTX: Test:    50218\n";
print LOG "CTX: Actor:   RC\n";
print LOG "CTX: Version: $version\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

$diff += x_50218_1($logLevel, "50218/ref_50218-10.dcm", $testFile);

if ($diff == 0) {
  print LOG "CTX: 0 errors implies this test has been passed.\n";
  print "\nCTX: 0 errors implies this test has been passed.\n";
} else {
  print LOG "ERR: $diff errors implies test FAILURE.\n";
  print "\nERR: $diff errors implies test FAILURE.\n";
}

close LOG;

open LOG, ">50218/mir_mesa_50218.xml" or die "Could not open XML output file: 50218/mir_mesa_50218.xml";

mesa_evaluate::eval_XML_start($logLevel, "50218", "RC", $version, $date);
mesa_evaluate::outputCount($logLevel, $diff);
mesa_evaluate::outputPassFail($logLevel, $diff);

if ($logLevel != 4) {
  $diff += 1;
  mesa_evaluate::outputComment($logLevel,
        "Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.");
}

mesa_evaluate::startDetails($logLevel);

open TMP, "<50218/grade_50218.txt" or die "Could not open 50218/grade_50218.txt for input";
while ($l = <TMP>) {
 print LOG $l;
}
close TMP;

mesa_evaluate::endDetails($logLevel);
mesa_evaluate::endXML($logLevel);
close LOG;

print "\nLogs stored in 50218/grade_50218.txt \n";
print "Submit 50218/mir_mesa_50218.xml for grading\n";
exit $diff;

