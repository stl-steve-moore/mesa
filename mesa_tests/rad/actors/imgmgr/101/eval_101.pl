#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require imgmgr;

sub goodbye() {
  exit 1;
}

# Examine the MPPS messages forwarded by the Image Manager

sub x_101_1 {
  print LOG "Image Manager 101.1 \n";
  print LOG "MPPS messages produced for P1/X1 \n";
  $diff += mesa::evaluate_mpps_v2($verbose,
		"$MESA_STORAGE/modality/P1",
		"$MESA_STORAGE/ordfil/mpps/$titleMPPSMgr",
		"1"
		);
  print LOG "\n";
}


sub x_101_5 {
  print LOG "Image Manager 101.5 \n";
  print LOG "MPPS messages produced for P2/X2 \n";
  $diff += mesa::evaluate_mpps_v2($verbose,
		"$MESA_STORAGE/modality/P2",
		"$MESA_STORAGE/ordfil/mpps/$titleMPPSMgr",
		"2"
		);
  print LOG "\n";
}

sub x_101_2 {
  print LOG "Image Manager 101.2 \n";
  print LOG "C-Find response, Image Availability P1/X1 before images transmitted \n";
  $diff += mesa::evaluate_cfind_resp($verbose,
		"0008", "0018", "101/cfind_ia_mask.txt",
		"101/ia_x1_pre",
		"101/ia_x1_pre_mesa",
		);
  print LOG "\n";
}

sub x_101_3 {
  print LOG "Image Manager 101.3 \n";
  print LOG "C-Find response, Image Availability P1/X1 after images transmitted \n";
  $diff += mesa::evaluate_cfind_resp($verbose,
		"0008", "0018", "101/cfind_ia_mask.txt",
		"101/ia_x1_post",
		"101/ia_x1_post_mesa",
		);
  print LOG "\n";
}

sub x_101_6 {
  print LOG "Image Manager 101.6 \n";
  print LOG "C-Find response, Image Availability P2/X2 after images transmitted \n";
  $diff += mesa::evaluate_cfind_resp($verbose,
		"0008", "0018", "101/cfind_ia_mask.txt",
		"101/ia_x2_post",
		"101/ia_x2_post_mesa",
		);
  print LOG "\n";
}

sub x_101_7 {
  print LOG "Image Manager 101.7 \n";
  print LOG "C-Find response, Study Level query for DOE\n";
  $diff += mesa::evaluate_cfind_resp($verbose,
		"0020", "000D", "101/cfind_study_mask.txt",
		"101/cfind_doe",
		"101/cfind_doe_mesa",
		);
  print LOG "\n";
}

sub x_101_8 {
  print LOG "Image Manager 101.8 \n";
  print LOG "C-Find response, Study Level query for WHITE after HL7 merge\n";
  $diff += mesa::evaluate_cfind_resp($verbose,
		"0020", "000D", "101/cfind_study_mask.txt",
		"101/cfind_white",
		"101/cfind_white_mesa",
		);
  print LOG "\n";
}

# These are the tests for Storage Commitment

sub x_101_4 {
  print LOG "Image Manager 101.4 \n";

  mesa::create_hash_test_messages(1, "$titleSC");
  mesa::read_mesa_messages();
  $diff += mesa::grade_messages($verbose);
}

die "Image Manager test 101 is retired as of May, 2003.\n";

if (scalar(@ARGV) < 2) {
  print "This script requires two arguments: \n" .
	"    <AE Title of your MPPS Mgr> \n" .
	"    <AE Title of your Storage Commitment SCP\n";
  exit 1;
}

$titleMPPSMgr = $ARGV[0];
$titleSC = $ARGV[1];
$verbose = grep /^-v/, @ARGV;
open LOG, ">101/grade_101.txt" or die "?!";
$diff = 0;

x_101_1;
x_101_2;
x_101_3;
x_101_4;
x_101_5;
x_101_6;
x_101_7;
x_101_8;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 101/grade_101.txt \n";

exit $diff;
