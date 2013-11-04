#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
use lib "../common/scripts";
require ordplc;
require mesa;

sub x_1503_1 {
  print LOG "Order Placer 1503.1\n";
  $diff += ordplc::evaluate_hl7(
		$verbose,
		"../../msgs/order/103", "103.104.o01.hl7",
		"$MESA_STORAGE/ordfil", "1001.hl7",
		"ini_files/orm_o01_format.ini", "ini_files/orm_o01_compare.ini");
  print LOG "\n";
}

sub x_1503_2 {
  print LOG "Order Placer 1503.2 \n";
  print LOG "Audit Record Messages \n";
  mesa::clear_syslog_files();
  mesa::extract_syslog_messages();
  my $xmlCount = mesa::count_syslog_xml_files();
  if ($xmlCount < 2) {
    print LOG "We expect at least 2 audit messages from your Order Placer.\n";
    print LOG " We received $xmlCount messages \n";
    print LOG " That is a failure; we will evaluate the messages received.\n";
    $diff += 1;
  }
  $diff += mesa::evaluate_all_xml_files();
}


open LOG, ">1503/grade_1503.txt" or die "?!";
$diff = 0;
$verbose = grep /^-v/, @ARGV;

x_1503_1;
x_1503_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 1503/grade_1503.txt \n";

exit $diff;
