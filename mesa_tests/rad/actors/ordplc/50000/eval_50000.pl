#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require ordplc;
require mesa_common;

sub goodbye {die;}

sub x_50000_1 {
  print LOG "\nCTX: Order Placer 50000.1\n";
  $diff += mesa::evaluate_hl7(
		$logLevel,
		$verbose,
		"../../msgs/order/50000", "50000.130.o01.hl7",
		"$MESA_STORAGE/ordfil", "1002.hl7",
		"ini_files/orm_o01_format.ini", "ini_files/orm_o01_compare.ini");
  print LOG "\n";
}

### Main starts here

die "Usage: <log level: 1-4>" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

open LOG, ">50000/grade_50000.txt" or die "Could not open output file: 50000/grade_50000.txt";
$diff = 0;
$verbose = 0;
my $mesaVersion = mesa_get::getMESAVersion();
my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
print LOG "CTX: $mesaVersion \n";
print LOG "CTX: current date/time $date $timeToMinute\n";
print LOG "CTX: Log Level $logLevel\n";


x_50000_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 50000/grade_50000.txt \n";

exit $diff;
