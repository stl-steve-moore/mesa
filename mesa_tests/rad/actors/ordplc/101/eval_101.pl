#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require ordplc;

sub x_101_1 {
  print LOG "Order Placer 101.1\n";
  $diff += ordplc::evaluate_hl7(
		$verbose,
		"../../msgs/order/101", "101.104.o01.hl7",
		"$MESA_STORAGE/ordfil", "1001.hl7",
		"ini_files/orm_o01_format.ini", "ini_files/orm_o01_compare.ini");
  print LOG "\n";
}

sub x_101_2 {
  print LOG "Order Placer 101.2 \n";
  $diff += ordplc::evaluate_hl7(
		$verbose,
		"../../msgs/order/101", "101.164.o02.hl7",
		"$MESA_STORAGE/ordfil", "1002.hl7",
		"ini_files/orr_o02_format.ini", "ini_files/orr_o02_compare.ini");
  print LOG "\n";
}

sub x_101_3 {
  print LOG "Order Placer 101.3\n";
  $diff += ordplc::evaluate_hl7(
		$verbose,
		"../../msgs/order/101", "101.182.o01.hl7",
		"$MESA_STORAGE/ordfil", "1003.hl7",
		"ini_files/orm_o01_format.ini", "ini_files/orm_o01_compare.ini");
  print LOG "\n";
}

sub x_101_4 {
  print LOG "Order Placer 101.4\n";
  $diff += ordplc::evaluate_hl7(
		$verbose,
		"../../msgs/order/101", "101.188.o01x.hl7",
		"$MESA_STORAGE/ordfil", "1004.hl7",
		"ini_files/orm_o01x_format.ini", "ini_files/orm_o01x_compare.ini");
  print LOG "\n";
}

sub x_101_5 {
  print LOG "Order Placer 101.5\n";
  $diff += ordplc::evaluate_hl7(
		$verbose,
		"../../msgs/order/101", "101.192.o01.hl7",
		"$MESA_STORAGE/ordfil", "1005.hl7",
		"ini_files/orm_o01_format.ini", "ini_files/orm_o01_compare.ini");
  print LOG "\n";
}

### Main starts here

die "Order Placer test 101 is retired as of May, 2003\n";

open LOG, ">101/grade_101.txt" or die "?!";
$diff = 0;
$verbose = grep /^-v/, @ARGV;

x_101_1;
x_101_2;
x_101_3;
x_101_4;
x_101_5;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 101/grade_101.txt \n";

exit $diff;
