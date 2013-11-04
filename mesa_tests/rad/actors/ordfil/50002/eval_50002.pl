#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
use lib "../../../common/scripts";
require ordfil;
require mesa_common;

sub goodbye() {
  exit 1;
}

sub x_50002_1 {
 print LOG "Order Filler 50002.1 \n";
 print LOG " Evaluating HL7 scheduling message to Image Mgr for EyeCare 200 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1001.hl7");
 print LOG "  Universal service ID: $x\n";

 my $x = mesa::evaluate_ORM_scheduling (
                $logLevel,
                "../../msgs/sched/50002/50002.140.o01.hl7",
                "$MESA_STORAGE/imgmgr/hl7/1001.hl7");

 print LOG "\n";
 return $x;
}

sub x_50002_2 {
 print LOG "CTX: Order Filler 50002.2 \n";
 print LOG "CTX: Evaluating ADT A08 message to Image Manager\n";

 my $x = mesa::evaluate_hl7 (
		$logLevel,
		$verbose,
		"../../msgs/adt/50002", "50002.200.a08.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1002.hl7",
		"ini_files/adt_a08_format.ini", "ini_files/adt_a08_compare.ini");
 print LOG "\n";
 return $x;
}

sub x_50002_3 {
 print LOG "CTX: Order Filler 50002.3 \n";
 print LOG "CTX: Evaluating MWL response for procedure EYE-200 \n";

 $p1MWLFile     = ordfil::mwl_search_by_procedure_code($logLevel, "50002/mwl_q1/test", "EYE-200");
 $p1MWLFileMESA = ordfil::mwl_search_by_procedure_code($logLevel, "50002/mwl_q1/mesa", "EYE-200");

 my $x = 0;
 if ($p1MWLFile eq "") {
   print LOG "ERR: Unable to locate MWL results for requested procedure EYE-200\n";
   print LOG "ERR: You should examine the MWL results in 50002/mwl_q1/test \n";
   $x = 1;
 } elsif ($p1MWLFileMESA eq "") {
   print LOG "ERR: MESA MWL does not include requested procedure EYE-200\n";
   print LOG "ERR:  This is an error in the test configuration/run \n";
   print LOG "ERR:  You should examine the MWL results in 50002/mwl_q1/mesa \n";
   $x = 1;
 } else {
   $x = mesa::evaluate_one_mwl_resp(
                $logLevel,
                $p1MWLFile,
                $p1MWLFileMESA);
 }

 print LOG "\n";
 return $x;
}

sub x_50002_4 {
 print LOG "CTX: Order Filler 50002.4 \n";
 print LOG "CTX: Evaluating MWL response for procedure EYE-200 after A08 rename\n";

 $p1MWLFile     = ordfil::mwl_search_by_procedure_code($logLevel, "50002/mwl_q2/test", "EYE-200");
 $p1MWLFileMESA = ordfil::mwl_search_by_procedure_code($logLevel, "50002/mwl_q2/mesa", "EYE-200");

 my $x = 0;
 if ($p1MWLFile eq "") {
   print LOG "ERR: Unable to locate MWL results for requested procedure EYE-200\n";
   print LOG "ERR: You should examine the MWL results in 50002/mwl_q2/test \n";
   $x = 1;
 } elsif ($p1MWLFileMESA eq "") {
   print LOG "ERR: MESA MWL does not include requested procedure EYE-200\n";
   print LOG "ERR:  This is an error in the test configuration/run \n";
   print LOG "ERR:  You should examine the MWL results in 50002/mwl_q2/mesa \n";
   $x = 1;
 } else {
   $x = mesa::evaluate_one_mwl_resp(
                $logLevel,
                $p1MWLFile,
                $p1MWLFileMESA);
 }

 print LOG "\n";
 return $x;
}



### Main starts here

die "Usage: <log level: 1-4> <AE Title of your MPPS Mgr>" if (scalar(@ARGV) < 2);

$logLevel = $ARGV[0];
#$titleMPPSMgr = $ARGV[1];
$verbose = 0;
open LOG, ">50002/grade_50002.txt" or die "?!";
my $mesaVersion = mesa_get::getMESAVersion();
my ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime(0);
print LOG "CTX: $mesaVersion \n";
print LOG "CTX: current date/time $date $timeToMinute\n";
print LOG "CTX: Log level $logLevel\n";

$diff = 0;


$diff += x_50002_1;
$diff += x_50002_2;
$diff += x_50002_3;
$diff += x_50002_4;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 50002/grade_50002.txt \n";

exit $diff;
