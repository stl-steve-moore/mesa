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

sub x_103_1 {
 print LOG "Order Filler 103.1 \n";
 print LOG " Evaluating HL7 scheduling message to Image Mgr for P1/X1 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1001.hl7");
 print LOG "  Universal service ID: $x\n";

 $diff += mesa::evaluate_hl7 (
		$logLevel,
		$verbose,
		"../../msgs/sched/103", "103.106.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1001.hl7",
		"ini_files/orm_sched_format.ini", "ini_files/orm_sched_compare.ini");
 print LOG "\n";
}

sub x_103_2 {
 print LOG "CTX: Order Filler 103.2 \n";
 print LOG "CTX:  Evaluating HL7 scheduling message to Image Mgr for P1/X1 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1001.hl7");
 print LOG "CTX:   Universal service ID: $x\n";

 $diff += mesa::evaluate_ORM_scheduling (
                $logLevel,
                "../../msgs/sched/103/103.106.o01.hl7",
                "$MESA_STORAGE/imgmgr/hl7/1001.hl7");
 print LOG "\n";
}

sub x_103_4 {
  print LOG "CTX: Order Filler 103.4\n";
  print LOG "CTX: Evaluating ADT A08 message to Image Mgr\n";
  $diff += mesa::evaluate_ADT_A08(
        $logLevel,
        "../../msgs/adt/103/103.132.a08.hl7",
        "$MESA_STORAGE/imgmgr/hl7/1002.hl7");
  print LOG "\n";
}

# Evaluate MWL responses

# Evaluate response to request for procedure P1.
sub x_103_10 {
  print LOG "CTX: Order Filler 103.10 \n";
  print LOG "CTX: Evaluating MWL response for procedure P1/X1 \n";

  $p1MWLFile =     ordfil::mwl_find_matching_procedure_code("103/mwl_q1/test", "P1");
  $p1MWLFileMESA = ordfil::mwl_find_matching_procedure_code("103/mwl_q1/mesa", "P1");

  if ($p1MWLFile eq "") {
    print LOG "ERR: Unable to locate MWL results for requested procedure P1\n";
    print LOG "ERR:  You should examine the MWL results in 103/mwl_p1 \n";
    $diff += 1;
 } elsif ($p1MWLFileMESA eq "") {
    print LOG "ERR: MESA MWL does not include requested procedure P1\n";
    print LOG "ERR:  This is an error in the test configuration/run \n";
    print LOG "ERR:  You should examine the MWL results in 103/mwl_p1_mesa \n";
    $diff += 1;
  } else {
    $diff += mesa::evaluate_one_mwl_resp(
 		$logLevel,
 		"103/mwl_q1/test/$p1MWLFile",
 		"103/mwl_q1/mesa/$p1MWLFileMESA");
  }
 
  print LOG "\n";
 }

sub x_103_12 {
  print LOG "CTX: Order Filler 103.12 \n";
  print LOG "CTX: Examing PPS messages for P1/X1/X1 forwarded to Image Mgr \n";
 
  $diff += mesa::evaluate_mpps_mpps_mgr(
		$logLevel,
		"$MESA_STORAGE/modality/T103",
		"$MESA_STORAGE/imgmgr/mpps/$titleMPPSMgr",
		"1"
		);
  print LOG "\n";
 }

### Main starts here

die "Usage: <log level: 1-4> <AE Title of your MPPS Mgr>" if (scalar(@ARGV) < 2);

$logLevel     = $ARGV[0];
$titleMPPSMgr = $ARGV[1];
$verbose = 0;
open LOG, ">103/grade_103.txt" or die "?!";

my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    103\n";
print LOG "CTX: Actor:   OF\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

x_103_1;
x_103_2;
x_103_4;
x_103_10;
x_103_12;

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("103/grade_103.txt", "103/mir_mesa_103.xml",
        $logLevel, "103", "OF", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "Test completed with zero errors means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 103/grade_103.txt and 103/mir_mesa_103.xml\n";
}

print "If you are submitting a result file to Kudu, submit 103/mir_mesa_103.xml\n\n";

