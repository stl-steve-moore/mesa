#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require ordfil;

sub goodbye() {
  exit 1;
}

sub x_106_1 {
 print LOG "Order Filler 106.1 \n";
 print LOG "Examing PPS messages for X6,X7 forwarded to Image Mgr \n";

 $rtnValue = ordfil::evaluate_mpps_v2(
		$verbose,
		"$MESA_STORAGE/modality/T106",
		"$MESA_STORAGE/imgmgr/mpps/$titleMPPSMgr",
		"1"
		);
 print LOG "\n";

 return $rtnValue;
}

sub x_106_2 {
 print LOG "Order Filler 106.2 \n";
 print LOG "Examing PPS messages for GSPS X6 forwarded to Image Mgr \n";

 $rtnValue = ordfil::evaluate_mpps_v2(
		$verbose,
		"$MESA_STORAGE/modality/T106_gsps_x6",
		"$MESA_STORAGE/imgmgr/mpps/$titleMPPSMgr",
		"1"
		);
 print LOG "\n";
 return $rtnValue;
}

sub x_106_3 {
 print LOG "Order Filler 106.3 \n";
 print LOG "Examing PPS messages for GSPS X7 forwarded to Image Mgr \n";

 $rtnValue = ordfil::evaluate_mpps_v2(
		$verbose,
		"$MESA_STORAGE/modality/T106_gsps_x7",
		"$MESA_STORAGE/imgmgr/mpps/$titleMPPSMgr",
		"1"
		);
 print LOG "\n";
 return $rtnValue;
}

### Main starts here

if (scalar(@ARGV) < 1) {
  print "This script requires one argument: <AE Title of your MPPS Mgr> \n";
  exit 1;
}

$titleMPPSMgr = $ARGV[0];
$verbose = grep /^-/, @ARGV;
open LOG, ">106/grade_106.txt" or die "?!";

$diff = 0;

$diff += x_106_1;
$diff += x_106_2;
$diff += x_106_3;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 106/grade_106.txt \n";

exit $diff;
