#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require ordfil;

sub goodbye() {
  exit 1;
}

# Compare input HL7 messages with expected values.

sub x_104_1 {
 print LOG "Order Filler 104.1 \n";
 print LOG " Evaluating HL7 scheduling message to Image Mgr for P4/X4 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1001.hl7");
 print LOG "  Universal service ID: $x\n";

 $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/sched/104", "104.106.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1001.hl7",
		"ini_files/orm_sched_format.ini", "ini_files/orm_sched_compare.ini");
 print LOG "\n";
}

sub x_104_4 {
 print LOG "Order Filler 104.4 \n";
 print LOG "Evaluating ORM O01 message to Order Placer\n";

 $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/order/104", "104.144.o01.hl7",
		"$MESA_STORAGE/ordplc", "1001.hl7",
		"ini_files/orm_o01_format.ini", "ini_files/orm_o01_compare.ini");
 print LOG "\n";
}

sub x_104_5 {
 print LOG "Order Filler 104.5 \n";
 print LOG " Evaluating HL7 scheduling message to Image Mgr for P1/X1 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1002.hl7");
 print LOG "  Universal service ID: $x\n";

 $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/sched/104", "104.148.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1002.hl7",
		"ini_files/orm_sched_format.ini", "ini_files/orm_sched_compare.ini");
 print LOG "\n";
}

sub x_104_8 {
 print LOG "Order Filler 104.8 \n";
 print LOG "Evaluating ADT A40 message to Image Manager\n";

 $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/adt/104", "104.184.a40.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1003.hl7",
		"ini_files/adt_a40_format.ini", "ini_files/adt_a40_filler_compare.ini");
 print LOG "\n";
}

# Evaluate MWL responses

# Evaluate response to request for procedure P1.
sub x_104_2 {
 print LOG "Order Filler 104.2 \n";
 print LOG "Evaluating MWL response for procedure P1/X1 \n";

 $p1MWLFile = ordfil::mwl_find_matching_procedure_code("$dirBase" . "mwl_p1", "P1");
 $p1MWLFileMESA = ordfil::mwl_find_matching_procedure_code("$dirBase" . "mwl_p1_mesa", "P1");

 if ($p1MWLFile eq "") {
   print LOG "Unable to locate MWL results for requested procedure P1\n";
   print LOG " You should examine the MWL results in 104/mwl_p1 \n";
   $diff += 1;
 } elsif ($p1MWLFileMESA eq "") {
   print LOG "MESA MWL does not include requested procedure P1\n";
   print LOG " This is an error in the test configuration/run \n";
   print LOG " You should examine the MWL results in 104/mwl_p1_mesa \n";
   $diff += 1;
 } else {
   $diff += ordfil::evaluate_one_mwl_resp(
		$verbose,
		"$dirBase" . "mwl_p1" . "$separator" . "$p1MWLFile",
		"$dirBase" . "mwl_p1_mesa" . "$separator" . "$p1MWLFileMESA");
 }

 print LOG "\n";
}

### Main starts here

die "Order Filler test 104 is retired as of May, 2003.\n";

if (scalar(@ARGV) < 1) {
  print "This script requires one argument: <AE Title of your MPPS Mgr> \n";
  exit 1;
}

#$titleMPPSMgr = $ARGV[0];
$verbose = grep /^-/, @ARGV;
open LOG, ">104/grade_104.txt" or die "?!";
$diff = 0;

if ($MESA_OS eq "WINDOWS_NT") {
  $dirBase = "104\\";
  $separator = "\\";
} else {
  $dirBase = "104/";
  $separator = "/";
}

x_104_1;
#x_103_2;
#x_103_3;
x_104_4;
x_104_5;
x_104_8;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 104/grade_104.txt \n";

exit $diff;
