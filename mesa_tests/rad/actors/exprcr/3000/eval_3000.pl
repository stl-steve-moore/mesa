#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require exprcr;

sub goodbye() {
  exit 1;
}

sub x_3000_1 {
  print LOG "CTX: Export Receiver 3000.1 \n";
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

die "Usage <log level: 1-4> " if (scalar(@ARGV) < 1);

$logLevel     = $ARGV[0];

open LOG, ">3000/grade_3000.txt" or die "Could not open output file: 3000/grade_3000.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";

$diff = 0;

$diff += x_3000_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 3000/grade_3000.txt \n";

exit $diff;
