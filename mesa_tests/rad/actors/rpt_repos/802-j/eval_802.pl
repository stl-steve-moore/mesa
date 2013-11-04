#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require rpt_repos;

sub goodbye() {
  exit 1;
}

# Examine the C-Find Responses

sub x_802_1 {
  print LOG "Report Repository 802-j.1 \n";
  print LOG "C-Find response, Study Level query for all studies\n";
  $diff += rpt_repos::evaluate_cfind_resp($verbose,
		"0020", "000D", "802-j/cfind_study_mask.txt",
		"802-j/q802a",
		"802-j/q802a_mesa",
		);
  print LOG "\n";
}

sub x_802_2 {
  print LOG "Report Repository 802-j.2 \n";
  print LOG "C-Find response, Study Level query for all studies\n";
  $diff += rpt_repos::evaluate_cfind_resp($verbose,
		"0020", "000D", "802-j/cfind_series_mask.txt",
		"802-j/q802b",
		"802-j/q802b_mesa",
		);
  print LOG "\n";
}

sub x_802_3 {
  print LOG "Report Repository 802-j.3 \n";
  print LOG "C-Find response, Study Level query for all studies\n";
  $diff += rpt_repos::evaluate_cfind_resp($verbose,
		"0020", "000D", "802-j/cfind_study_mask.txt",
		"802-j/q802c",
		"802-j/q802c_mesa",
		);
  print LOG "\n";
}

$verbose = grep /^-v/, @ARGV;
open LOG, ">802-j/grade_802.txt" or die "?!";
$diff = 0;

x_802_1;
x_802_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 802-j/grade_802.txt \n";

exit $diff;
