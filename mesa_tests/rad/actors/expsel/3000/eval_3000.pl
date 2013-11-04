#!/usr/local/bin/perl -w

use Env;

use lib "../../../rad/actors/common/scripts";
use lib "../../../common/scripts";
require evaluate_tfcte;
require mesa;
require mesa_common;
require mesa_evaluate;
#require expsel;

sub dummy {}

sub goodbye() {
  exit 1;
}

# Evaluate KON manifest
sub x_3000_1 {
  print LOG "CTX: Export Selector 3000.1 \n";
  print LOG "CTX: Evaluating Teaching File/Clinical Trial KON structure\n";

  my $count = 0;
  my ($status, $path) = mesa::locate_KON_singular($logLevel, "expmgr");
  return 1 if ($status != 0);
  print LOG "CTX: Path to KON $path\n" if ($logLevel >= 3);

  #evaluate KON.
  $count += mesa::evaluate_KON_TFCTE(
        $logLevel,
        $path
        );
  return $count;
}

sub x_3000_2 {
  print LOG "CTX: Export Selector 3000.2 \n";
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

sub x_3000_3 {
  print LOG "CTX: Export Manager 3000.3 \n";
  print LOG "CTX: Evaluating Teaching File/Clinical Trial KON attributes \n";

  my $count = 0;
  my ($status, $path) = mesa::locate_KON_singular($logLevel, "expmgr");
  return 1 if ($status != 0);
  print LOG "CTX: Path to KON $path\n" if ($logLevel >= 3);


  $count += evaluate_tfcte::evaluate_KON_TFCTE_Title(
        $logLevel,
        $path, "TCE001", "IHERADTF", "For Teaching File Export");
#        $path, "113004", "DCM", "For Teaching";
  print LOG "\n";
  return $count;
}

die "Usage <log level: 1-4> " if (scalar(@ARGV) < 1);

$logLevel     = $ARGV[0];

open LOG, ">3000/grade_3000.txt" or die "Could not open output file: 3000/grade_3000.txt";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    3000\n";
print LOG "CTX: Actor:   EXPORT_SELECTOR\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

$diff += x_3000_1;
$diff += x_3000_2;
$diff += x_3000_3;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("3000/grade_3000.txt", "3000/mir_mesa_3000.xml",
        $logLevel, "3000", "EXPORT_SELECTOR", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "\nThis test completed with zero errors; that means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 3000/grade_3000.txt and 3000/mir_mesa_3000.xml\n";
}

print "If you are submitting a result file to Kudu, submit 3000/mir_mesa_3000.xml\n\n";

