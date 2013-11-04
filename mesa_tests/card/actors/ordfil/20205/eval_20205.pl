#!/usr/local/bin/perl -w

use Env;

use lib "../../../rad/actors/ordfil/scripts";
require ordfil;

sub goodbye() {
  exit 1;
}

# Evaluate order message produced by Order Filler after first MPPS

sub x_20205_1 {
  print LOG "CTX: Order Filler 20205.1 \n";
  print LOG "CTX: Evaluating ORM O01 message to Order Placer\n";

  $diff += mesa::evaluate_ORM_FillerOrder(
	$logLevel,
	"../../msgs/order/20205/20205.140.o01.hl7",
	"$MESA_STORAGE/ordplc/1001.hl7");
 print LOG "\n";
}

# Evaluate status message sent by Order Filler to Order Placer
# This one should be for In Progress

sub x_20205_2 {
  print LOG "CTX: Order Filler 20205.2 \n";
  print LOG "CTX:  Evaluating HL7 Order Status Update: In Progress \n";
  print LOG "REF:  IHE TF Vol II, Sec 4.3.4.2 \n" if ($logLevel >= 4);

  $diff += mesa::evaluate_ORM_O01_Status (
                $logLevel,
                "../../msgs/status/20205/20205.160.o01.hl7",
                "$MESA_STORAGE/ordplc/1002.hl7");
 print LOG "\n";
}

# Evaluate scheduling message sent to Image Manager
sub x_20205_3 {
  print LOG "CTX: Order Filler 20205.3 \n";
  print LOG "CTX:  Evaluating HL7 Scheduling Message to Image Manager\n";

  $diff += mesa::evaluate_ORM_scheduling (
                $logLevel,
                "../../msgs/sched/20205/20205.170.o01.hl7",
                "$MESA_STORAGE/imgmgr/hl7/1002.hl7",);
#                "$MESA_STORAGE/modality/T20205");
  print LOG "\n";
  return $diff;
}

sub x_20205_4 {
 print LOG "CTX: Order Filler 20205.4 \n";
 print LOG "CTX: Examing MPPS messages \n";

 $diff += mesa::evaluate_mpps_mpps_mgr(
        $logLevel,
        "$MESA_STORAGE/modality/T20205",
        "$MESA_STORAGE/imgmgr/mpps/$titleMPPSMgr",
                "1"
                );
 print LOG "\n";
}

sub x_20205_5 {
 print LOG "CTX: Order Filler 20205.5 \n";
 print LOG "CTX: Evaluating ADT A40 message to Image Manager\n";

 $diff += mesa::evaluate_ADT_A40_DSS_TempID (
                $logLevel,
		"../../msgs/adt/20205/20205.184.a40.hl7",
                "$MESA_STORAGE/imgmgr/hl7/1001.hl7");

# $diff += mesa::evaluate_hl7 (
#        $logLevel, $verbose,
#        "../../msgs/adt/20205", "20205.184.a40.hl7",
#        "$MESA_STORAGE/imgmgr/hl7", "1001.hl7",
#        "ini_files/adt_a40_format.ini", "ini_files/adt_a40_filler_compare.ini");
 print LOG "\n";
}


# Evaluate MWL response after the SPS is scheduled
sub x_20205_6 {
  print LOG "CTX: Order Filler 20205.6 \n";
  print LOG "CTX: Evaluating MWL response for SPS for US\n";

  @p1MWLFilesTEST = ordfil::mwl_search_by_procedure_code_only($logLevel, "20205/mwl_q1/test", "ECHO.001");
  @p1MWLFilesMESA = ordfil::mwl_search_by_procedure_code_only($logLevel, "20205/mwl_q1/mesa", "ECHO.001");

  if (scalar(@p1MWLFilesTEST) == 0) {
    print LOG "ERR: Unable to locate MWL results for requested procedure ECHO.001 \n";
    print LOG "ERR:  You should examine the MWL results in 20205/mwl_q1 \n";
    $diff += 1;
    return $diff;
  }
  if (scalar(@p1MWLFilesTEST) != 1) {
    print LOG "ERR: More than one SPS found in MWL for requested procedure ECHO.001 \n";
    print LOG "ERR:  You should examine the MWL results in 20205/mwl_q1 \n";
    $diff += 1;
    return $diff;
  }
  if (scalar(@p1MWLFilesMESA) != 1) {
    my $countMESA = scalar(@p1MWLFilesMESA);
    print LOG "ERR: MESA MWL contains $countMESA SPS for ECHO.001\n";
    print LOG "ERR:  Expected value is 1.\n";
    print LOG "ERR:  This is an error in the test configuration/run \n";
    print LOG "ERR:  You should examine the MWL results in 20205/mwl_q1/mesa \n";
    $diff += 1;
    return $diff;
  }
  $diff += mesa::evaluate_one_mwl_resp_card_mpps_trigger_no_order(
 		$logLevel,
 		"$p1MWLFilesTEST[0]",
 		"$p1MWLFilesMESA[0]",
		"$MESA_STORAGE/modality/T20205/mpps.status");
 
  print LOG "\n";
  return $diff;
}


### Main starts here

die "Usage: <log level: 1-4> <AE Title of your MPPS Mgr>" if (scalar(@ARGV) < 2);

$logLevel     = $ARGV[0];
$titleMPPSMgr = $ARGV[1];
#$verbose = grep /^-/, @ARGV;

open LOG, ">20205/grade_20205.txt" or die "?!";
$diff = 0;

if ($MESA_OS eq "WINDOWS_NT") {
  $dirBase = "104\\";
  $separator = "\\";
} else {
  $dirBase = "104/";
  $separator = "/";
}

x_20205_1;	# Order message triggered by MPPS
x_20205_2;	# Status message to OP triggered by MPPS
x_20205_3;	# Scheduling message sent to Image Manager
x_20205_4;	# Evaluate MPPS message
x_20205_5;	# Evaluate AO4 message
x_20205_6;	# Evaluate MWL response after the SPS is in the worklist

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 20205/grade_20205.txt \n";

exit $diff;
