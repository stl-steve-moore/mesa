#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require ordplc;
require mesa_common;

sub goodbye { die; }

sub x_50001_1 {
  print LOG "CTX: Order Placer 50001.1\n";
  print LOG "CTX: Evaluating ORR message from Order Placer\n";
  $diff += mesa::evaluate_hl7(
		$logLevel,
		$verbose,
		"../../msgs/order/50001", "50001.140.o02.hl7",
		"$MESA_STORAGE/ordfil", "1002.hl7",
		"ini_files/orr_o02_format.ini", "ini_files/orr_o02_compare.ini");
  print LOG "\n";
}

### Main starts here

die "Usage: <log level: 1-4>" if (scalar(@ARGV) < 1);

$logLevel = $ARGV[0];
$diff = 0;
$verbose = 0;
open LOG, ">50001/grade_50001.txt" or die "Could not open output file: 50001/grade_50001.txt";
my $mesaVersion = mesa_get::getMESAVersion();
print LOG "CTX: $mesaVersion \n";


x_50001_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 50001/grade_50001.txt \n";

exit $diff;
