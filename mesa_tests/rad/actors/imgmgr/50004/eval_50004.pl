#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
use lib "../../../common/scripts";
require imgmgr;
require mesa_common;

sub goodbye() {
  exit 1;
}

# Examine the MPPS messages forwarded by the Image Manager

sub x_50004_1 {
  print LOG "\nCTX: Image Manager 50004.1 \n";
  print LOG "CTX: MPPS messages for EYECARE-200 forwarded to Order Filler \n";
  $diff += mesa::evaluate_mpps_mpps_mgr(
		$logLevel,
		"$MESA_STORAGE/modality/T50004",
		"$MESA_STORAGE/ordfil/mpps/$titleMPPSMgr",
		"1"
		);
  print LOG "\n";
}

die "Usage <log level: 1-4> <AE Title MPPS Mgr> " if (scalar(@ARGV) < 2);

$logLevel     = $ARGV[0];
$titleMPPSMgr = $ARGV[1];

open LOG, ">50004/grade_50004.txt" or die "Could not open output file: 50004/grade_50004.txt";
my $mesaVersion = mesa_get::getMESAVersion();
my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
print LOG "CTX: $mesaVersion \n";
print LOG "CTX: current date/time $date $timeToMinute\n";
print LOG "CTX: Log level $logLevel\n";

$diff = 0;

x_50004_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 50004/grade_50004.txt \n";

exit $diff;
