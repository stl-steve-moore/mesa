#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require ordfil;

sub goodbye() {
  exit 1;
}

# Subroutines that run the evaluation tests

sub x_142_1 {
 print LOG "CTX: Order Filler 142.1 \n";
 print LOG "CTX:  Evaluating HL7 scheduling message to Image Mgr for P22/X22 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1001.hl7");
 print LOG "CTX:   Universal service ID: $x\n";

 $diff += mesa::evaluate_ORM_O01_scheduling_Japanese(
		$logLevel,
		"../../msgs/sched/142/142.108.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7/1001.hl7");
 print LOG "\n";
}

# Evaluate MWL response to request for procedure P22.
sub x_142_3 {
 print LOG "CTX: Order Filler 142.3 \n";
 print LOG "CTX: Evaluating MWL response for procedure P22/X22 \n";

 $p22MWLFile     = ordfil::mwl_search_by_procedure_code($logLevel, "142/mwl_q1/test", "P22");
 $p22MWLFileMESA = ordfil::mwl_search_by_procedure_code($logLevel, "142/mwl_q1/mesa", "P22");

 if ($p22MWLFile eq "") {
   print LOG "ERR: Unable to locate MWL results for requested procedure P22\n";
   print LOG "ERR: You should examine the MWL results in 142/mwl_q1/test \n";
   $diff += 1;
 } elsif ($p22MWLFileMESA eq "") {
   print LOG "ERR: MESA MWL does not include requested procedure P22\n";
   print LOG "ERR:  This is an error in the test configuration/run \n";
   print LOG "ERR:  You should examine the MWL results in 142/mwl_q1/mesa \n";
   $diff += 1;
 } else {
   $diff += mesa::evaluate_one_mwl_resp_Japanese(
		$logLevel,
		$p22MWLFile,
		$p22MWLFileMESA);
 }

 print LOG "\n";
}

sub x_142_4 {
 print LOG "CTX: Order Filler 142.4 \n";
 print LOG "CTX:  Evaluating HL7 ORM Cancel message to Order Placer for P22/X22 \n";

 $diff += mesa::evaluate_ORM_O01_cancel_Japanese(
		$logLevel,
		"../../msgs/order/142/142.110.o01x.hl7",
		"$MESA_STORAGE/ordplc/1001.hl7");
 print LOG "\n";
}

# This evaluates the MWL query after a cancel. There should
# be no entries.
sub x_142_5 {
 print LOG "CTX: Order Filler 142.5 \n";
 print LOG "CTX: Evaluating MWL response for procedure P22/X22 \n";
 print LOG "CTX: This is after a cancel, so there should be no MWL entries\n";

 $p22MWLFile     = ordfil::mwl_search_by_procedure_code($logLevel, "142/mwl_q2/test", "P22");

 if ($p22MWLFile eq "") {
   print LOG "CTX: No MWL entries found; that is the expected result\n";
 } else {
   print LOG "ERR: We found MWL query results after the cancel event in 142/mwl_q2/test;\n";
   print LOG "ERR: The DSS/OF is supposed to remove these SPS from its worklist\n";
   print LOG "ERR: This is an error\n";
   $diff += 1;
 } 
 print LOG "\n";
}

sub x_142_6 {
 print LOG "CTX: Order Filler 142.6 \n";
 print LOG "CTX:  Evaluating HL7 Cancel message to Image Mgr for P22/X22 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1002.hl7");
 print LOG "CTX:   Universal service ID: $x\n";

 $diff += mesa::evaluate_ORM_O01_scheduling_Japanese(
		$logLevel,
		"../../msgs/sched/142/142.112.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7/1002.hl7");
 print LOG "\n";
}

sub x_142_7 {
 print LOG "CTX: Order Filler 142.7 \n";
 print LOG "CTX:  Evaluating HL7 ORM message to Order Placer for P21/X1 \n";

 $diff += mesa::evaluate_ORM_O01_Filler_Japanese(
		$logLevel,
		"../../msgs/order/142/142.116.o01.hl7",
		"$MESA_STORAGE/ordplc/1002.hl7");
 print LOG "\n";
}

sub x_142_8 {
 print LOG "CTX: Order Filler 142.8 \n";
 print LOG "CTX:  Evaluating HL7 scheduling message to Image Mgr for P1/X1 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1003.hl7");
 print LOG "CTX:   Universal service ID: $x\n";

 $diff += mesa::evaluate_ORM_O01_scheduling_Japanese(
		$logLevel,
		"../../msgs/sched/142/142.120.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7/1003.hl7");
 print LOG "\n";
}

### Main starts here

die "Usage: <log level: 1-4> <AE Title of your MPPS Mgr>" if (scalar(@ARGV) < 2);

$logLevel = $ARGV[0];
# $titleMPPSMgr = $ARGV[1];
open LOG, ">142/grade_142.txt" or die "?!";
$diff = 0;

x_142_1;	# First scheduling message
x_142_3;	# MWL response after P22 scheduled
x_142_4;	# Cancel message for P22 sent to Order Filler
x_142_5;	# MWL response after P22 cancelled
x_142_6;	# Cancel message sent to Image Manager
x_142_7;	# ORM message sent to Order Filler
x_142_8;	# Second scheduling message

# Left untested
# MWL query after P1 is scheduled
# MPPS forwarding for P1
# Image availabity query

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 142/grade_142.txt \n";

exit $diff;
