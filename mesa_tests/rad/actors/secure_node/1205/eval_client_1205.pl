#!/usr/local/bin/perl -w

# Evaluation script for Secure Node (client) test 1205.

use Env;

use lib "scripts";
require secure;

sub goodbye() {
  exit 1;
}

sub x_1205_1 {
  print LOG "Secure Node Test 1205.1 \n";
  print LOG "Audit Record Messages \n";
  secure::clear_syslog_files();
  secure::extract_syslog_messages();
  my $xmlCount = secure::count_syslog_xml_files();
  if ($xmlCount < 3) {
    print LOG "This test requires at least 3 audit records.\n";
    print LOG " Your system sent $xmlCount messages.\n";
    print LOG " This is a failure; please repeat the test.\n";
    $diff += 1;
    return;
  }
  $diff += secure::evaluate_all_xml_files();
}

# Main starts here

open LOG, ">1205/grade_client_1205.txt" or die "?!";
$diff = 0;

x_1205_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1205/grade_client_1205.txt \n";

exit $diff;
