#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require ordplc;

sub goodbye { die; }

sub x_133_1 {
  print LOG "CTX: Order Placer 133.1\n";
  $diff += mesa::evaluate_hl7(
		$logLevel,
		$verbose,
		"../../msgs/order/133", "133.146.o02.hl7",
		"$MESA_STORAGE/ordfil", "1003.hl7",
                "ini_files/orr_o02_format.ini", "ini_files/orr_o02_compare.ini");
  print LOG "\n";
}

### Main starts here

die "Usage: <log level: 1-4>" if (scalar(@ARGV) < 1);

open LOG, ">133/grade_133.txt" or die "?!";
$logLevel = $ARGV[0];
$diff = 0;
$verbose = 0;

x_133_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 133/grade_133.txt \n";

exit $diff;
