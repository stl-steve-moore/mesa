#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require imgmgr;

use lib "../../../common/scripts";
require mesa_common;
require mesa_evaluate;

sub goodbye() {
  exit 1;
}

sub dummy {
}

sub x_50411_1 {
  my $count = 0;

  my $mesaValue = mesa_get::getDICOMValue(0, "50411/mesa/msg1_result.dcm", "", "0042 0010", 0);
  my $testValue = mesa_get::getDICOMValue(0, "50411/test/msg1_result.dcm", "", "0042 0010", 0);
  print LOG "CTX: 0042 0010 MESA <$mesaValue> TEST <$testValue>\n";
  if ($mesaValue ne $testValue) {
    print LOG "ERR: Test value for 0042 0010 Document Title does not equal the value returned/expected by MESA tools\n";
    print LOG "ERR: This is a query return key at the SOP Instance Level\n";
    $count = 1;
  }
  return $count;
}

die "Usage <log level: 1-4>" if (scalar(@ARGV) < 1);

$logLevel     = $ARGV[0];

open LOG, ">50411/grade_50411.txt" or die "Could not open output grade file: 50411/grade_50411.txt";
$diff = 0;

my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    50411\n";
print LOG "CTX: Actor:   IM\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = x_50411_1;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

print LOG "Total errors: $diff\n";

close LOG;

open LOG, ">50411/mir_mesa_50411.xml" or die "Could not open XML output file: 50411/mir_mesa_50411.xml";

mesa_evaluate::eval_XML_start($logLevel, "50411", "IM", $version, $date);
mesa_evaluate::outputCount($logLevel, $diff);
mesa_evaluate::outputPassFail($logLevel, $diff);

if ($logLevel != 4) {
  mesa_evaluate::outputComment($logLevel,
        "Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.");
}
mesa_evaluate::startDetails($logLevel);

open TMP, "<50411/grade_50411.txt" or die "Could not open 50411/grade_50411.txt for input";
while ($l = <TMP>) {
 print LOG $l;
}
close TMP;

mesa_evaluate::endDetails($logLevel);
mesa_evaluate::endXML($logLevel);
close LOG;

print "\nLogs stored in 50411/grade_50411.txt \n";
print "Submit 50411/mir_mesa_50411.xml for grading\n";


exit $diff;
