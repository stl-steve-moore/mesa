#!/usr/local/bin/perl -w


# Runs the Media Creator test 1901

use Env;
use File::Copy;

sub x_1900_1 {
  my ($isoImage) = @_;

  print LOG "Running test 1900.1 on $isoImage\n\n";
  my $x = "isovfy $isoImage";
  print "$x\n";
  print LOG "$x\n";
  print LOG `$x`;

  return 0;
}

sub x_1900_2 {
  my ($isoImage) = @_;

  print LOG "\nRunning test 1900.2 on $isoImage\n\n";
  my $x = "isoinfo -l -d -i $isoImage";
  print "$x\n";
  print LOG "$x\n";
  print LOG `$x`;

  return 0;
}

sub x_1900_3 {
  my ($isoImage) = @_;

  print LOG "\nRunning test 1900.3 on $isoImage\n\n";
  my $x = "isoinfo -l -i $isoImage";
  print "$x\n";
  print LOG "$x\n";
  print LOG `$x`;

  return 0;
}

## Main starts here

die "Usage: <ISO Image File Name>" if (scalar(@ARGV) < 1);

$isoImage   = $ARGV[0];
open LOG, ">1900/grade_1900.txt" or die "?!";

x_1900_1($isoImage);
x_1900_2($isoImage);
x_1900_3($isoImage);

print "Logs stored in 1900/grade_1900.txt \n";

