#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require ordfil;

sub goodbye() {
  exit 1;
}

# Compare input HL7 messages with expected values.

sub x_102_1 {
 print LOG "Order Filler 102.1 \n";
 print LOG " Evaluating HL7 scheduling message to Image Mgr for P1/X1 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1001.hl7");
 print LOG "  Universal service ID: $x\n";

 $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/sched/102", "102.106.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1001.hl7",
		"ini_files/orm_sched_format_preadmit.ini",
		"ini_files/orm_sched_compare_preadmit.ini");
 print LOG "\n";
}

sub x_102_4 {
 print LOG "Order Filler 102.4 \n";
 print LOG "Evaluating HL7 scheduling message to Image Mgr for P21/X21 \n";
# $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1002.hl7");
# print LOG " Universal service ID: $x\n";

 $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/sched/102", "102.124.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1002.hl7",
		"ini_files/orm_sched_format.ini", "ini_files/orm_sched_compare.ini");
 print LOG "\n";
}


sub x_102_6 {
 print LOG "Order Filler 102.6 \n";
 print LOG "Evaluating HL7 ORM message to Order Placer to cancel P21/X21 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/ordplc", "1001.hl7");
 print LOG " Universal service ID: $x\n";

 $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/order/102", "102.126.o01x.hl7",
		"$MESA_STORAGE/ordplc", "1001.hl7",
		"ini_files/orm_o01x_format.ini", "ini_files/orm_o01x_compare.ini");
 print LOG "\n";
}

sub x_102_7 {
 print LOG "Order Filler 102.7 \n";
 print LOG "Evaluating HL7 ORM message to Image Mgr to cancel P21/X21 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1003.hl7");
 print LOG " Universal service ID: $x\n";

 $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/sched/102", "102.128.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1003.hl7",
		"ini_files/orm_sched_format.ini", "ini_files/orm_sched_compare.ini");
 print LOG "\n";
}

sub x_102_9 {
 print LOG "Order Filler 102.9 \n";
 print LOG "Evaluating HL7 ORM message to Order Placer to order P22/X22 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/ordplc", "1002.hl7");
 print LOG " Universal service ID: $x\n";

 $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/order/102", "102.130.o01.hl7",
		"$MESA_STORAGE/ordplc", "1002.hl7",
		"ini_files/orm_o01_format.ini", "ini_files/orm_o01_compare.ini");
 print LOG "\n";
}

sub x_102_10 {
 print LOG "Order Filler 102.10 \n";
 print LOG "Evaluating HL7 scheduling message to Image Mgr for P22/X22 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1004.hl7");
 print LOG " Universal service ID: $x\n";

 $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/sched/102", "102.134.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1004.hl7",
		"ini_files/orm_sched_format.ini", "ini_files/orm_sched_compare.ini");
 print LOG "\n";
}


sub x_102_12 {
 print LOG "Order Filler 102.12 \n";
 print LOG "Evaluating HL7 ADT message to Image Mgr to discharge Brown \n";

 $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/adt/102", "102.138.a03.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1005.hl7",
		"ini_files/adt_a03_format.ini", "ini_files/adt_a03_compare.ini");
 print LOG "\n";
}

# Evaluate MWL responses

# Evaluate response to request for procedure P1.
sub x_102_2 {
 print LOG "Order Filler 102.2 \n";
 print LOG "Evaluating MWL response for procedure P1/X1 \n";

 $p1MWLFile = ordfil::mwl_find_matching_procedure_code("$dirBase" . "mwl_p1", "P1");
 $p1MWLFileMESA = ordfil::mwl_find_matching_procedure_code("$dirBase" . "mwl_p1_mesa", "P1");

 if ($p1MWLFile eq "") {
   print LOG "Unable to locate MWL results for requested procedure P1\n";
   print LOG " You should examine the MWL results in 102/mwl_p1 \n";
   $diff += 1;
 } elsif ($p1MWLFileMESA eq "") {
   print LOG "MESA MWL does not include requested procedure P1\n";
   print LOG " This is an error in the test configuration/run \n";
   print LOG " You should examine the MWL results in 102/mwl_p1_mesa \n";
   $diff += 1;
 } else {
   $diff += ordfil::evaluate_one_mwl_resp(
		$verbose,
		"$dirBase" . "mwl_p1" . "$separator" . "$p1MWLFile",
		"$dirBase" . "mwl_p1_mesa" . "$separator" . "$p1MWLFileMESA");
 }

 print LOG "\n";
}

# Evaluate response to request for procedure P21.
sub x_102_5 {
 print LOG "Order Filler 102.5 \n";
 print LOG "Evaluating MWL response for procedure P21/X21 \n";

 $p21MWLFile = ordfil::mwl_find_matching_procedure_code("$dirBase" . "mwl_p21", "P21");
 $p21MWLFileMESA = ordfil::mwl_find_matching_procedure_code("$dirBase" . "mwl_p21_mesa", "P21");

 if ($p21MWLFile eq "") {
   print LOG "Unable to locate MWL results for requested procedure P21\n";
   print LOG " You should examine the MWL results in 102/mwl_p21 \n";
   $diff += 1;
 } elsif ($p21MWLFileMESA eq "") {
   print LOG "MESA MWL does not include requested procedure P21\n";
   print LOG " This is an error in the test configuration/run \n";
   print LOG " You should examine the MWL results in 102/mwl_p21_mesa \n";
   $diff += 1;
 } else {
   $diff += ordfil::evaluate_one_mwl_resp(
		$verbose,
		"$dirBase" . "mwl_p21" . "$separator" . "$p21MWLFile",
		"$dirBase" . "mwl_p21_mesa" . "$separator" . "$p21MWLFileMESA");
 }

 print LOG "\n";
}

sub x_102_8 {
 print LOG "Order Filler 102.8 \n";
# This is done as part of 102_11;
}

# Evaluate response to request for procedure P22.
sub x_102_11 {
 print LOG "Order Filler 102.11 \n";
 $p22MWLFile = ordfil::mwl_find_matching_procedure_code("$dirBase" . "mwl_p22", "P22");
 $p22MWLFileMESA = ordfil::mwl_find_matching_procedure_code("$dirBase" . "mwl_p22_mesa", "P22");

 if ($p22MWLFile eq "") {
   print LOG "Unable to locate MWL results for requested procedure P22\n";
   print LOG " You should examine the MWL results in 102/mwl_p22 \n";
   $diff += 1;
 } elsif ($p22MWLFileMESA eq "") {
   print LOG "MESA MWL does not include requested procedure P22\n";
   print LOG " This is an error in the test configuration/run \n";
   print LOG " You should examine the MWL results in 102/mwl_p22_mesa \n";
   $diff += 1;
 } else {
   $diff += ordfil::evaluate_one_mwl_resp(
		$verbose,
		"$dirBase" . "mwl_p22" . "$separator" . "$p22MWLFile",
		"$dirBase" . "mwl_p22_mesa" . "$separator" . "$p22MWLFileMESA");
 }

 print LOG "\n";

# Now see if the request for P21 was actually cancelled.

 print LOG "Checking your MWL results to see if P21/X21 is removed from MWL\n";

 $p21xMWLFile = ordfil::mwl_find_matching_procedure_code("$dirBase" . "mwl_p22", "P21");
 if ($p21xMWLFile eq "") {
   print LOG " Good, P21/X21 procedure no longer in your MWL\n";
 } else {
   $diff += 1;
   print LOG " We found an MWL entry for P21/X21 in your MWL.\n";
   print LOG " That should have been removed when P21 was cancelled.\n";

 }
}

sub x_102_3 {
 print LOG "Order Filler 102.3 \n";
 print LOG "Examing PPS messages for P1/X1/X11 forwarded to Image Mgr \n";

 $diff += ordfil::evaluate_mpps_v2(
		$verbose,
		"$MESA_STORAGE/modality/P11",
		"$MESA_STORAGE/imgmgr/mpps/$titleMPPSMgr",
		"1"
		);
 print LOG "\n";
}

### Main starts here

die "Order Filler test 102 is retired as of May, 2003.\n";

if (scalar(@ARGV) < 1) {
  print "This script requires one argument: <AE Title of your MPPS Mgr> \n";
  exit 1;
}

$titleMPPSMgr = $ARGV[0];
$verbose = grep /^-/, @ARGV;
open LOG, ">102/grade_102.txt" or die "?!";
$diff = 0;

if ($MESA_OS eq "WINDOWS_NT") {
  $dirBase = "102\\";
  $separator = "\\";
} else {
  $dirBase = "102/";
  $separator = "/";
}

x_102_1;
x_102_2;
x_102_3;
x_102_4;
x_102_5;
x_102_6;
x_102_7;
x_102_8;
x_102_9;
x_102_10;
x_102_11;
x_102_12;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 102/grade_102.txt \n";

exit $diff;
