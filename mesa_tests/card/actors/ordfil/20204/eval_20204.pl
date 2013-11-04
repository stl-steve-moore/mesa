#!/usr/local/bin/perl -w

use Env;

use lib "../../../rad/actors/ordfil/scripts";
require ordfil;

sub goodbye() {
  exit 1;
}

# Evaluate order message produced by Order Filler after first MPPS

sub x_20204_1 {
  print LOG "CTX: Order Filler 20204.1 \n";
  print LOG "CTX: Evaluating ORM O01 message to Order Placer\n";

  $diff += mesa::evaluate_ORM_FillerOrder(
	$logLevel,
	"../../msgs/order/20204/20204.140.o01.hl7",
	"$MESA_STORAGE/ordplc/1001.hl7");
}

# Evaluate status message produced by Order Filler after first MPPS

sub x_20204_2 {
  print LOG "CTX: Order Filler 20204.2 \n";
  print LOG "CTX:  Evaluating HL7 Order Status Update: In Progress \n";
  print LOG "REF:  IHE TF Vol II, Sec 4.3.4.2 \n" if ($logLevel >= 4);

  $diff += mesa::evaluate_ORM_O01_Status (
                $logLevel,
                "../../msgs/status/20204/20204.160.o01.hl7",
                "$MESA_STORAGE/ordplc/1002.hl7");
}

sub x_20204_3 {
  print LOG "CTX: Order Filler 20204.3 \n";
  print LOG "CTX:  Evaluating HL7 Scheduling Message to Image Manager\n";

  $diff += mesa::evaluate_ORM_scheduling_post_procedure (
                $logLevel,
                "../../msgs/sched/20204/20204.170.o01.hl7",
                "$MESA_STORAGE/imgmgr/hl7/1001.hl7",
                "$MESA_STORAGE/modality/T20204");
}

sub x_20204_4 {
  print LOG "CTX: Order Filler 20204.4 \n";
  print LOG "CTX:  Evaluating HL7 ADT-A08 message to Image Manager\n";

  $diff += mesa::evaluate_ADT_A08 (
                $logLevel,
                "../../msgs/adt/20204/20204.175.a08.hl7",
                "$MESA_STORAGE/imgmgr/hl7/1002.hl7");
}

### Main starts here

die "Usage: <log level: 1-4> <AE Title of your MPPS Mgr>" if (scalar(@ARGV) < 2);

$logLevel     = $ARGV[0];
#$titleMPPSMgr = $ARGV[1];
open LOG, ">20204/grade_20204.txt" or die "?!";
$diff = 0;

x_20204_1;	# Order message triggered by MPPS
x_20204_2;	# Status message to OP triggered by MPPS
x_20204_3;	# Scheduling message sent to Image Manager
x_20204_4;	# A08 message sent to Image Manager

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 20204/grade_20204.txt \n";

exit $diff;
