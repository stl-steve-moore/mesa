#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
use lib "../common/scripts";
require ordfil;
require mesa;

sub goodbye() {
  exit 1;
}

# Compare input HL7 messages with expected values.

sub x_1503_1 {
 print LOG "Order Filler 1503.1 \n";
 print LOG " Evaluating HL7 scheduling message to Image Mgr for P1/X1 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1001.hl7");
 print LOG "  Universal service ID: $x\n";

 $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/sched/103", "103.106.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1001.hl7",
		"ini_files/orm_sched_format.ini", "ini_files/orm_sched_compare.ini");
 print LOG "\n";
}

sub x_1503_4 {
 print LOG "Order Filler 103.3 \n";
 print LOG "Evaluating ADT A08 message to Image Mgr\n";

 $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/adt/103", "103.132.a08.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1002.hl7",
		"ini_files/adt_a08_format.ini", "ini_files/adt_a08_compare.ini");
 print LOG "\n";
}

sub x_1503_5 {
  print LOG "Order Filler 1503.5 \n";
  print LOG "Audit Record Messages \n";
  mesa::clear_syslog_files();
  mesa::extract_syslog_messages();
  my $xmlCount = mesa::count_syslog_xml_files();
  if ($xmlCount < 3) {
    print LOG "We expect at least 3 audit messages from your Order Filler.\n";
    print LOG " We received $xmlCount messages \n";
    print LOG " That is a failure; we will evaluate the messages received.\n";
    $diff += 1;
  }
  $diff += mesa::evaluate_all_xml_files();
}

### Main starts here

#if (scalar(@ARGV) < 1) {
#  print "This script requires one argument: <AE Title of your MPPS Mgr> \n";
#  exit 1;
#}

#$titleMPPSMgr = $ARGV[0];
$verbose = grep /^-/, @ARGV;
open LOG, ">1503/grade_1503.txt" or die "?!";
$diff = 0;

x_1503_1;
x_1503_4;
x_1503_5;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1503/grade_1503.txt \n";

exit $diff;
