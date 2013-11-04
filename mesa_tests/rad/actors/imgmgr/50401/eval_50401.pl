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

sub x_50401_1 {
  my $count = 0;

  my $mesaValue = mesa_get::getDICOMValue(0, "50401/mesa/msg1_result.dcm", "", "0008 0061", 0);
  my $testValue = mesa_get::getDICOMValue(0, "50401/test/msg1_result.dcm", "", "0008 0061", 0);
  print LOG "CTX: 0008 0061 MESA <$mesaValue> TEST <$testValue>\n";
  if ($mesaValue eq $testValue) {
    return 0;
  }

  my @mesaModalityValues = split /\\/, $mesaValue;
  my $mesaCount = scalar(@mesaModalityValues);
  my @testModalityValues = split /\\/, $testValue;
  my $testCount = scalar(@mesaModalityValues);
  if ($mesaCount != $testCount) {
    print LOG "ERR: Modalities in Study 0008 0061, different number of entries\n";
    print LOG " ERR: MESA returns $mesaCount values, test system returns $testCount\n";
    print LOG " ERR: MESA string:             $mesaValue\n";
    print LOG " ERR: String from test system: $testValue\n";
    return 1;
  }

  foreach $m(@mesaModalityValues) {
    $found = 0;
    foreach $t(@testModalityValues) {
      print LOG "CTX: MESA: $m TEST: $t\n";
      if ($m eq $t) {
	$found = 1;
      }
    }
    if ($found == 0) {
      $count++;
      print LOG "ERR: Found no matching modality for $m in string $testValue\n";
    }
  }

  return $count;
}

die "Usage <log level: 1-4>" if (scalar(@ARGV) < 1);

$logLevel     = $ARGV[0];

open LOG, ">50401/grade_50401.txt" or die "Could not open output grade file: 50401/grade_50401.txt";
$diff = 0;

my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    50401\n";
print LOG "CTX: Actor:   IM\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = x_50401_1;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

print LOG "Total errors: $diff\n";

close LOG;

mesa_evaluate::copyLogWithXML("50401/grade_50401.txt", "50401/mir_mesa_50401.xml",
        $logLevel, "50401", "IM", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "Test completed with zero errors means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 50401/grade_50401.txt and 50401/mir_mesa_50401.xml\n";
}

print "If you are submitting a result file to Kudu, submit 50401/mir_mesa_50401.xml\n\n";

