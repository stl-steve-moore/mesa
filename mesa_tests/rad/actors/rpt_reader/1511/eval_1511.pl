#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
use lib "../common/scripts";
require rpt_reader;
require mesa;

sub goodbye() {
  exit 1;
}

sub x_1511_1 {
  print LOG "Rpt Reader 1511.1 \n";
  print LOG "Audit Record Messages \n";
  mesa::clear_syslog_files();
  mesa::extract_syslog_messages();
  my $xmlCount = mesa::count_syslog_xml_files();
  if ($xmlCount < 1) {
    print LOG "We expect at least 1 audit messages from your Report Reader System.\n";
    print LOG " We received $xmlCount messages \n";
    print LOG " That is a failure.\n";
    $diff += 1;
  }
  $diff += mesa::evaluate_all_xml_files();
}

open LOG, ">1511/grade_1511.txt" or die "?!";
$diff = 0;

x_1511_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1511/grade_1511.txt \n";

exit $diff;
