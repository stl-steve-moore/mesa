#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require ordplc;

sub goodbye { die; }

sub x_132_1 {
  print LOG "CTX: Order Placer 132.1\n";
  $diff += mesa::evaluate_hl7(
		$logLevel,
		$verbose,
		"../../msgs/order/132", "132.104.o01.hl7",
		"$MESA_STORAGE/ordfil", "1002.hl7",
		"ini_files/orm_o01_format.ini", "ini_files/orm_o01_compare.ini");
  print LOG "\n";
}

sub x_132_2 {
  print LOG "CTX: Order Placer 132.2\n";
  $diff += mesa::evaluate_hl7(
		$logLevel,
		$verbose,
		"../../msgs/order/132", "132.118.o02.hl7",
		"$MESA_STORAGE/ordfil", "1003.hl7",
		"ini_files/orr_o02_format.ini", "ini_files/orr_o02_compare.ini");
  print LOG "\n";
}

### Main starts here

die "Usage: <log level: 1-4>" if (scalar(@ARGV) < 1);

open LOG, ">132/grade_132.txt" or die "?!";
$logLevel = $ARGV[0];
$diff = 0;
$verbose = 0;

x_132_1;
x_132_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 132/grade_132.txt \n";

exit $diff;
