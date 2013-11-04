#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
use lib "../../../common/scripts";
require ordfil;
require mesa_common;

sub goodbye() {
  exit 1;
}

# Compare input HL7 messages with expected values.

sub x_50004_1 {
 print LOG "\nCTX: Order Filler 50004.1 \n";
 print LOG "CTX Examing PPS messages for EYE-200/EYE_PC_201 forwarded to Image Mgr \n";

 my $x = mesa::evaluate_mpps_mpps_mgr(
		$logLevel,
		"$MESA_STORAGE/modality/T50004",
		"$MESA_STORAGE/imgmgr/mpps/$titleMPPSMgr",
		"1"
		);
 print LOG "\n";
 return $x;
}

### Main starts here

die "Usage: <log level: 1-4> <AE Title of your MPPS Mgr>" if (scalar(@ARGV) < 2);

$logLevel = $ARGV[0];
$titleMPPSMgr = $ARGV[1];
#$verbose = 0;
open LOG, ">50004/grade_50004.txt" or die "?!";
my $mesaVersion = mesa_get::getMESAVersion();
my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
print LOG "CTX: $mesaVersion \n";
print LOG "CTX: current date/time $date $timeToMinute\n";
print LOG "CTX: Log Level $logLevel\n";

$diff = 0;

$diff += x_50004_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 50004/grade_50004.txt \n";

exit $diff;
