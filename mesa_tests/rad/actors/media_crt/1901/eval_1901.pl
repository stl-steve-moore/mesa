#!/usr/local/bin/perl -w


# Runs the Media Creator test 1901

use Env;
use File::Copy;

# Find hostname of this machine

sub x_1901_1 {
  my ($logLevel, $mountPoint) = @_;

  $x = "$MESA_TARGET/bin/mesa_pdi_eval -r $logLevel $mountPoint 1";
  print "$x\n";
  print LOG `$x`;
  return 1 if $?;
  return 0;
}

## Main starts here

die "Usage: <log level: 1-4> <CD mount point>" if (scalar(@ARGV) < 2);

$logLevel = $ARGV[0];
$mountPoint = $ARGV[1];
open LOG, ">1901/grade_1901.txt" or die "?!";
$diff = 0;

$diff = x_1901_1($logLevel, $mountPoint);

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1901/grade_1901.txt \n";

exit $diff;

