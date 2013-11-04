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

sub dummy {}

# Examine the MPPS messages forwarded by the Image Manager

sub x_109_1 {
  print LOG "Image Manager 109.1 \n";
  print LOG "Count responses to C-Find query \n";

  my $count = mesa::count_files_in_directory("109/cfind_grey/test");
  if ($count != 0) {
    print LOG "Found $count responses to our C-Find query.\n" .
	" Because this procedure step was discontinued with a reason \n" .
	" of Incorrect Worklist Entry Selected, your Image Manager \n" .
	" should return 0 responses. \n" .
	" This is a failure.\n";
    return 1;
  }
}

if (scalar(@ARGV) < 2) {
  print "This script requires two arguments: \n" .
	"    <AE Title of your MPPS Mgr> \n" .
	"    <AE Title of your Storage Commitment SCP\n";
  exit 1;
}

#$titleMPPSMgr = $ARGV[0];
#$titleSC = $ARGV[1];
#$verbose = grep /^-v/, @ARGV;

$logLevel = 4;

open LOG, ">109/grade_109.txt" or die "?!";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    109\n";
print LOG "CTX: Actor:   IM\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

$diff += x_109_1;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("109/grade_109.txt", "109/mir_mesa_109.xml",
        $logLevel, "109", "IM", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "Test completed with zero errors means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 109/grade_109.txt and 109/mir_mesa_109.xml\n";
}

print "If you are submitting a result file to Kudu, submit 109/mir_mesa_109.xml\n\n";

