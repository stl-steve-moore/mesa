#!/usr/local/bin/perl -w

# This script evaluates PWP Directory output for test 11530.

use Env;
use lib "scripts";
use lib "../../../rad/actors/common/scripts";
require mesa; 
require pwp_directory; 

sub goodbye {}

sub x_11530_1 {
  print LOG "CTX: PWPD 11530.1\n";
  print LOG "CTX: Print out the MESA version used for the test.\n";
  print LOG "CTX: MESA version should be >= 9.0.0 for PWP Directory tests\n" if ($logLevel >= 3);

  my $l = <QRY_RESULT>;
  print LOG "CTX: $l\n";
  return 0;

  print LOG "\n";
}

sub x_11530_2 {
  print LOG "CTX: PWPD 11530.2\n";
  print LOG "CTX: Evaluate query response that should match one person.\n";

  my $x = pwp_directory::evaluate_LDAP_response(
        $logLevel,
        "11530/mesa/11530.txt",
        "11530/11530.qry.txt");

  print LOG "\n";
  return $x;
}

### Main starts here

# 

open LOG, ">11530/grade_11530.txt" or die "Could not open output file 11530/grade_11530.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";
$diff = 0;
die "Usage: perl 11530/eval_11530.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

open QRY_RESULT, "<11530/11530.qry.txt" or die "Could not open input file 11530/11530.qry.txt";

$diff += x_11530_1;
close QRY_RESULT;

$diff += x_11530_2;

close QRY_RESULT;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 11530/grade_11530.txt \n";

exit $diff;
