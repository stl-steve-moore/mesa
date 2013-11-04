#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require rpt_repos;

sub goodbye() {
  exit 1;
}

# Examine the C-Find Responses

sub x_804_1 {
  print LOG "Report Repository 804.1 \n";
  print LOG "C-Find response, SOP Instance Level query\n";
  $diff += rpt_repos::evaluate_cfind_resp($verbose,
		"0008", "0018", "804/cfind_sopins_mask.txt",
		"804/q804a",
		"804/q804a_mesa",
		);
  print LOG "\n";
}


$verbose = grep /^-v/, @ARGV;
open LOG, ">804/grade_804.txt" or die "?!";
$diff = 0;

x_804_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 804/grade_804.txt \n";

exit $diff;
