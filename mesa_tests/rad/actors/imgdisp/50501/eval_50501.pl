#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
use lib "../../../common/scripts";
require imgdisp;
require mesa_common;

sub goodbye() {
  exit 1;
}

# Search for a query response for a specific attribute and value

sub x_50501 {
  my $tag = shift(@_);
  my $val = shift(@_);
  print LOG "Image Display 50501 \n";
  print LOG " Tag = $tag, val = $val \n";

  if ($MESA_OS eq "WINDOWS_NT") {
    $cfindDir = "$MESA_STORAGE\\imgmgr\\queries";
  } else {
    $cfindDir = "$MESA_STORAGE/imgmgr/queries";
  }

 $verbose = 0;
 $verbose = 1 if ($logLevel >= 3);

 $cfindFile = imgdisp::find_matching_query($verbose, $cfindDir, $tag, $val);

 if ($cfindFile eq "") {
   print LOG "Unable to locate C-Find query for $tag $val\n";
   $diff += 1;
 }

 print LOG "\n";
}


die "Usage: perl 50501/eval_50501.pl <log level>\n" if (scalar(@ARGV) != 1);
$logLevel = $ARGV[0];

open LOG, ">50501/grade_50501.txt" or die "?!";
my $mesaVersion = mesa_get::getMESAVersion();
my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
print LOG "CTX: Image Display test 50501\n";
print LOG "CTX: $mesaVersion \n";
print LOG "CTX: current date/time $date $timeToMinute\n";
print LOG "CTX: Log level: $logLevel\n";

$diff = 0;

x_50501("0008 0020", "20050830");
x_50501("0008 0050", "50501");
x_50501("0010 0010", "Barkley*");
x_50501("0010 0020", "311");
x_50501("0008 0061", "OP");

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 50501/grade_50501.txt \n";

exit $diff;
