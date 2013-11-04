#!/usr/local/bin/perl -w

# This script evaluates ADT messages and Audit Record messages
# that should be sent by ADT system for test 1502.

use Env;
use lib "scripts";
require adt;

sub x_102_1 {
  print LOG "ADT 1502.1\n";
  $diff += adt::evaluate_hl7(
	$verbose,
	"../../msgs/adt/102", "102.102.a05.hl7",
	"$MESA_STORAGE/ordfil", "1001.hl7",
	"ini_files/adt_a05_format.ini", "ini_files/adt_a05_compare.ini");
  print LOG "\n";
}

sub x_102_2 {
  print LOG "ADT 1502.2\n";
  $diff += adt::evaluate_hl7(
	$verbose,
	"../../msgs/adt/102", "102.108.a01.hl7",
	"$MESA_STORAGE/ordfil", "1002.hl7",
	"ini_files/adt_a01_format.ini", "ini_files/adt_a01_compare.ini");
  print LOG "\n";
}

sub x_102_3 {
  print LOG "ADT 1502.3\n";
  $diff += adt::evaluate_hl7(
	$verbose,
	"../../msgs/adt/102", "102.136.a03.hl7",
	"$MESA_STORAGE/ordfil", "1003.hl7",
	"ini_files/adt_a03_format.ini", "ini_files/adt_a03_compare.ini");
  print LOG "\n";
}

sub x_1502_1 {
  print LOG "ADT 1502.1 \n";
  print LOG "Audit Record Messages \n";
  adt::clear_syslog_files();
  adt::extract_syslog_messages();
  my $xmlCount = adt::count_syslog_xml_files();
  if ($xmlCount < 7) {
    print LOG "We expect at least 7 audit messages from your ADT System.\n";
    print LOG " We received $xmlCount messages \n";
    print LOG " That is a failure; we will evaluate the messages received.\n";
    $diff += 1;
  }
  $diff += adt::evaluate_all_xml_files();
}


# Compare input ADT messages with expected values.

open LOG, ">1502/grade_1502.txt" or die "?!";
$diff = 0;
$verbose = grep /^-v/, @ARGV;

x_102_1;
x_102_2;
x_102_3;
x_1502_1;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";
print "Logs stored in 1502/grade_1502.txt \n";

exit $diff;
