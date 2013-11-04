#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require ordplc;

sub x_142_1 {
  print LOG "CTX: Order Placer 142.1\n";
  print LOG "CTX:Evaluating ORM-O01 message to MESA Order Filler.\n";
  $diff += mesa::evaluate_ORM_O01_Japanese (
		$logLevel,
		"../../msgs/order/142/142.106.o01.hl7",
		"$MESA_STORAGE/ordfil/1002.hl7");
  print LOG "\n";
}

### Main starts here

die "Usage: <log level: 1-4>" if (scalar(@ARGV) < 1);

open LOG, ">142/grade_142.txt" or die "?!";
$logLevel = $ARGV[0];
$diff = 0;

x_142_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 142/grade_142.txt \n";

exit $diff;
