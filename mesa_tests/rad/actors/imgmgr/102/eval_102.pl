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
  $diff += mesa::evaluate_mpps_v2($verbose,
		"$MESA_STORAGE/modality/T102",
		"$MESA_STORAGE/ordfil/mpps/$titleMPPSMgr",
		"1"
		);
  print LOG "\n";
}

# Main starts here

die "Image Manager test 102 is retired as of May, 2003.\n";

if (scalar(@ARGV) < 1) {
  print "This script requires one argument: <AE Title of your MPPS Mgr> \n";
  exit 1;
}

$titleMPPSMgr = $ARGV[0];
$verbose = grep /^-v/, @ARGV;

open LOG, ">102/grade_102.txt" or die "?!";
$diff = 0;

x_102_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 102/grade_102.txt \n";

exit $diff;
