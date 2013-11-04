#!/usr/local/bin/perl -w

# This script evaluates ADT messages that should be
# sent by a Patient Demographics Source system for test 12102.

use Env;
use lib "scripts";
require pds_pam;

sub x_12102_1 {
  print LOG "CTX: ADT 12102.1\n";
  print LOG "CTX: Evaluate first A28 message\n";
  $diff += mesa::evaluate_ADT_A28 (
	$logLevel,
	"../../msgs/adt/12102/12102.102.a28.hl7",
	"$MESA_STORAGE/ordfil/1001.hl7");
  print LOG "\n";
}

sub x_12102_2 {
  print LOG "CTX: ADT 12102.2\n";
  print LOG "CTX: Evaluate A31 update message\n";
  $diff += mesa::evaluate_ADT_A31_PAM (
	$logLevel,
	"../../msgs/adt/12102/12102.104.a31.hl7",
	"$MESA_STORAGE/ordfil/1002.hl7");
  print LOG "\n";
}

#sub x_12102_2 {
#  print LOG "CTX: ADT 12102.1\n";
#  print LOG "CTX: Evaluate A28 message and A31 messaage\n";
#  $diff += mesa::evaluate_ADT_A28_A31 (
#	$logLevel,
#        "$MESA_STORAGE/ordfil/1001.hl7",
#	"$MESA_STORAGE/ordfil/1002.hl7");
#  print LOG "\n";
#}

# Main starts here
die "Usage: perl 12102/eval_12102.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);

open LOG, ">12102/grade_12102.txt" or die "Could not open output file 12102/grade_12102.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";

$diff = 0;
$logLevel = $ARGV[0];

x_12102_1;
x_12102_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 12102/grade_12102.txt \n";

exit $diff;
