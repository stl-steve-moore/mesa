#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
use lib "../../../common/scripts";
require ordfil;
require mesa_common;

sub goodbye() {
  exit 1;
}

# Subroutines that run the evaluation tests

sub x_50001_1 {
 print LOG "\nCTX: Order Filler 50001.7 \n";
 print LOG "CTX:  Evaluating HL7 ORM message to Order Placer for P21/X1 \n";

 my $x = 0;
 $x =  mesa::evaluate_hl7 (
		$logLevel,
		$verbose,
		"../../msgs/order/50001", "50001.130.o01.hl7",
		"$MESA_STORAGE/ordplc", "1001.hl7",
		"ini_files/orm_o01_format.ini", "ini_files/orm_o01_compare.ini");
 print LOG "\n";
 return $x;
}

### Main starts here

die "Usage: <log level: 1-4> <AE Title of your MPPS Mgr>" if (scalar(@ARGV) < 2);

$logLevel = $ARGV[0];
#$titleMPPSMgr = $ARGV[1];
$verbose = 0;
open LOG, ">50001/grade_50001.txt" or die "?!";
my $mesaVersion = mesa_get::getMESAVersion();
my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
print LOG "CTX: $mesaVersion \n";
print LOG "CTX: current date/time $date $timeToMinute\n";
print LOG "CTX: Log Level $logLevel\n";

$diff = 0;

$diff += x_50001_1;	# ORM message sent to Order Filler

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 50001/grade_50001.txt \n";

exit $diff;
