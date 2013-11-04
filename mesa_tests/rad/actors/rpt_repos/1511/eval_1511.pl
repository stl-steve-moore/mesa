#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
use lib "../common/scripts";
require rpt_repos;
require mesa;

sub goodbye() {
  exit 1;
}

# Examine the C-Find Responses

sub x_1511_1 {
  print LOG "Report Repository 1511.1 \n";
  print LOG "C-Find response, Study Level query for all studies\n";
  $diff += rpt_repos::evaluate_cfind_resp($verbose,
		"0020", "000D", "801/cfind_study_mask.txt",
		"1511/q1511a",
		"1511/q1511a_mesa",
		);
  print LOG "\n";
}

sub x_1511_2 {
  print LOG "Report Repository 1503.2 \n";
  print LOG "Audit Record Messages \n";
  mesa::clear_syslog_files();
  mesa::extract_syslog_messages();
  my $xmlCount = mesa::count_syslog_xml_files();
  if ($xmlCount < 1) {
    print LOG "We expect at least 1 audit messages from your Report Repository.\n";
    print LOG " We received $xmlCount messages \n";
    print LOG " That is a failure; we will evaluate the messages received.\n";
    $diff += 1;
  }
  $diff += mesa::evaluate_all_xml_files();
}

$verbose = grep /^-v/, @ARGV;
open LOG, ">1511/grade_1511.txt" or die "?!";
$diff = 0;

x_1511_1;
x_1511_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1511/grade_1511.txt \n";

exit $diff;
