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

sub x_133_1 {
 print LOG "CTX: Order Filler 133.1 \n";
 print LOG "CTX: Evaluating ORM O01 message to Order Placer\n";

 $diff += mesa::evaluate_ORM_FillerOrder (
		$logLevel,
		"../../msgs/order/133/133.144.o01.hl7",
		"$MESA_STORAGE/ordplc/1001.hl7");

# $diff += mesa::evaluate_hl7 (
#		$logLevel,
#		$verbose,
#		"../../msgs/order/133", "133.144.o01.hl7",
#		"$MESA_STORAGE/ordplc", "1001.hl7",
#		"ini_files/orm_o01_format.ini", "ini_files/orm_o01_compare.ini");
 print LOG "\n";
}

sub x_133_2 {
 print LOG "CTX: Order Filler 133.2 \n";
 print LOG "CTX: Evaluating HL7 scheduling message to Image Mgr for P1/X1 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1001.hl7");
 print LOG "  Universal service ID: $x\n";

 $diff += mesa::evaluate_hl7 (
		$logLevel,
		$verbose,
		"../../msgs/sched/133", "133.148.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1001.hl7",
		"ini_files/orm_sched_format.ini", "ini_files/orm_sched_compare.ini");
 print LOG "\n";
}

sub x_133_3 {
 print LOG "CTX: Order Filler 133.3 \n";
 print LOG "CTX: Evaluating ADT A40 message to Image Manager\n";

 $diff += mesa::evaluate_hl7 (
		$logLevel,
		$verbose,
		"../../msgs/adt/133", "133.184.a40.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1002.hl7",
		"ini_files/adt_a40_format.ini", "ini_files/adt_a40_filler_compare.ini");
 print LOG "\n";
}

# Evaluate MWL response to request for procedure P1
sub x_133_4 {
 print LOG "CTX: Order Filler 133.4 \n";
 print LOG "CTX: Evaluating MWL response for procedure P1/X1 \n";

 $p1MWLFile     = ordfil::mwl_search_by_procedure_code($logLevel, "133/mwl_q1/test", "P1");
 $p1MWLFileMESA = ordfil::mwl_search_by_procedure_code($logLevel, "133/mwl_q1/mesa", "P1");

 if ($p1MWLFile eq "") {
   print LOG "ERR: Unable to locate MWL results for requested procedure P1\n";
   print LOG "ERR: You should examine the MWL results in 133/mwl_q1/test \n";
   $diff += 1;
 } elsif ($p1MWLFileMESA eq "") {
   print LOG "ERR: MESA MWL does not include requested procedure P1\n";
   print LOG "ERR:  This is an error in the test configuration/run \n";
   print LOG "ERR:  You should examine the MWL results in 133/mwl_q1/mesa \n";
   $diff += 1;
 } else {
   $diff += mesa::evaluate_one_mwl_resp(
                $logLevel,
                $p1MWLFile,
                $p1MWLFileMESA);
 }

 print LOG "\n";
}



### Main starts here


die "Usage: <log level: 1-4> <AE Title of your MPPS Mgr>" if (scalar(@ARGV) < 2);

$logLevel = $ARGV[0];
#$titleMPPSMgr = $ARGV[1];
$verbose = 0;
open LOG, ">133/grade_133.txt" or die "Could not open output file 133/grade_133.txt";

my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    133\n";
print LOG "CTX: Actor:   OF\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

x_133_1;
x_133_2;
x_133_3;
x_133_4;

close LOG;

mesa_evaluate::copyLogWithXML("133/grade_133.txt", "133/mir_mesa_133.xml",
        $logLevel, "133", "OF", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "Test completed with zero errors means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 133/grade_133.txt and 133/mir_mesa_133.xml\n";
}

print "If you are submitting a result file to Kudu, submit 133/mir_mesa_133.xml\n\n";

