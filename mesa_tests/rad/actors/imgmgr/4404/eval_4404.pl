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

sub x_4404_2 {
  print LOG "CTX: Image Manager 4404.2 \n";
  print LOG "CTX: C-Find response, Study Level query for known study\n";
  $count = mesa::count_files_in_directory("4404/cfind/test");
  print LOG "CTX: Found $count study-level responses.\n" if ($logLevel >= 3);
  if ($count != 1) {
    print LOG "ERR: Found $count study-level responses .\n";
    print LOG "ERR: We had expected to find 1 response.\n";
    $diff += 1;
  }
  print LOG "\n";
}

die "Usage <log level: 1-4> " if (scalar(@ARGV) < 1);

$logLevel     = $ARGV[0];
open LOG, ">4404/grade_4404.txt" or die "Could not open output grade file: 4404/grade_4404.txt";
$diff = 0;

my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    4404\n";
print LOG "CTX: Actor:   IM\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

x_4404_2;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("4404/grade_4404.txt", "4404/mir_mesa_4404.xml",
        $logLevel, "4404", "IM", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "Test completed with zero errors means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 4404/grade_4404.txt and 4404/mir_mesa_4404.xml\n";
}

print "If you are submitting a result file to Kudu, submit 4404/mir_mesa_4404.xml\n\n";

