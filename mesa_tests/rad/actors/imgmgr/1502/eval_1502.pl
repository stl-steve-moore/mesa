#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require imgmgr;

sub goodbye() {
  exit 1;
}


# Examine the MPPS messages forwarded by the Image Manager

sub x_102_1 {
  print LOG "Image Manager 102.1 \n";
  print LOG "MPPS messages produced for P1/X11 \n";
  $diff += imgmgr::evaluate_mpps_v2($verbose,
		"$MESA_STORAGE/modality/P11",
		"$MESA_STORAGE/ordfil/mpps/$titleMPPSMgr",
		"1"
		);
  print LOG "\n";
}

sub x_1502_1 {
  print LOG "Image Manager 1502.1 \n";
  print LOG "Audit Record Messages \n";
  imgmgr::clear_syslog_files();
  imgmgr::extract_syslog_messages();
  my $xmlCount = imgmgr::count_syslog_xml_files();
  if ($xmlCount < 1) {
    print LOG "No Audit Messages found in syslog database \n";
    $diff += 1;
    return;
  }
  $diff += imgmgr::evaluate_all_xml_files();
}

# Main starts here

if (scalar(@ARGV) < 1) {
  print "This script requires one argument: <AE Title of your MPPS Mgr> \n";
  exit 1;
}

$titleMPPSMgr = $ARGV[0];
$verbose = grep /^-v/, @ARGV;

open LOG, ">1502/grade_1502.txt" or die "?!";
$diff = 0;

x_102_1;
x_1502_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1502/grade_1502.txt \n";

exit $diff;
