#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require ordplc;

sub x_141_1 {
  print LOG "CTX: Order Placer 141.1\n";
  print LOG "CTX:Evaluating ORM-O01 message to MESA Order Filler.\n";

  $diff += mesa::evaluate_ORM_O01_Japanese (
		$logLevel,
		"../../msgs/order/141/141.106.o01.hl7",
		"$MESA_STORAGE/ordfil/1002.hl7");
  print LOG "\n";
}

### Main starts here

die "Usage: <log level: 1-4>" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

open LOG, ">141/grade_141.txt" or die "Could not open output file: 141/grade_141.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";
$diff = 0;

x_141_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 141/grade_141.txt \n";

exit $diff;
