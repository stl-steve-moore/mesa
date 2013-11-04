#!/usr/local/bin/perl -w

# This script evaluates PWP Directory output for test 11505.

use Env;
use lib "scripts";
use lib "../../../rad/actors/common/scripts";
require mesa; 

sub goodbye {}

sub x_11505_1 {
  print LOG "CTX: PWPD 11505.1\n";
  print LOG "CTX: Print out the MESA version used for the test.\n";
  print LOG "CTX: MESA version should be >= 9.0.0 for PWP Directory tests\n" if ($logLevel >= 3);

  my $l = <QRY_RESULT>;
  print LOG "CTX: $l\n";
  return 0;

  print LOG "\n";
}

sub x_11505_2 {
  print LOG "CTX: PWPD 11505.2\n";
  print LOG "CTX: Evaluate response to find Base DN.\n";
  print LOG "CTX: This evalution will print the result for human evaluation.\n";
  print LOG "CTX: Your base DN may be slightly different than the MESA expected value\n";

  my $l;
  while ($l = <QRY_RESULT>) {
    print LOG "$l";
  }
  return 0;

  print LOG "\n";
}

### Main starts here

# 

open LOG, ">11505/grade_11505.txt" or die "Could not open output file 11505/grade_11505.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";
$diff = 0;
die "Usage: perl 11505/eval_11505.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

open QRY_RESULT, "<11505/11505.qry.txt" or die "Could not open input file 11505/11505.qry.txt";

$diff += x_11505_1;
$diff += x_11505_2;

close QRY_RESULT;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 11505/grade_11505.txt \n";

exit $diff;
