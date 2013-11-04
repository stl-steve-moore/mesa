#!/usr/local/bin/perl -w


# Runs the Media Creator test 1904

use Env;
use File::Copy;

# Find hostname of this machine

sub x_1904_x {
  my ($logLevel, $mountPoint, $testNumber) = @_;
  print LOG "CTX: Media evaluation test $testNumber\n" if ($logLevel >= 3);

  $x = "$MESA_TARGET/bin/mesa_pdi_eval -r $logLevel $mountPoint $testNumber";
  print "$x\n";
  print LOG `$x`;
  return 1 if $?;
  return 0;
}

## Main starts here

die "Usage: <log level: 1-4> <CD mount point>" if (scalar(@ARGV) < 2);

$logLevel = $ARGV[0];
$mountPoint = $ARGV[1];
open LOG, ">1904/grade_1904.txt" or die "?!";
$diff = 0;

$diff = x_1904_x($logLevel, $mountPoint, 1);
if ($diff != 0) {
 print LOG "Cannot run any other tests if you fail test 1\n";
 print LOG "Please determine the proper mount point\n";
 print "Cannot run any other tests if you fail test 1\n";
 print "Please determine the proper mount point\n";
 exit 1;
}

@testNumbers = (3, 4, 5, 6, 7);
foreach $t(@testNumbers) {
 $diff += x_1904_x($logLevel, $mountPoint, $t);
}

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1904/grade_1904.txt \n";

exit $diff;

