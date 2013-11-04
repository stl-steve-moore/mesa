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

# Examine the MPPS messages forwarded by the Image Manager

sub x_105_1 {
  print LOG "CTX: Image Manager 105.1 \n";
  print LOG "CTX: Evaluating MPPS messages produced and forwarded for P2/X2 \n";
  $diff += mesa::evaluate_mpps_mpps_mgr(
		$logLevel,
		"$MESA_STORAGE/modality/T105",
		"$MESA_STORAGE/ordfil/mpps/$titleMPPSMgr",
		"1"
		);
  print LOG "\n";
}

sub x_105_2 {
  print LOG "CTX: Image Manager 105.2 \n";
  print LOG "CTX: C-Find response, Study Level query for known patient (before rename)\n";
  print LOG "CTX:  (This is before the patient update; we expect zero studies) \n";
  $preRenameCount = mesa::count_files_in_directory("105/cfind_pre_rename/test");
  print LOG "CTX: Found $preRenameCount studies before the rename operation.\n" if ($logLevel >= 3);
  if ($preRenameCount != 0 && $logLevel >= 2) {
    print LOG "WARN: Found $preRenameCount study-level responses before A08 rename event.\n";
    print LOG "WARN: We had expected to find 0 responses.\n";
  }
  print LOG "\n";
}

sub x_105_3 {
  print LOG "CTX: Image Manager 105.3 \n";
  print LOG "CTX: C-Find response, Study Level query for known patient post-rename\n";
  print LOG " (This is after the patient rename; we expect one study) \n";
  $postRenameCount = mesa::count_files_in_directory("105/cfind_post_rename/test");
  print LOG "CTX: Found $postRenameCount studies after the rename operation.\n" if ($logLevel >= 3);
  if ($postRenameCount != 1 && $logLevel >= 2) {
    print LOG "WARN: Found $postRenameCount study-level responses after A08 rename event.\n";
    print LOG "WARN: We had expected to find 1 response.\n";
  }

  if ($postRenameCount != ($preRenameCount + 1)) {
    print LOG "ERR: Found $preRenameCount study-level responses before A08 rename event.\n";
    print LOG "ERR: Found $postRenameCount study-level responses after A08 rename event.\n";
    print LOG "ERR: There should be 1 more response after the rename.\n";
    print LOG "ERR: This is an error.\n";
    $diff += 1;
  }
  print LOG "\n";
}

die "Usage <log level: 1-4> <AE Title MPPS Mgr> <AE Title Storage Commit SCP>" if (scalar(@ARGV) < 2);

$logLevel     = $ARGV[0];
$titleMPPSMgr = $ARGV[1];
#$titleSC      = $ARGV[2];
open LOG, ">105/grade_105.txt" or die "Could not open output grade file: 105/grade_105.txt";
$diff = 0;

my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    105\n";
print LOG "CTX: Actor:   IM\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

x_105_1;
x_105_2;
x_105_3;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("105/grade_105.txt", "105/mir_mesa_105.xml",
        $logLevel, "105", "IM", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "Test completed with zero errors means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 105/grade_105.txt and 105/mir_mesa_105.xml\n";
}

print "If you are submitting a result file to Kudu, submit 105/mir_mesa_105.xml\n\n";

