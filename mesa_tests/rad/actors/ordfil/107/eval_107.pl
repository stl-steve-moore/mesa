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

sub x_107_1 {
 print LOG "CTX: Order Filler 107.1 \n";
 print LOG "CTX:  Evaluating HL7 Order Status Update: In Progress \n";
 print LOG "REF:  IHE TF Vol II, Sec 4.3.4.2 \n" if ($logLevel >= 4);

 $diff += mesa::evaluate_ORM_O01_Status (
		$logLevel,
		"../../msgs/status/107/107.112.o01.hl7",
		"$MESA_STORAGE/ordplc/1001.hl7");

# $diff += mesa::evaluate_hl7 (
#		$logLevel,
#		$verbose,
#		"../../msgs/status/107", "107.112.o01.hl7",
#		"$MESA_STORAGE/ordplc", "1001.hl7",
#		"ini_files/orm_status_format.ini", "ini_files/compare_hl7_status.ini");
 print LOG "\n";
}

sub x_107_2 {
 print LOG "CTX: Order Filler 107.2 \n";
 print LOG "CTX:  Evaluating HL7 Order Status Update: Complete\n";
 print LOG "REF:  IHE TF Vol II, Sec 4.3.4.2 \n" if ($logLevel >= 4);

 $diff += mesa::evaluate_ORM_O01_Status (
		$logLevel,
		"../../msgs/status/107/107.116.o01.hl7",
		"$MESA_STORAGE/ordplc/1002.hl7");

# $diff += mesa::evaluate_hl7 (
#		$logLevel,
#		$verbose,
#		"../../msgs/status/107", "107.116.o01.hl7",
#		"$MESA_STORAGE/ordplc", "1002.hl7",
#		"ini_files/orm_status_format.ini", "ini_files/compare_hl7_status.ini");
 print LOG "\n";
}

### Main starts here

die "Usage: <log level: 1-4> <AE Title of your MPPS Mgr>" if (scalar(@ARGV) < 2);

$logLevel = $ARGV[0];
#$titleMPPSMgr = $ARGV[0];
#$verbose = 0;
open LOG, ">107/grade_107.txt" or die "?!";

my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    107\n";
print LOG "CTX: Actor:   OF\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

x_107_1;
x_107_2;

close LOG;

mesa_evaluate::copyLogWithXML("107/grade_107.txt", "107/mir_mesa_107.xml",
        $logLevel, "107", "OF", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "Test completed with zero errors means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 107/grade_107.txt and 107/mir_mesa_107.xml\n";
}

print "If you are submitting a result file to Kudu, submit 107/mir_mesa_107.xml\n\n";

