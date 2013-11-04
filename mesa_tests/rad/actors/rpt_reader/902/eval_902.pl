#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require rpt_reader;

sub goodbye() {
  exit 1;
}

# Search for a query response for a specific attribute and value

sub x_902 {
  print LOG "Report Reader Test 902 \n";
  print LOG " General query evaluation \n";

  $cfindDir = "$MESA_STORAGE/rpt_repos/queries";

  my @cFindMsgs = rpt_reader::find_all_queries($verbose, $cfindDir);


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


$verbose = grep /^-v/, @ARGV;

open LOG, ">902/grade_902.txt" or die "?!";
$diff = 0;

$diff = x_902();

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 902/grade_902.txt \n";

exit $diff;
