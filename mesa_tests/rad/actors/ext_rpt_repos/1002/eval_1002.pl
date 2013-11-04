#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require rptrepos;

sub goodbye() {
  exit 1;
}

sub x_1002_1 {
  my $verbose = shift(@_);

  print LOG "External Report Repository Test 1002.1\n";
  print LOG "Looking for 0020 1206 Study Related Series (by Patient ID) \n";
  print LOG "Looking for 0028 1208 Study Related Instances (by Patient ID) \n";

  @ cfindResponses = rptrepos::find_responses("1002/results/a");

  $x = scalar(@cfindResponses);

  if ($x == 0) {
    print LOG "Found no responses to 1002.a query \n";
    print LOG "That is a failure \n";
    return 1;
  }

  $rtnValue = 0;
  foreach $response(@cfindResponses) {
    print LOG "$response \n" if ($verbose);
    $x ="$MESA_TARGET/bin/dcm_print_element 0020 1206 1002/results/a/$response";
    $seriesCount = `$x`; chomp $seriesCount;
    print LOG " 0020 1206 Number of Study Related Series = <$seriesCount>\n"
	if ($verbose);
    if ($seriesCount eq "") {
      print LOG "0020 1206 not found in 1002/results/a/$response \n";
      print LOG "That constitutes a failure \n";
      $rtnValue = 1;
    }

    $x ="$MESA_TARGET/bin/dcm_print_element 0020 1208 1002/results/a/$response";
    $instanceCount = `$x`; chomp $instanceCount;
    print LOG " 0020 1208 Number of Study Related Instances = <$instanceCount>\n"
	if ($verbose);
    if ($instanceCount eq "") {
      print LOG "0020 1208 not found in 1002/results/a/$response \n";
      print LOG "That constitutes a failure \n";
      $rtnValue = 1;
    }
  }

  print LOG "\n";

  return $rtnValue;
}

$verbose = grep /^-v/, @ARGV;

open LOG, ">1002/grade_1002.txt" or die "?!";
$diff = 0;

$diff += x_1002_1($verbose);

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1002/grade_1002.txt \n";

exit $diff;
