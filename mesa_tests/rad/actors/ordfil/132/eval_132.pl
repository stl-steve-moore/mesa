#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require ordfil;

use lib "../../../common/scripts";
require mesa_common;
require mesa_evaluate;

sub dummy {}

sub goodbye() {
  exit 1;
}

# Subroutines that run the evaluation tests

sub x_132_1 {
 print LOG "CTX: Order Filler 132.1 \n";
 print LOG "CTX:  Evaluating HL7 scheduling message to Image Mgr for P22/X22 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1001.hl7");
 print LOG "CTX:   Universal service ID: $x\n";

 $diff += mesa::evaluate_hl7 (
		$logLevel,
		$verbose,
		"../../msgs/sched/132", "132.106.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1001.hl7",
		"ini_files/orm_sched_format.ini", "ini_files/orm_sched_compare.ini");
 print LOG "\n";
}

sub x_132_2 {
 print LOG "CTX: Order Filler 132.2 \n";
 print LOG "CTX:  Evaluating HL7 scheduling message to Image Mgr for P22/X22 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1001.hl7");
 print LOG "CTX:   Universal service ID: $x\n";

 $diff += mesa::evaluate_ORM_scheduling (
		$logLevel,
		"../../msgs/sched/132/132.106.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7/1001.hl7");
 print LOG "\n";
}

# Evaluate MWL response to request for procedure P22.
sub x_132_3 {
 print LOG "CTX: Order Filler 132.3 \n";
 print LOG "CTX: Evaluating MWL response for procedure P22/X22 \n";

 $p22MWLFile     = ordfil::mwl_search_by_procedure_code($logLevel, "132/mwl_q1/test", "P22");
 $p22MWLFileMESA = ordfil::mwl_search_by_procedure_code($logLevel, "132/mwl_q1/mesa", "P22");

 if ($p22MWLFile eq "") {
   print LOG "ERR: Unable to locate MWL results for requested procedure P22\n";
   print LOG "ERR: You should examine the MWL results in 132/mwl_q1/test \n";
   $diff += 1;
 } elsif ($p22MWLFileMESA eq "") {
   print LOG "ERR: MESA MWL does not include requested procedure P22\n";
   print LOG "ERR:  This is an error in the test configuration/run \n";
   print LOG "ERR:  You should examine the MWL results in 132/mwl_q1/mesa \n";
   $diff += 1;
 } else {
   $diff += mesa::evaluate_one_mwl_resp(
		$logLevel,
		$p22MWLFile,
		$p22MWLFileMESA);
 }

 print LOG "\n";
}

sub x_132_4 {
 print LOG "CTX: Order Filler 132.4 \n";
 print LOG "CTX:  Evaluating HL7 ORM Cancel message to Order Placer for P22/X22 \n";

 $diff += mesa::evaluate_hl7 (
		$logLevel,
		$verbose,
		"../../msgs/order/132", "132.110.o01x.hl7",
		"$MESA_STORAGE/ordplc", "1001.hl7",
		"ini_files/orm_o01x_format.ini", "ini_files/orm_o01x_compare.ini");
 print LOG "\n";
}

# This evaluates the MWL query after a cancel. There should
# be no entries.
sub x_132_5 {
 print LOG "CTX: Order Filler 132.5 \n";
 print LOG "CTX: Evaluating MWL response for procedure P22/X22 \n";
 print LOG "CTX: This is after a cancel, so there should be no MWL entries\n";

 $p22MWLFile     = ordfil::mwl_search_by_procedure_code($logLevel, "132/mwl_q2/test", "P22");

 if ($p22MWLFile eq "") {
   print LOG "CTX: No MWL entries found; that is the expected result\n";
 } else {
   print LOG "ERR: We found MWL query results after the cancel event in 132/mwl_q2/test;\n";
   print LOG "ERR: The DSS/OF is supposed to remove these SPS from its worklist\n";
   print LOG "ERR: This is an error\n";
   $diff += 1;
 } 
 print LOG "\n";
}

sub x_132_6 {
 print LOG "CTX: Order Filler 132.6 \n";
 print LOG "CTX:  Evaluating HL7 Cancel message to Image Mgr for P22/X22 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1002.hl7");
 print LOG "CTX:   Universal service ID: $x\n";

 $diff += mesa::evaluate_hl7 (
		$logLevel,
		$verbose,
		"../../msgs/sched/132", "132.112.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1002.hl7",
		"ini_files/orm_sched_format.ini", "ini_files/orm_sched_compare.ini");
 print LOG "\n";
}

sub x_132_7 {
 print LOG "CTX: Order Filler 132.7 \n";
 print LOG "CTX:  Evaluating HL7 ORM message to Order Placer for P21/X1 \n";

 $diff += mesa::evaluate_hl7 (
		$logLevel,
		$verbose,
		"../../msgs/order/132", "132.116.o01.hl7",
		"$MESA_STORAGE/ordplc", "1002.hl7",
		"ini_files/orm_o01_format.ini", "ini_files/orm_o01_compare.ini");
 print LOG "\n";
}

sub x_132_8 {
 print LOG "CTX: Order Filler 132.8 \n";
 print LOG "CTX:  Evaluating HL7 scheduling message to Image Mgr for P1/X1 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1003.hl7");
 print LOG "CTX:   Universal service ID: $x\n";

 $diff += mesa::evaluate_hl7 (
		$logLevel,
		$verbose,
		"../../msgs/sched/132", "132.120.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1003.hl7",
		"ini_files/orm_sched_format.ini", "ini_files/orm_sched_compare.ini");
 print LOG "\n";
}

sub x_132_9 {
 print LOG "CTX: Order Filler 132.9 \n";
 print LOG "CTX:  Evaluating HL7 scheduling message to Image Mgr for P1/X1 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1003.hl7");
 print LOG "CTX:   Universal service ID: $x\n";

 $diff += mesa::evaluate_ORM_scheduling (
		$logLevel,
		"../../msgs/sched/132/132.120.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7/1003.hl7");
 print LOG "\n";
}

sub x_131_4 {
 print LOG "CTX: Order Filler 131.4 \n";
 print LOG "CTX Examing PPS messages for P1/X1/X1 forwarded to Image Mgr \n";

 $diff += mesa::evaluate_mpps_mpps_mgr(
		$logLevel,
		"$MESA_STORAGE/modality/T131",
		"$MESA_STORAGE/imgmgr/mpps/$titleMPPSMgr",
		"1"
		);
 print LOG "\n";
}

### Main starts here

die "Usage: <log level: 1-4> <AE Title of your MPPS Mgr>" if (scalar(@ARGV) < 2);

$logLevel = $ARGV[0];
$titleMPPSMgr = $ARGV[1];
$verbose = 0;
open LOG, ">132/grade_132.txt" or die "?!";

my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    132\n";
print LOG "CTX: Actor:   OF\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

x_132_1;	# First scheduling message
x_132_2;	# First scheduling message again
x_132_3;	# MWL response after P22 scheduled
x_132_4;	# Cancel message for P22 sent to Order Filler
x_132_5;	# MWL response after P22 cancelled
x_132_6;	# Cancel message sent to Image Manager
x_132_7;	# ORM message sent to Order Filler
x_132_8;	# Second scheduling message
x_132_9;	# Second scheduling message again

# Left untested
# MWL query after P1 is scheduled
# MPPS forwarding for P1
# Image availabity query

close LOG;

mesa_evaluate::copyLogWithXML("132/grade_132.txt", "132/mir_mesa_132.xml",
        $logLevel, "132", "OF", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "Test completed with zero errors means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 132/grade_132.txt and 132/mir_mesa_132.xml\n";
}

print "If you are submitting a result file to Kudu, submit 132/mir_mesa_132.xml\n\n";

