#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require ordplc;

sub goodbye {}

sub x_103_1 {
  print LOG "CTX: Order Placer 103.1\n";
  $diff += mesa::evaluate_ORM_PlacerOrder (
		$logLevel,
		"../../msgs/order/103/103.104.o01.hl7",
		"$MESA_STORAGE/ordfil/1002.hl7");
  print LOG "\n";
}

#sub x_103_1 {
#  print LOG "Order Placer 103.1\n";
#  $diff += ordplc::evaluate_hl7(
#		$verbose,
#		"../../msgs/order/103", "103.104.o01.hl7",
#		"$MESA_STORAGE/ordfil", "1002.hl7",
#		"ini_files/orm_o01_format.ini", "ini_files/orm_o01_compare.ini");
#  print LOG "\n";
#}

open LOG, ">103/grade_103.txt" or die "?!";
$diff = 0;
#$verbose = 0;
die "Usage: perl 103/eval_103.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

x_103_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 103/grade_103.txt \n";

exit $diff;
