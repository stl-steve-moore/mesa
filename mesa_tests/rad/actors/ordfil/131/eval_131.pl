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

# Compare input HL7 messages with expected values.

sub x_131_1 {
 print LOG "CTX: Order Filler 131.1 \n";
 print LOG "CTX:  Evaluating HL7 scheduling message to Image Mgr for P1/X1 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1001.hl7");
 print LOG "CTX:   Universal service ID: $x\n";

 $diff += mesa::evaluate_hl7 (
		$logLevel,
		$verbose,
		"../../msgs/sched/131", "131.106.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1001.hl7",
		"ini_files/orm_sched_format.ini", "ini_files/orm_sched_compare.ini");
 print LOG "\n";
}

sub x_131_2 {
 print LOG "CTX: Order Filler 131.2 \n";
 print LOG "CTX:  Evaluating HL7 scheduling message to Image Mgr for P1/X1 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1001.hl7");
 print LOG "CTX:   Universal service ID: $x\n";

 $diff += mesa::evaluate_ORM_scheduling (
		$logLevel,
		"../../msgs/sched/131/131.106.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7/1001.hl7");
 print LOG "\n";
}

# Evaluate response to request for procedure P1.
sub x_131_3 {
 print LOG "CTX: Order Filler 131.3 \n";
 print LOG "CTX: Evaluating MWL response for procedure P1/X1 \n";

 $p1MWLFile     = ordfil::mwl_search_by_procedure_code($logLevel, "131/mwl_q1/test", "P1");
 $p1MWLFileMESA = ordfil::mwl_search_by_procedure_code($logLevel, "131/mwl_q1/mesa", "P1");

 if ($p1MWLFile eq "") {
   print LOG "ERR: Unable to locate MWL results for requested procedure P1\n";
   print LOG "ERR: You should examine the MWL results in 131/mwl_q1/test \n";
   $diff += 1;
 } elsif ($p1MWLFileMESA eq "") {
   print LOG "ERR: MESA MWL does not include requested procedure P1\n";
   print LOG "ERR:  This is an error in the test configuration/run \n";
   print LOG "ERR:  You should examine the MWL results in 131/mwl_q1/mesa \n";
   $diff += 1;
 } else {
   $diff += mesa::evaluate_one_mwl_resp(
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
$verbose = 0;
open LOG, ">131/grade_131.txt" or die "?!";

my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    131\n";
print LOG "CTX: Actor:   OF\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

x_131_1;
x_131_2;
x_131_3;
x_131_4;
x_131_5;

close LOG;

mesa_evaluate::copyLogWithXML("131/grade_131.txt", "131/mir_mesa_131.xml",
        $logLevel, "131", "OF", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "Test completed with zero errors means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 131/grade_131.txt and 131/mir_mesa_131.xml\n";
}

print "If you are submitting a result file to Kudu, submit 131/mir_mesa_131.xml\n\n";

