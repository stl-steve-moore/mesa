#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
use lib "../../../common/scripts";
require imgmgr;
require mesa_common;

sub goodbye() {
  exit 1;
}

sub x_50002_1 {
  print LOG "\nCTX: Image Manager 50002.1 \n";
  print LOG "CTX: C-Find response, Study Level query for patient (before rename)\n";
  print LOG "CTX:  (This is before the patient update; we expect zero studies) \n";
  my $rtnValue = 0;
  $preRenameCount = mesa::count_files_in_directory("50002/cfind_pre_rename/test");
  print LOG "CTX: Found $preRenameCount studies before the rename operation.\n" if ($logLevel >= 3);
  if ($preRenameCount != 0 && $logLevel >= 2) {
    print LOG "WARN: Found $preRenameCount study-level responses before A08 rename event.\n";
    print LOG "WARN: We had expected to find 0 responses.\n";
  }
  print LOG "\n";
  return $rtnValue;
}

sub x_50002_2 {
  print LOG "\nCTX: Image Manager 50002.3 \n";
  print LOG "CTX: C-Find response, Study Level query for known patient post-rename\n";
  print LOG " (This is after the patient rename; we expect one study) \n";
  $postRenameCount = mesa::count_files_in_directory("50002/cfind_post_rename/test");
  print LOG "CTX: Found $postRenameCount studies after the rename operation.\n" if ($logLevel >= 3);
  if ($postRenameCount != 1 && $logLevel >= 2) {
    print LOG "WARN: Found $postRenameCount study-level responses after A08 rename event.\n";
    print LOG "WARN: We had expected to find 1 response.\n";
  }

  my $rtnValue = 0;
  if ($postRenameCount != ($preRenameCount + 1)) {
    print LOG "ERR: Found $preRenameCount study-level responses before A08 rename event.\n";
    print LOG "ERR: Found $postRenameCount study-level responses after A08 rename event.\n";
    print LOG "ERR: There should be 1 more response after the rename.\n";
    print LOG "ERR: This is an error.\n";
    $rtnValue = 1;
  }
  print LOG "\n";
  return $rtnValue;
}

die "Usage <log level: 1-4> <AE Title MPPS Mgr> <AE Title Storage Commit SCP>" if (scalar(@ARGV) < 2);

$logLevel     = $ARGV[0];
#$titleMPPSMgr = $ARGV[1];
#$titleSC      = $ARGV[2];
open LOG, ">50002/grade_50002.txt" or die "Could not open output grade file: 50002/grade_50002.txt";
my $mesaVersion = mesa_get::getMESAVersion();
my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
print LOG "CTX: $mesaVersion \n";
print LOG "CTX: current date/time $date $timeToMinute\n";
print LOG "CTX: Log Level $logLevel\n";

$diff = 0;

$diff += x_50002_1;
$diff += x_50002_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 50002/grade_50002.txt \n";

exit $diff;
