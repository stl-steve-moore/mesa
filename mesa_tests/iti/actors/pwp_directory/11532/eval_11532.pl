#!/usr/local/bin/perl -w

# This script evaluates PWP Directory output for test 11532.

use Env;
use lib "scripts";
use lib "../../../rad/actors/common/scripts";
require mesa; 
require pwp_directory; 

sub goodbye {}

sub x_11532_1 {
  print LOG "CTX: PWPD 11532.1\n";
  print LOG "CTX: Print out the MESA version used for the test.\n";
  print LOG "CTX: MESA version should be >= 9.0.0 for PWP Directory tests\n" if ($logLevel >= 3);

  my $l = <QRY_RESULT>;
  print LOG "CTX: $l\n";
  return 0;

  print LOG "\n";
}

sub x_11532_2 {
  print LOG "CTX: PWPD 11532.2\n";
  print LOG "CTX: Evaluate query response that should match one person.\n";

  my $x = pwp_directory::evaluate_LDAP_response(
        $logLevel,
        "11532/mesa/11532.txt",
        "11532/11532.qry.txt");

  print LOG "\n";
  return $x;
}

### Main starts here

# 

open LOG, ">11532/grade_11532.txt" or die "Could not open output file 11532/grade_11532.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";
$diff = 0;
die "Usage: perl 11532/eval_11532.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

open QRY_RESULT, "<11532/11532.qry.txt" or die "Could not open input file 11532/11532.qry.txt";

$diff += x_11532_1;
close QRY_RESULT;

$diff += x_11532_2;

close QRY_RESULT;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 11532/grade_11532.txt \n";

exit $diff;
