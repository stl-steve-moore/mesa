#!/usr/local/bin/perl -w

use Env;
use lib "scripts";


sub runMediaCreatorTest {
  my ($logLevel, $reportLevel, $dirName, $testNumber) = @_;

  print "\nAbout to run test $testNumber on directory: $dirName\n";
  my $x = "$MESA_TARGET/bin/mesa_pdi_eval -r $reportLevel -l $logLevel $dirName $testNumber";
  print "$x\n";
  print `$x`;
  return 1 if ($?);
  return 0;
}

if (scalar(@ARGV) != 3) {
  print "Usage: rsna2004_mediacrt.pl <directory> <report level> <log level>\n";
  exit 1;
}

@testList = ("1", "2", "3", "4", "5", "6", "7", "8", "9");

my $dirName = $ARGV[0];
my $rptLevel= $ARGV[1];
my $logLevel= $ARGV[2];

my $rtnValue = 0;

foreach $t(@testList) {
  print "$t\n";
  my $val = runMediaCreatorTest($logLevel, $rptLevel, $dirName, $t);
  $rtnValue = 1 if ($val != 0);
}

if ($rtnValue == 0) {
  print "All Media Creator tests are completed successfully\n";
} else {
  print "Did not pass all Media Creator tests\n";
}
