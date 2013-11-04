#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require ordfil;

sub goodbye() {
  exit 1;
}

sub x_100_1 {
 print LOG "CTX: Order Filler 100.1 \n";
 print LOG "CTX Examing MWL reponse to first MWL query\n";

  $p1MWLFile =     ordfil::mwl_find_matching_procedure_code("100/mwl_q1/test", "P1");
  $p1MWLFileMESA = ordfil::mwl_find_matching_procedure_code("100/mwl_q1/mesa", "P1");

  if ($p1MWLFile eq "") {
    print LOG "ERR: Unable to locate MWL results for requested procedure P1\n";
    print LOG "ERR:  You should examine the MWL results in 100/mwl_q1/test \n";
    $diff += 1;
 } elsif ($p1MWLFileMESA eq "") {
    print LOG "ERR: MESA MWL does not include requested procedure P1\n";
    print LOG "ERR:  This is an error in the test configuration/run \n";
    print LOG "ERR:  You should examine the MWL results in 100/mwl_q1/mesa \n";
    $diff += 1;
  } else {
    $diff += mesa::evaluate_one_mwl_resp(
                $logLevel,
                "100/mwl_q1/test/$p1MWLFile",
                "100/mwl_q1/mesa/$p1MWLFileMESA");
  }

  print LOG "\n";
}

sub x_100_2 {
 print LOG "CTX: Order Filler 100.2 \n";
 print LOG "CTX Examing MWL reponse to second MWL query\n";

  $p1MWLFile =     ordfil::mwl_find_matching_procedure_code("100/mwl_q2/test", "P22");
  $p1MWLFileMESA = ordfil::mwl_find_matching_procedure_code("100/mwl_q2/mesa", "P22");

  if ($p1MWLFile eq "") {
    print LOG "ERR: Unable to locate MWL results for requested procedure P22\n";
    print LOG "ERR:  You should examine the MWL results in 100/mwl_q2 \n";
    $diff += 1;
 } elsif ($p1MWLFileMESA eq "") {
    print LOG "ERR: MESA MWL does not include requested procedure P22\n";
    print LOG "ERR:  This is an error in the test configuration/run \n";
    print LOG "ERR:  You should examine the MWL results in 100/mwl_q2_mesa \n";
    $diff += 1;
  } else {
    $diff += mesa::evaluate_one_mwl_resp(
                $logLevel,
                "100/mwl_q2/test/$p1MWLFile",
                "100/mwl_q2/mesa/$p1MWLFileMESA");
  }

  print LOG "\n";
}

sub x_100_3 {
 print LOG "Order Filler 100.3 \n";
 print LOG " Evaluating HL7 scheduling message to Image Mgr for P2/X2 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1001.hl7");
 print LOG "  Universal service ID: $x\n";

 $diff += mesa::evaluate_hl7 (
		$logLevel,
		$verbose,
		"../../msgs/sched/100", "100.118.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1001.hl7",
		"ini_files/orm_sched_format.ini", "ini_files/orm_sched_compare.ini");
 print LOG "\n";
}

sub x_100_4 {
 print LOG "CTX: Order Filler 100.4 \n";
 print LOG "CTX:  Evaluating HL7 scheduling message to Image Mgr for P2/X2 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1001.hl7");
 print LOG "  Universal service ID: $x\n";

 $diff += mesa::evaluate_ORM_scheduling_post_procedure (
		$logLevel,
		"../../msgs/sched/100/100.118.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7/1001.hl7",
		"$MESA_STORAGE/modality/T100");

 print LOG "\n";
}


sub x_100_5 {
 print LOG "CTX: Order Filler 100.5 \n";
 print LOG "CTX: Evaluating ADT A08 message to Image Manager\n";

 $diff += mesa::evaluate_hl7 (
		$logLevel,
		$verbose,
		"../../msgs/adt/100", "100.122.a08.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1002.hl7",
		"ini_files/adt_a08_format.ini", "ini_files/adt_a08_compare.ini");
 print LOG "\n";
}


### Main starts here

die "Usage: <log level: 1-4> <AE Title of your MPPS Mgr>" if (scalar(@ARGV) < 2);

$logLevel = $ARGV[0];
#$titleMPPSMgr = $ARGV[1];
$verbose = 0;
open LOG, ">100/grade_100.txt" or die "?!";
$diff = 0;


#x_100_1;
x_100_2;
#x_100_3;
#x_100_4;
#x_100_5;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 100/grade_100.txt \n";

exit $diff;
