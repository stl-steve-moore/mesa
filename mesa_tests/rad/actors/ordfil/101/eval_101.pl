#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require ordfil;

sub goodbye() {
  exit 1;
}

die "Order Filler test 101 is retired as of May, 2003.\n";

if (scalar(@ARGV) < 1) {
  print "This script requires one argument: <AE Title of your MPPS Mgr> \n";
  exit 1;
}


$titleMPPSMgr = $ARGV[0];
$verbose = grep /^-v/, @ARGV;

open LOG, ">101/grade_101.txt" or die "?!";
$diff = 0;

# Compare input HL7 messages with expected values.

sub x_101_1 {
  print LOG "Order Filler 101.1\n";
  $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/sched/101", "101.106.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1001.hl7",
		"ini_files/orm_sched_format.ini", "ini_files/orm_sched_compare.ini");
  print LOG "\n";
}

sub x_101_4 {
  print LOG "Order Filler 101.4\n";
  $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/adt/101", "101.128.a06.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1002.hl7",
		"ini_files/adt_a06_format.ini", "ini_files/adt_a06_compare.ini");
  print LOG "\n";
}

sub x_101_5 {
  print LOG "Order Filler 101.5\n";
  $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/adt/101", "101.132.a03.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1003.hl7",
		"ini_files/adt_a03_format.ini", "ini_files/adt_a03_compare.ini");
  print LOG "\n";
}

sub x_101_7 {
  print LOG "Order Filler 101.7\n";
  $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/adt/101", "101.161.a40.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1004.hl7",
		"ini_files/adt_a40_format.ini", "ini_files/adt_a40_filler_compare.ini");
  print LOG "\n";
}

sub x_101_8 {
  print LOG "Order Filler 101.8\n";
  $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/order/101", "101.162.o01.hl7",
		"$MESA_STORAGE/ordplc", "1001.hl7",
		"ini_files/orm_o01_format.ini", "ini_files/orm_o01_compare.ini");
  print LOG "\n";
}

sub x_101_9 {
  print LOG "Order Filler 101.9\n";
  $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/sched/101", "101.165.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1005.hl7",
		"ini_files/orm_sched_format.ini", "ini_files/orm_sched_compare.ini");
  print LOG "\n";
}

sub x_101_10 {
  print LOG "Order Filler 101.10\n";
  $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/adt/101", "101.168.a40.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1006.hl7",
		"ini_files/adt_a40_format.ini", "ini_files/adt_a40_compare.ini");
  print LOG "\n";
}

sub x_101_11 {
  print LOG "Order Filler 101.11\n";
  $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/sched/101", "101.184.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1007.hl7",
		"ini_files/orm_sched_format.ini", "ini_files/orm_sched_compare.ini");
  print LOG "\n";
}

sub x_101_13 {
  print LOG "Order Filler 101.13\n";
  $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/sched/101", "101.190.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1008.hl7",
		"ini_files/orm_sched_format.ini", "ini_files/orm_sched_compare.ini");
  print LOG "\n";
}

sub x_101_14 {
  print LOG "Order Filler 101.14\n";
  $diff += ordfil::evaluate_hl7 (
		$verbose,
		"../../msgs/sched/101", "101.194.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1009.hl7",
		"ini_files/orm_sched_format.ini", "ini_files/orm_sched_compare.ini");
  print LOG "\n";
}

# Section of MWL response tests

# Evaluate response to request for procedure P1.
sub x_101_2 {
 print LOG "Order Filler 101.2 \n";
 print LOG "Evaluating MWL response for procedure P1/X1 \n";

 $p1MWLFile = ordfil::mwl_find_matching_procedure_code("$dirBase" . "mwl_p1", "P1");
 $p1MWLFileMESA = ordfil::mwl_find_matching_procedure_code("$dirBase" . "mwl_p1_mesa", "P1");

 if ($p1MWLFile eq "") {
   print LOG "Unable to locate MWL results for requested procedure P1\n";
   print LOG " You should examine the MWL results in 101/mwl_p1 \n";
   $diff += 1;
 } elsif ($p1MWLFileMESA eq "") {
   print LOG "MESA MWL does not include requested procedure P1\n";
   print LOG " This is an error in the test configuration/run \n";
   print LOG " You should examine the MWL results in 101/mwl_p1_mesa \n";
   $diff += 1;
 } else {
   $diff += ordfil::evaluate_one_mwl_resp(
                $verbose,
                "$dirBase" . "mwl_p1" . "$separator" . "$p1MWLFile",
                "$dirBase" . "mwl_p1_mesa" . "$separator" . "$p1MWLFileMESA");
 }

 print LOG "\n";
}

sub x_101_12 {
  print LOG "Order Filler 101.12 \n";
  print LOG "\nSearching for requested procedure P21 \n";
  $mwlFile = ordfil::mwl_find_matching_procedure_code ("$dirBase" . "mwl_p21", "P21");
  if ($mwlFile eq "") {
    $diff += 1;
    print LOG "Found no matching request procedure code: P21 \n";
    print LOG " That is an error.\n";
  } else {
    print LOG "Found worklist entry for P21 as expected \n";
  }
  print LOG "\n";
}

sub x_101_15 {
  print LOG "Order Filler 101.15 \n";
  print LOG "\nSearching for requested procedure P22 \n";
  $mwlFile = ordfil::mwl_find_matching_procedure_code ("$dirBase" . "mwl_p22", "P22");
  if ($mwlFile eq "") {
    $diff += 1;
    print LOG "Found no matching request procedure code: P22 \n";
    print LOG " That is an error.\n";
  } else {
    print LOG "Found worklist entry for P22 as expected \n";
  }

  print LOG "Checking your MWL results to see if P21/X21 is removed from MWL\n";

  $p21xMWLFile = ordfil::mwl_find_matching_procedure_code("$dirBase" . "mwl_p22", "P21");
  if ($p21xMWLFile eq "") {
    print LOG " Good, P21/X21 procedure no longer in your MWL\n";
  } else {
    $diff += 1;
    print LOG " We found an MWL entry for P21/X21 in your MWL.\n";
    print LOG " That should have been removed when P21 was cancelled.\n";
  }

  print LOG "\n";
}


# Section of MPPS tests.

sub x_101_3 {
  print LOG "Order Filler 101.3 \n";
  $diff += ordfil::evaluate_mpps_v2(
		$verbose,
		"$MESA_STORAGE/modality/P1",
		"$MESA_STORAGE/imgmgr/mpps/$titleMPPSMgr",
		"1"
		);
  print LOG "\n";
}

sub x_101_6 {
  print LOG "Order Filler 101.6 \n";
  $diff += ordfil::evaluate_mpps_v2(
		$verbose,
		"$MESA_STORAGE/modality/P2",
		"$MESA_STORAGE/imgmgr/mpps/$titleMPPSMgr",
		"2"
		);
  print LOG "\n";
}

sub x_101_16 {
  print LOG "Order Filler 101.16 \n";
  $diff += ordfil::evaluate_image_avail("$MESA_STORAGE/imgmgr/queries");

  print LOG "\n";
}

sub a12 {
  print LOG "\nSearching MWL responses after P21 was canceled.\n";
  print LOG "Your MWL responses should not include an entry for P21.\n";
  $mwlFile = ordfil::mwl_find_matching_procedure_code ("mwl_P22", "P21");
  if ($mwlFile ne "") {
    $diff += 1;
    print LOG "Found an MWL entry for Requested Procedure P21 in $mwlFile.\n";
    print LOG "This entry should have been removed from MWL after cancel.\n";
  } else {
    print LOG "Your MWL correctly omits the entry for Requested Procedure P21.\n";
  }
}

if ($MESA_OS eq "WINDOWS_NT") {
  $dirBase = "101\\";
  $separator = "\\";
} else {
  $dirBase = "101/";
  $separator = "/";
}

x_101_1;
x_101_2;
x_101_3;
x_101_4;
x_101_5;
x_101_6;
x_101_7;
x_101_8;
x_101_9;
x_101_10;
x_101_11;
# MWL results for P21
x_101_12;
x_101_13;
x_101_14;
# MWL results for P21
x_101_15;
x_101_16;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 101/grade_101.txt \n";

exit $diff;
