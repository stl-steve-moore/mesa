#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require rpt_repos;

sub goodbye() {
  exit 1;
}

# Examine the C-Find Responses

sub x_811_1 {
  print LOG "Report Repository 811-j.1 \n";
  print LOG "Evaluating the SR object retrieved from Report Repository \n";

  $diff += rpt_repos::evaluate_cmove_object($verbose,
		"../../msgs/sr/601-j/sr_601ct.dcm",
		"811-j/sr_811_req.txt");

  print LOG "\n";
}


$verbose = grep /^-v/, @ARGV;
open LOG, ">811-j/grade_811.txt" or die "?!";
$diff = 0;

x_811_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 811-j/grade_811.txt \n";

exit $diff;
