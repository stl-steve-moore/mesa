#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require rptrepos;

sub goodbye() {
  exit 1;
}

sub x_1001_1 {
  my $verbose = shift(@_);

  print LOG "External Report Repository Test 1001.1\n";
  print LOG "Looking for 0008 0061 Modalities in Study (by Patient ID) \n";

  @ cfindResponses = rptrepos::find_responses("1001/results/a");

  $x = scalar(@cfindResponses);

  if ($x == 0) {
    print LOG "Found no responses to 1001.a query \n";
    print LOG "That is a failure \n";
    return 1;
  }

  $rtnValue = 0;
  foreach $response(@cfindResponses) {
    print LOG "$response \n" if ($verbose);
    $x = "$MESA_TARGET/bin/dcm_print_element 0008 0061 1001/results/a/$response";
    $modValue = `$x`; chomp $modValue;
    print LOG "Modalities in Study = <$modValue>\n" if ($verbose);
    if ($modValue ne "SR") {
      print LOG "Modalities in Study = <$modValue> for response $response \n";
      print LOG "That constitutes a failure \n";
      $rtnValue = 1;
    }
  }

  print LOG "\n";

  return $rtnValue;
}

sub x_1001_2 {
  my $verbose = shift(@_);

  print LOG "External Report Repository Test 1001.2\n";
  print LOG "Looking for 0008 0061 Modalities in Study (by Patient ID and by Modalities in Study) \n";

  @ cfindResponses = rptrepos::find_responses("1001/results/b");

  $x = scalar(@cfindResponses);

  if ($x == 0) {
    print LOG "Found no responses to 1001.b query \n";
    print LOG "That is a failure \n";
    return 1;
  }

  $rtnValue = 0;
  foreach $response(@cfindResponses) {
    print LOG "$response \n" if ($verbose);
    $x = "$MESA_TARGET/bin/dcm_print_element 0008 0061 1001/results/b/$response";
    $modValue = `$x`; chomp $modValue;
    if ($modValue ne "SR") {
      print LOG "Modalities in Study = <$modValue> for response $response \n";
      print LOG "That constitutes a failure \n";
      $rtnValue = 1;
    }
  }

  print LOG "\n";

  return $rtnValue;
}

sub x_1001_3 {
  my $verbose = shift(@_);

  print LOG "External Report Repository Test 1001.3\n";
  print LOG "Looking for 0008 0061 Modalities in Study (Modalities in Study=CT) \n";

  @ cfindResponses = rptrepos::find_responses("1001/results/c");

  $x = scalar(@cfindResponses);

  if ($x == 0) {
    print LOG "Found no responses to 1001.c query \n";
    print LOG "That is the correct response\n";
    return 0;
  }

  print LOG "Found $x responses to 1001.c query; that is a failure \n";

  foreach $response(@cfindResponses) {
    print LOG "$response \n";
    $x = "$MESA_TARGET/bin/dcm_print_element 0008 0061 1001/results/a/$response";
    $modValue = `$x`; chomp $modValue;
    print LOG "Modalities in Study = <$modValue> for response $response \n";
    print LOG "That constitutes a failure \n";
  }

  print LOG "\n";

  return 1;
}

$verbose = grep /^-v/, @ARGV;

open LOG, ">1001/grade_1001.txt" or die "?!";
$diff = 0;

$diff += x_1001_1($verbose);
$diff += x_1001_2($verbose);
$diff += x_1001_3($verbose);

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1001/grade_1001.txt \n";

exit $diff;
