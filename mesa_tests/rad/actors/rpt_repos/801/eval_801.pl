#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require rpt_repos;

sub goodbye() {
  exit 1;
}

# Examine the C-Find Responses

sub x_801_1 {
  print LOG "Report Repository 801.1 \n";
  print LOG "C-Find response, Study Level query for all studies\n";
  $diff += rpt_repos::evaluate_cfind_resp($verbose,
		"0020", "000D", "801/cfind_study_mask.txt",
		"801/q801a",
		"801/q801a_mesa",
		);
  print LOG "\n";
}

sub x_801_2 {
  print LOG "Report Repository 801.2 \n";
  print LOG "C-Find response, Study Level query for all studies\n";
  $diff += rpt_repos::evaluate_cfind_resp($verbose,
		"0020", "000D", "801/cfind_study_mask.txt",
		"801/q801b",
		"801/q801b_mesa",
		);
  print LOG "\n";
}

sub x_801_3 {
  print LOG "Report Repository 801.3 \n";
  print LOG "C-Find response, Study Level query for all studies\n";
  $diff += rpt_repos::evaluate_cfind_resp($verbose,
		"0020", "000D", "801/cfind_study_mask.txt",
		"801/q801c",
		"801/q801c_mesa",
		);
  print LOG "\n";
}

$verbose = grep /^-v/, @ARGV;
open LOG, ">801/grade_801.txt" or die "?!";
$diff = 0;

x_801_1;
x_801_2;
x_801_3;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 801/grade_801.txt \n";

exit $diff;
