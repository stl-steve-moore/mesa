#!/usr/local/bin/perl -w

# Evaluate images, storage commitment and MPPS messages
# sent by a modality for test 2201.

use Env;
use lib "scripts";
use lib "../../../common/scripts";
require mod;
require mesa_common;


sub goodbye {}

sub x_2201_1 {
  print LOG "\nCTX Modality Test 2201.1 \n";

  my ($level, $fileName) = @_;

  if (! -e $fileName) {
    print LOG "ERR: File does not exist: $fileName\n";
    return 1;
  }

  $x = "$MESA_TARGET/bin/dcm_print_element 0008 0008 $fileName";
  print LOG "CTX $x\n" if ($level >= 3);

  my $imageType = `$x`;
  chop $imageType;
  print LOG "CTX $imageType\n" if ($level >= 3);
  my $rtnValue = mod::evaluate_NM_image_type($level, $imageType);

  print LOG "\n";
  return $rtnValue;
}

### Main starts here

 die "Usage: <log level> FILE [FILE ...]\n" if (scalar(@ARGV) < 2);
 open LOG, ">2201/grade_2201.txt" or die "?!";
 $outputLevel = $ARGV[0];

 my $mesaVersion = mesa_get::getMESAVersion();
 my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
 print LOG "CTX: $mesaVersion \n";
 print LOG "CTX: log level $outputLevel\n";
 print LOG "CTX: current date/time $date $timeToMinute\n";

 my $idx = 1;
 while ($idx < scalar(@ARGV)) {
  my $path = $ARGV[$idx];
   print "$path\n";
   $idx += 1;
   $diff += x_2201_1($outputLevel, $path);
 }

 print LOG "\nTotal Differences: $diff \n";
 print "\nTotal Differences: $diff \n";
 
 print "Logs stored in 2201/grade_2201.txt \n";

 exit $diff;

