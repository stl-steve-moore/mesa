#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require ordplc;

sub x_104_1 {
  print LOG "Order Placer 104.1\n";
  $diff += ordplc::evaluate_hl7(
		$verbose,
		"../../msgs/order/104", "104.104.o01.hl7",
		"$MESA_STORAGE/ordfil", "1001.hl7",
		"ini_files/orm_o01_format.ini", "ini_files/orm_o01_compare.ini");
  print LOG "\n";
}

sub x_104_2 {
  print LOG "Order Placer 104.1\n";
  $diff += ordplc::evaluate_hl7(
		$verbose,
		"../../msgs/order/104", "104.146.o02.hl7",
		"$MESA_STORAGE/ordfil", "1002.hl7",
		"ini_files/orr_o02_format.ini", "ini_files/orr_o02_compare.ini");
  print LOG "\n";
}

die "Order Placer test 104 is retired as of May, 2003.\n";

open LOG, ">104/grade_104.txt" or die "?!";
$diff = 0;
$verbose = grep /^-v/, @ARGV;

x_104_1;
x_104_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 104/grade_104.txt \n";

exit $diff;
