#!/usr/local/bin/perl -w
use File::Find;

# Evaluate DICOM Composite Objects using Clunie's Tool.

use Env;
use lib "scripts";
require mod;

sub goodbye {}

sub x_284_1 {
  print LOG "CTX: Modality Test 284.1 \n";
  print LOG "CTX:  DICOM Composite Object evaluation\n";

  my ($level, $path) = @_;
  print LOG "CTX: Path for composite object: $path\n" if ($level >= 3);

  # Place evaluation here. Return 0 on success, return 1 on failure
  # All output should be printed into LOG
  find(\&edits, $path);

sub edits() {
  return unless -f;
  push @files, $File::Find::name;
}

foreach (sort @files) {
  print LOG "$_\n";
  $length = length($_);
  for ($i=1; $i<=$length; $i++) { print LOG "="; }
    print LOG "\n";
    print LOG `$MESA_TARGET/bin/dciodvfy $_ 2>&1`;
    print LOG "\n\n";
  }

  my $rtnValue = 0;

  print LOG "\n";
  return $rtnValue;
}

### Main starts here
die "Usage: <log level> <path> \n" if (scalar(@ARGV) < 2);

$outputLevel = $ARGV[0];
$path = $ARGV[1];

open LOG, ">284/grade_284.txt" or die "?!";
$diff = 0;

$diff += x_284_1($outputLevel, $path);

#print LOG "\nTotal Differences: $diff \n";
#print "\nTotal Differences: $diff \n";

print "Logs stored in 284/grade_284.txt \n";
print "Please look at log file for error messages, if any. \n";

exit $diff;
