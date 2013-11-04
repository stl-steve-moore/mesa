#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require ordfil;

sub goodbye() {
  exit 1;
}

# Compare input HL7 messages with expected values.

sub x_141_1 {
 print LOG "CTX: Order Filler 141.1 \n";
 print LOG "CTX:  Evaluating HL7 scheduling message to Image Mgr for P1/X1 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1001.hl7");
 print LOG "CTX:   Universal service ID: $x\n";

 $diff += mesa::evaluate_ORM_O01_scheduling_Japanese (
		$logLevel,
		"../../msgs/sched/141/141.108.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7/1001.hl7");
 print LOG "\n";
}


# Evaluate response to request for procedure P1.
sub x_141_2 {
 print LOG "CTX: Order Filler 141.2 \n";
 print LOG "CTX: Evaluating MWL response for procedure P1/X1 \n";

 $p1MWLFile     = ordfil::mwl_search_by_procedure_code($logLevel, "141/mwl_q1/test", "P1");
 $p1MWLFileMESA = ordfil::mwl_search_by_procedure_code($logLevel, "141/mwl_q1/mesa", "P1");

 if ($p1MWLFile eq "") {
   print LOG "ERR: Unable to locate MWL results for requested procedure P1\n";
   print LOG "ERR: You should examine the MWL results in 141/mwl_q1/test \n";
   $diff += 1;
 } elsif ($p1MWLFileMESA eq "") {
   print LOG "ERR: MESA MWL does not include requested procedure P1\n";
   print LOG "ERR:  This is an error in the test configuration/run \n";
   print LOG "ERR:  You should examine the MWL results in 141/mwl_q1/mesa \n";
   $diff += 1;
 } else {
   $diff += mesa::evaluate_one_mwl_resp_Japanese(
		$logLevel,
		$p1MWLFile,
		$p1MWLFileMESA);
 }

 print LOG "\n";
}

sub x_131_4 {
 print LOG "CTX: Order Filler 131.4 \n";
 print LOG "CTX: Evaluating MWL response for procedure P1/X1 (Study Instance UID) \n";
 print LOG "REF: See TF Vol II, Appendix A, Table A-1, Note IHE-23 \n" if ($logLevel >= 4);

 $p1MWLFile     = ordfil::mwl_search_by_procedure_code($logLevel, "131/mwl_q1/test", "P1");

 if ($p1MWLFile eq "") {
   print LOG "ERR: Unable to locate MWL results for requested procedure P1\n";
   print LOG "ERR: You should examine the MWL results in 131/mwl_q1/test \n";
   $diff += 1;
 } else {
   $diff += ordfil::evaluate_mwl_suid(
		$logLevel,
		$p1MWLFile);
 }

 print LOG "\n";
}

sub x_131_5 {
 print LOG "CTX: Order Filler 131.5 \n";
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
open LOG, ">141/grade_141.txt" or die "?!";
$diff = 0;

x_141_1;
x_141_2;
#x_141_3;
#x_141_4;
#x_141_5;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 141/grade_141.txt \n";

exit $diff;
