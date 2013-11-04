#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;

sub processLine {
  my ($l, $msgNumber) = @_;
  my ($pid, $name, $dob, $streetAddress, $city, $state, $zip, $secondID, $sex, $race, $referring) = split("\t", $l);
  print "$pid:$name:$dob:$referring\n";
  my ($pid1, $pid2) = split("\\^", $pid);
  my ($pida, $pidb) = split("\\^", $secondID);

  print METRO "perl ../rename-study.pl $name $pid1 $dob 1*\n";
  print LAKESIDE "perl ../rename-study.pl $name $pida $dob 1*\n";

  return 0;
}

if (scalar(@ARGV) != 1) {
  die "Usage: script <input file>\n";
}

my $inFile = $ARGV[0];
open IN, "<$inFile" or die "Could not open input file: $inFile\n";

open METRO, ">rad-metro.csh";
open LAKESIDE, ">rad-lakeside.csh";
print METRO "#!/bin/csh\n\n";
print LAKESIDE "#!/bin/csh\n\n";

my $msgNumber = 1000;
$line = <IN>;
while ($line = <IN>) {
  chomp($line);
  processLine($line, $msgNumber);
  $msgNumber += 2;
}

close METRO;
close LAKESIDE;
