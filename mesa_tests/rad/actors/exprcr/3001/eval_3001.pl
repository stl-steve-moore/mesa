#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require exprcr;

sub goodbye() {
  exit 1;
}

sub x_3001 {
  print LOG "CTX: Export Receiver 3001.1 \n";
  print LOG "CTX: Evaluating KON reference list\n";

  my $count = 0;
  my ($s1, @path) = mesa::locate_instances_by_class($logLevel, "expmgr", "1.2.840.10008.5.1.4.1.1.4");
  return 1 if ($s1 != 0);

  my ($s2, $path) = mesa::locate_KON_singular($logLevel, "expmgr");
  return 1 if ($s2 != 0);

  if ($logLevel >= 3){
    foreach $p (@path) {
      print LOG "Path: $p\n";
    }
    print LOG "CTX: Path to KON $path\n";
  }

  #Check number of images is the same as referenced in KON and check each image UID is the same as in KON also.
  $count += mesa::evaluate_Image_References($logLevel,$path,@path);

  print LOG "\n";
  return $count;
}

sub x_3001_1 {
  print LOG "CTX: Export Receiver 3001.1 \n";
  print LOG "CTX: KON reference list\n";
  print "\nYou should have received images as referenced in KON manifest from MESA Image Manager.\n";
  print "From the image directory where these images are stored, please find the image count and \n";
  print "submit the image count to the Project Manager.\n\n";
}

die "Usage <log level: 1-4> " if (scalar(@ARGV) < 1);

$logLevel     = $ARGV[0];

open LOG, ">3001/grade_3001.txt" or die "Could not open output file: 3001/grade_3001.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";

$diff = 0;

$diff += x_3001_1;

#print LOG "\nTotal Differences: $diff \n";
#print "\nTotal Differences: $diff \n";

print "Logs stored in 3001/grade_3001.txt \n";

exit $diff;
