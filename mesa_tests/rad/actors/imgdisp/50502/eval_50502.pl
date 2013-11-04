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

sub x_50502 {
  print LOG "Image Display Test 50502 \n";
  print LOG " General query evaluation \n";

  $cfindDir = "$MESA_STORAGE/imgmgr/queries";

  my @cFindMsgs = imgdisp::find_all_queries($verbose, $cfindDir);


  $successCount = 0;

  $rtnValue = 0;

  ENTRY: foreach $msg(@cFindMsgs) {
    $fileName = "$cfindDir/$msg";
    next ENTRY if (-d $fileName);
    $x = "$MESA_TARGET/bin/cfind_evaluate ";
    $x .= " -v" if $verbose;
    $x .= " STUDY $fileName";

    print LOG "$x\n";
    print "$x\n" if $verbose;

    print LOG `$x`;

    if ($? == 0) {
      $successCount++;
    } else {
      $rtnValue = 1;
    }
  }

  if ($successCount == 0) {
    print LOG "Found no queries that were successfully evaluated \n";
    $rtnValue = 1;
  }

  return $rtnValue;

}


die "Usage: perl 50502/eval_50502.pl <log level>\n" if (scalar(@ARGV) != 1);
$verbose = 0;
$logLevel = $ARGV[0];
$verbose = 1 if ($logLevel >= 3);

open LOG, ">50502/grade_50502.txt" or die "?!";

my $mesaVersion = mesa_get::getMESAVersion();
my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
print LOG "CTX: Image Display test 50502\n";
print LOG "CTX: $mesaVersion \n";
print LOG "CTX: current date/time $date $timeToMinute\n";
print LOG "CTX: Log level: $logLevel\n";

$diff = 0;

$diff = x_50502();

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 50502/grade_50502.txt \n";

exit $diff;
