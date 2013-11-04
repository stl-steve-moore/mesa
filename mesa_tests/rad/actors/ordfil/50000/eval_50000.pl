#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
use lib "../../../common/scripts";
require ordfil;
require mesa_common;

sub goodbye() {
  exit 1;
}

# Compare input HL7 messages with expected values.

sub x_50000_1 {
 print LOG "\nCTX: Order Filler 50000.1 \n";
 print LOG "CTX:  Evaluating HL7 scheduling message to Image Mgr for EYE-200 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1001.hl7");
 print LOG "CTX:   Universal service ID: $x\n";

 $diff += mesa::evaluate_hl7 (
		$logLevel,
		$verbose,
		"../../msgs/sched/50000", "50000.140.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1001.hl7",
		"ini_files/orm_sched_format.ini", "ini_files/orm_sched_compare.ini");
 print LOG "\n";
}

sub x_50000_2 {
 print LOG "CTX: Order Filler 50000.2 \n";
 print LOG "CTX:  Evaluating HL7 scheduling message to Image Mgr for EYE-200 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1001.hl7");
 print LOG "CTX:   Universal service ID: $x\n";

 $diff += mesa::evaluate_ORM_scheduling (
		$logLevel,
		"../../msgs/sched/50000/50000.140.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7/1001.hl7");
 print LOG "\n";
}

# Evaluate response to request for procedure P1.
sub x_50000_3 {
 print LOG "CTX: Order Filler 50000.3 \n";
 print LOG "CTX: Evaluating MWL response for procedure EYE-200 \n";

 $p1MWLFile     = ordfil::mwl_search_by_procedure_code($logLevel, "50000/mwl_q1/test", "EYE-200");
 $p1MWLFileMESA = ordfil::mwl_search_by_procedure_code($logLevel, "50000/mwl_q1/mesa", "EYE-200");

 if ($p1MWLFile eq "") {
   print LOG "ERR: Unable to locate MWL results for requested procedure P1\n";
   print LOG "ERR: You should examine the MWL results in 50000/mwl_q1/test \n";
   $diff += 1;
 } elsif ($p1MWLFileMESA eq "") {
   print LOG "ERR: MESA MWL does not include requested procedure EYE-200\n";
   print LOG "ERR:  This is an error in the test configuration/run \n";
   print LOG "ERR:  You should examine the MWL results in 50000/mwl_q1/mesa \n";
   $diff += 1;
 } else {
   $diff += mesa::evaluate_one_mwl_resp(
		$logLevel,
		$p1MWLFile,
		$p1MWLFileMESA);
   $diff += mesa::evaluate_one_mwl_resp_eye_care(
		$logLevel,
		$p1MWLFile,
		$p1MWLFileMESA);
 }

 print LOG "\n";
}

sub x_50000_4 {
 print LOG "\nCTX: Order Filler 50000.4 \n";
 print LOG "CTX Examing PPS messages for EYE-200/EYE_PC_200 forwarded to Image Mgr \n";

 $diff += mesa::evaluate_mpps_mpps_mgr(
		$logLevel,
		"$MESA_STORAGE/modality/T50000",
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
open LOG, ">50000/grade_50000.txt" or die "?!";
my $mesaVersion = mesa_get::getMESAVersion();
my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
print LOG "CTX: $mesaVersion \n";
print LOG "CTX: current date/time $date $timeToMinute\n";
print LOG "CTX: Log level $logLevel\n";

$diff = 0;

x_50000_1;
x_50000_2;
x_50000_3;
x_50000_4;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 50000/grade_50000.txt \n";

exit $diff;
