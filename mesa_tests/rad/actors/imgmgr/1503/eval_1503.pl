#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
use lib "../common/scripts";
require imgmgr;
require mesa;

sub goodbye() {
  exit 1;
}

# Examine the MPPS messages forwarded by the Image Manager

sub x_1503_1 {
  print LOG "Image Manager 1503.1 \n";
  print LOG "MPPS messages produced for P1/X1 \n";
  $diff += mesa::evaluate_mpps_v2($verbose,
		"$MESA_STORAGE/modality/T1503",
		"$MESA_STORAGE/ordfil/mpps/$titleMPPSMgr",
		"1"
		);
  print LOG "\n";
}

sub x_1503_2 {
  print LOG "Image Manager 1503.2 \n";
  print LOG "Storage Commitment evaluation. \n";

  mesa::create_hash_test_messages(1, "$titleSC");
  mesa::read_mesa_messages();
  $diff += mesa::grade_messages($verbose);
  print LOG "\n";
}

sub x_1503_3 {
  print LOG "Image Manager 1503.3 \n";
  print LOG "C-Find response, Study Level query for DOE\n";
  $diff += mesa::evaluate_cfind_resp($verbose,
		"0020", "000D", "103/cfind_study_mask.txt",
		"1503/cfind_doe",
		"1503/cfind_doe_mesa"
		);
  print LOG "\n";
}

sub x_1503_4 {
  print LOG "Image Manager 1503.4 \n";
  print LOG "C-Find response, Study Level query for SILVERHEELS after HL7 A08 update\n";
  $diff += mesa::evaluate_cfind_resp($verbose,
		"0020", "000D", "103/cfind_study_mask.txt",
		"1503/cfind_silverheels",
		"1503/cfind_silverheels_mesa",
		);
  print LOG "\n";
}

sub x_1503_5 {
  print LOG "Image Manager 1503.5 \n";
  print LOG "Audit Record Messages \n";
  mesa::clear_syslog_files();
  mesa::extract_syslog_messages();
  my $xmlCount = mesa::count_syslog_xml_files();
  if ($xmlCount < 2) {
    print LOG "We expect at least 2 audit messages from your Image Manager.\n";
    print LOG " We received $xmlCount messages \n";
    print LOG " That is a failure; we will evaluate the messages received.\n";
    $diff += 1;
  }
  $diff += mesa::evaluate_all_xml_files();
}

if (scalar(@ARGV) < 2) {
  print "This script requires two arguments: \n" .
	"    <AE Title of your MPPS Mgr> \n" .
	"    <AE Title of your Storage Commitment SCP\n";
  exit 1;
}

$titleMPPSMgr = $ARGV[0];
$titleSC = $ARGV[1];
$verbose = grep /^-v/, @ARGV;
open LOG, ">1503/grade_1503.txt" or die "?!";
$diff = 0;

x_1503_1;
x_1503_2;
x_1503_3;
x_1503_4;
x_1503_5;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1503/grade_1503.txt \n";

exit $diff;
