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

sub x_105_1 {
 print LOG "CTX: Order Filler 105.1 \n";
 print LOG "CTX Examing PPS messages for P2/X2/X2 forwarded to Image Mgr \n";

 $diff += mesa::evaluate_mpps_mpps_mgr(
		$logLevel,
		"$MESA_STORAGE/modality/T105",
		"$MESA_STORAGE/imgmgr/mpps/$titleMPPSMgr",
                "1"
                );
 print LOG "\n";
}


sub x_105_2 {
 print LOG "CTX: Order Filler 105.2 \n";
 print LOG "CTX: Evaluating ORM O01 message to Order Placer\n";

 $diff += mesa::evaluate_ORM_FillerOrder (
		$logLevel,
		"../../msgs/order/105/105.114.o01.hl7",
		"$MESA_STORAGE/ordplc/1001.hl7");

# $diff += mesa::evaluate_hl7 (
#		$logLevel,
#		$verbose,
#		"../../msgs/order/105", "105.114.o01.hl7",
#		"$MESA_STORAGE/ordplc", "1001.hl7",
#		"ini_files/orm_o01_format.ini", "ini_files/orm_o01_compare.ini");
 print LOG "\n";
}

sub x_105_3 {
 print LOG "Order Filler 105.3 \n";
 print LOG " Evaluating HL7 scheduling message to Image Mgr for P2/X2 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1001.hl7");
 print LOG "  Universal service ID: $x\n";

 $diff += mesa::evaluate_hl7 (
		$logLevel,
		$verbose,
		"../../msgs/sched/105", "105.118.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1001.hl7",
		"ini_files/orm_sched_format.ini", "ini_files/orm_sched_compare.ini");
 print LOG "\n";
}

sub x_105_4 {
 print LOG "CTX: Order Filler 105.4 \n";
 print LOG "CTX:  Evaluating HL7 scheduling message to Image Mgr for P2/X2 \n";
 $x = ordfil::universal_service_id("$MESA_STORAGE/imgmgr/hl7", "1001.hl7");
 print LOG "  Universal service ID: $x\n";

 $diff += mesa::evaluate_ORM_scheduling_post_procedure (
		$logLevel,
		"../../msgs/sched/105/105.118.o01.hl7",
		"$MESA_STORAGE/imgmgr/hl7/1001.hl7",
		"$MESA_STORAGE/modality/T105");

 print LOG "\n";
}


sub x_105_5 {
 print LOG "CTX: Order Filler 105.5 \n";
 print LOG "CTX: Evaluating ADT A08 message to Image Manager\n";

 $diff += mesa::evaluate_hl7 (
		$logLevel,
		$verbose,
		"../../msgs/adt/105", "105.122.a08.hl7",
		"$MESA_STORAGE/imgmgr/hl7", "1002.hl7",
		"ini_files/adt_a08_format.ini", "ini_files/adt_a08_compare.ini");
 print LOG "\n";
}


### Main starts here

die "Usage: <log level: 1-4> <AE Title of your MPPS Mgr>" if (scalar(@ARGV) < 2);

$logLevel = $ARGV[0];
$titleMPPSMgr = $ARGV[1];
$verbose = 0;
open LOG, ">105/grade_105.txt" or die "?!";

my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    105\n";
print LOG "CTX: Actor:   OF\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";
$diff = 0;

x_105_1;
x_105_2;
x_105_3;
x_105_4;
x_105_5;
close LOG;

mesa_evaluate::copyLogWithXML("105/grade_105.txt", "105/mir_mesa_105.xml",
        $logLevel, "105", "OF", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "Test completed with zero errors means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 105/grade_105.txt and 105/mir_mesa_105.xml\n";
}

print "If you are submitting a result file to Kudu, submit 105/mir_mesa_105.xml\n\n";

