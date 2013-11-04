#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require imgmgr;

sub goodbye() {
  exit 1;
}

# Examine the MPPS messages forwarded by the Image Manager

sub x_104_1 {
  print LOG "Image Manager 104.1 \n";
  print LOG "MPPS messages produced for P4/X4A \n";
  $diff += mesa::evaluate_mpps_v2($verbose,
		"$MESA_STORAGE/modality/T104a",
		"$MESA_STORAGE/ordfil/mpps/$titleMPPSMgr",
		"1"
		);
  print LOG "MPPS messages produced for P4/X4B \n";
  $diff += mesa::evaluate_mpps_v2($verbose,
		"$MESA_STORAGE/modality/T104b",
		"$MESA_STORAGE/ordfil/mpps/$titleMPPSMgr",
		"1"
		);
  print LOG "\n";
}

sub x_104_2 {
  print LOG "Image Manager 104.2 \n";
  print LOG "MPPS messages produced for P1/X1 \n";
  $diff += mesa::evaluate_mpps_v2($verbose,
		"$MESA_STORAGE/modality/T104c",
		"$MESA_STORAGE/ordfil/mpps/$titleMPPSMgr",
		"1"
		);
  print LOG "\n";
}

sub x_104_3 {
  print LOG "Image Manager 104.3 \n";
  print LOG "C-Find response, Study Level query for BLUE\n";
  print LOG " (This is before the patient merge; we expect one study) \n";
  $diff += mesa::evaluate_cfind_resp($verbose,
		"0020", "000D", "104/cfind_study_mask.txt",
		"104/cfind_blue_pre",
		"104/cfind_blue_pre_mesa"
		);
  print LOG "\n";
}

sub x_104_4 {
  print LOG "Image Manager 104.4 \n";
  print LOG "C-Find response, Study Level query for DOE\n";
  print LOG " We expect to find one response \n";
  $diff += mesa::evaluate_cfind_resp($verbose,
		"0020", "000D", "104/cfind_study_mask.txt",
		"104/cfind_doe",
		"104/cfind_doe_mesa"
		);
  print LOG "\n";
}

sub x_104_5 {
  print LOG "Image Manager 104.5 \n";
  print LOG "C-Find response, Study Level query for BLUE after merge operation\n";
  print LOG " We expect to find two studies \n";
  $diff += mesa::evaluate_cfind_resp($verbose,
		"0020", "000D", "104/cfind_study_mask.txt",
		"104/cfind_blue_post",
		"104/cfind_blue_post_mesa"
		);
  print LOG "\n";
}

die "Image Manager test 104 is retired as of May, 2003.\n";

if (scalar(@ARGV) < 1) {
  print "This script requires one argument: \n" .
	"    <AE Title of your MPPS Mgr> \n" ;
  exit 1;
}

$titleMPPSMgr = $ARGV[0];
die "Need <AE Title Storage MPPS Manager>" if ($titleMPPSMgr eq "");
$verbose = grep /^-v/, @ARGV;
open LOG, ">104/grade_104.txt" or die "?!";
$diff = 0;

x_104_1;
x_104_2;
x_104_3;
x_104_4;
x_104_5;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 104/grade_104.txt \n";

exit $diff;
