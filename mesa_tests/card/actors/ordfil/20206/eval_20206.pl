#!/usr/local/bin/perl -w

use Env;

use lib "../../../rad/actors/ordfil/scripts";
require ordfil;

sub goodbye() {
  exit 1;
}

# Evaluate order message produced by Order Filler

sub x_20206_2 {
  print LOG "CTX: Order Filler 20206.2 \n";
  print LOG "CTX: Evaluating ORM O01 message to Order Placer\n";

  $diff += mesa::evaluate_ORM_FillerOrder(
	$logLevel,
	"../../msgs/order/20206/20206.106.o01.hl7",
	"$MESA_STORAGE/ordplc/1001.hl7");
  print LOG "\n";
  return $diff;
}

# Evaluate scheduling message sent to Image Manager

sub x_20206_4 {
  print LOG "CTX: Order Filler 20206.4 \n";
  print LOG "CTX: Evaluating ORM O01 message to Image Manager\n";

  $diff += mesa::evaluate_ORM_scheduling (
	$logLevel,
	"../../msgs/sched/20206/20206.110.o01.hl7",
	"$MESA_STORAGE/imgmgr/hl7/1001.hl7");
  print LOG "\n";
  return $diff;
}

# Evaluate response to request for SPS for US system.
sub x_20206_6 {
  print LOG "CTX: Order Filler 20206.6 \n";
  print LOG "CTX: Evaluating MWL response for SPS for US - triggered by HD MPPS\n";

  @p1MWLFilesTEST =  ordfil::mwl_search_by_procedure_code_aetitle($logLevel, "20206/mwl_q1/test", "ECHO.002", "ELAB1_US");
  @p1MWLFilesMESA = ordfil::mwl_search_by_procedure_code_aetitle($logLevel, "20206/mwl_q1/mesa", "ECHO.002", "ELAB1_US");

  if (scalar(@p1MWLFilesTEST) == 0) {
    print LOG "ERR: Unable to locate MWL results for requested procedure ECHO.002 and AE Title ELAB1_US\n";
    print LOG "ERR:  You should examine the MWL results in 20206/mwl_q1/test \n";
    $diff += 1;
    return $diff;
  }
  if (scalar(@p1MWLFilesTEST) != 1) {
    print LOG "ERR: More than one SPS found in MWL for requested procedure ECHO.002 and AE Title ELAB1_US\n";
    print LOG "ERR:  You should examine the MWL results in 20206/mwl_q1/test \n";
    $diff += 1;
    return $diff;
  }
  if (scalar(@p1MWLFilesMESA) != 1) {
    my $countMESA = scalar(@p1MWLFilesMESA);
    print LOG "ERR: MESA MWL contains $countMESA SPS for ECHO.002/ELAB1_US\n";
    print LOG "ERR:  Expected value is 1.\n";
    print LOG "ERR:  This is an error in the test configuration/run \n";
    print LOG "ERR:  You should examine the MWL results in 20206/mwl_q1/mesa \n";
    $diff += 1;
    return $diff;
  }
  $diff = 0;
  $diff += mesa::evaluate_one_mwl_resp_card_mpps_trigger_no_order (
        $logLevel,
        "$p1MWLFilesTEST[0]",
        "$p1MWLFilesMESA[0]",
        "$MESA_STORAGE/modality/T20206/mpps.status");

  print LOG "\n";
  return $diff;
}

sub x_20206_8 {
 print LOG "CTX: Order Filler 20206.8 \n";
 print LOG "CTX Examing PPS messages for P2/X2/X2 forwarded to Image Mgr \n";

 $diff += mesa::evaluate_mpps_mpps_mgr(
        $logLevel,
        "$MESA_STORAGE/modality/T20206",
        "$MESA_STORAGE/imgmgr/mpps/$titleMPPSMgr",
                "1"
                );
 print LOG "\n";
}


### Main starts here

die "Usage: <log level: 1-4> <AE Title of your MPPS Mgr>" if (scalar(@ARGV) < 2);

$logLevel     = $ARGV[0];
$titleMPPSMgr = $ARGV[1];
open LOG, ">20206/grade_20206.txt" or die "?!";
$diff = 0;

x_20206_2;	# Order message triggered by MPPS
x_20206_4;	# Scheduling message sent to Image Manager
x_20206_6;	# Evaluating MWL response for SPS for US
x_20206_8;	# Examine PPS message forwarded to Img Mgr.

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 20206/grade_20206.txt \n";

exit $diff;
