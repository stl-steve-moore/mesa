#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require expmgr;

sub goodbye() {
  exit 1;
}

sub x_3000_1 {
  print LOG "CTX: Export Manager 3000.1 \n";
  print LOG "CTX: Evaluating Teaching File/Clinical Trial KON structure\n";

  my $count = 0;
  my ($status, $path) = mesa::locate_KON_singular($logLevel, "exprcr");
  return 1 if ($status != 0);
  print LOG "CTX: Path to KON $path\n" if ($logLevel >= 3);

  #evaluate KON.
  $count += mesa::evaluate_KON_TFCTE(
		$logLevel,
		$path
		);
  print LOG "\n";
  return $count;
}

sub x_3000_2 {
  print LOG "CTX: Export Manager 3000.2 \n";
  print LOG "CTX: Evaluating Teaching File/Clinical Trial KON attributes \n";

  my $count = 0;
  my ($status, $path) = mesa::locate_KON_singular($logLevel, "exprcr");
  return 1 if ($status != 0);
  print LOG "CTX: Path to KON $path\n" if ($logLevel >= 3);


  $count += mesa::evaluate_KON_TFCTE_Title(
		$logLevel,
		$path, "113004", "DCM", "For Teaching");
  print LOG "\n";
  return $count;
}

sub x_3000_3 {
  print LOG "CTX: Export Manager 3000.3 \n";
  print LOG "CTX: Evaluating KON reference list\n";

  my $count = 0;
  my ($s1, @path) = mesa::locate_instances_by_class($logLevel, "exprcr", "1.2.840.10008.5.1.4.1.1.4");
  return 1 if ($s1 != 0);
  
  my ($s2, $path) = mesa::locate_KON_singular($logLevel, "exprcr");
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

#evaluate deidentification of images
sub x_3000_4 {
  print LOG "CTX: Export Manager 3000.4 \n";
  print LOG "CTX: Evaluating deidentification of image instances and KON(s)\n";

  my $count = 0;
  my ($status, @images) = mesa::locate_instances_by_class($logLevel, "exprcr", "1.2.840.10008.5.1.4.1.1.4");
  return 1 if ($status != 0);
  

  if ($logLevel >= 3){
    foreach $p (@images) {
      print LOG "Path: $p\n";
    }
  }
  $count += mesa::evaluate_deidentification($logLevel,"3000", "deltaIM.txt", @images);
  
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
$diff += x_3000_2;
$diff += x_3000_3;
$diff += x_3000_4;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 3000/grade_3000.txt \n";

exit $diff;
