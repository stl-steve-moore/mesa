#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require ordplc;

sub x_102_1 {
  print LOG "Order Placer 102.1\n";
  $diff += ordplc::evaluate_hl7(
		$verbose,
		"../../msgs/order/102", "102.104.o01.hl7",
		"$MESA_STORAGE/ordfil", "1001.hl7",
		"ini_files/orm_o01_format.ini", "ini_files/orm_o01_compare.ini");
  print LOG "\n";
}

sub x_102_2 {
  print LOG "Order Placer 102.2\n";
  $diff += ordplc::evaluate_hl7(
		$verbose,
		"../../msgs/order/102", "102.122.o01.hl7",
		"$MESA_STORAGE/ordfil", "1002.hl7",
		"ini_files/orm_o01_format.ini", "ini_files/orm_o01_compare.ini");
  print LOG "\n";
}

sub x_102_3 {
  print LOG "Order Placer 102.3\n";
  $diff += ordplc::evaluate_hl7(
		$verbose,
		"../../msgs/order/102", "102.132.o02.hl7",
		"$MESA_STORAGE/ordfil", "1003.hl7",
		"ini_files/orr_o02_format.ini", "ini_files/orr_o02_compare.ini");
  print LOG "\n";
}

die "Order Placer test 102 is retired as of May, 2003.\n";

open LOG, ">102/grade_102.txt" or die "?!";
$diff = 0;
$verbose = grep /^-v/, @ARGV;

x_102_1;
x_102_2;
x_102_3;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 102/grade_102.txt \n";

exit $diff;
