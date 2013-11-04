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

sub x_133_1 {
  print LOG "CTX: Image Manager 133.1 \n";
  print LOG "C-Find response, Study Level query for known patient pre-merge\n";
  print LOG " (This is before the patient merge; we expect zero studies) \n";
  $preMergeCount = mesa::count_files_in_directory("133/cfind_pre_merge/test");
  if ($preMergeCount != 0 && $logLevel >= 2) {
    print LOG "WARN: Found $preMergeCount study-level responses before A40 merge event.\n";
    print LOG "WARN: We had expected to find 0 responses.\n";
  }
  print LOG "\n";
}

sub x_133_2 {
  print LOG "CTX: Image Manager 133.2 \n";
  print LOG "C-Find response, Study Level query for known patient post-merge\n";
  print LOG " (This is after the patient merge; we expect one study) \n";
  $postMergeCount = mesa::count_files_in_directory("133/cfind_post_merge/test");
  if ($postMergeCount != 1 && $logLevel >= 2) {
    print LOG "WARN: Found $postMergeCount study-level responses after A40 merge event.\n";
    print LOG "WARN: We had expected to find 1 response.\n";
  }

  if ($postMergeCount != ($preMergeCount + 1)) {
    print LOG "ERR: Found $preMergeCount study-level responses before A40 merge event.\n";
    print LOG "ERR: Found $postMergeCount study-level responses after A40 merge event.\n";
    print LOG "ERR: There should be 1 more response after the merge.\n";
    print LOG "ERR: This is an error.\n";
    $diff += 1;
  }
  print LOG "\n";
}

# Main starts here
die "Usage <log level: 1-4> <AE Title MPPS Mgr> <AE Title Storage Commit SCP>" if (scalar(@ARGV) < 2);

$logLevel     = $ARGV[0];
#$titleMPPSMgr = $ARGV[1];
#$titleSC      = $ARGV[2];
open LOG, ">133/grade_133.txt" or die "?!";

my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    133\n";
print LOG "CTX: Actor:   IM\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

x_133_1;
x_133_2;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("133/grade_133.txt", "133/mir_mesa_133.xml",
        $logLevel, "133", "IM", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "Test completed with zero errors means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 133/grade_133.txt and 133/mir_mesa_133.xml\n";
}

print "If you are submitting a result file to Kudu, submit 133/mir_mesa_133.xml\n\n";
