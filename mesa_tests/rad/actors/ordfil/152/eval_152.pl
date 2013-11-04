#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require ordfil;

use lib "../../../common/scripts";
require mesa_common;
require mesa_evaluate;

sub dummy {}

sub goodbye { }

# Compare HL7 message fields
# x_152_1: 
sub x_152_1 {
  print LOG "CTX: Appointment Notification test 152.1 \n";
  $diff += mesa::evaluate_APPOINT (
        $logLevel,
        "../../msgs/appoint/152/152.106.s12.hl7",
        "$MESA_STORAGE/ordplc/1001.hl7");
  print LOG "\n";
}

# x_152_2: 
sub x_152_2 {
  print LOG "CTX: Appointment Notification test 152.2 \n";
  $diff += mesa::evaluate_APPOINT (
        $logLevel,
        "../../msgs/appoint/152/152.110.s13.hl7",
        "$MESA_STORAGE/ordplc/1002.hl7");
  print LOG "\n";
}

## Not used any more :(
sub x_152 {
  print LOG "CTX: Appointment Notification test 152.1 \n";
  print LOG "CTX: Comparing fields from HL7 messages \n";
  print LOG "****************************************\n";
  print LOG "\n";

  my $msgDIR = "../../msgs/appoint/152";
  my $testMsgDIR = "/opt/mesa/storage/ordplc";
  my $s12HL7FILE = "152.106.s12.hl7";
  my $testHL7FILE = "1001.hl7";

  my %segment = (
	filler_appointment_id => ["SCH", 2, 0, "Filler Appointment ID"],
	event_reason => ["SCH", 6, 0, "Event Reason"],
	filler_contact_person => ["SCH", 16, 0, "Filler Contact Person"],
	placer_order_number => ["SCH", 26, 0, "Placer Order Number"],
	filler_order_number => ["SCH", 27, 0, "Filler Order Number"],
	universal_service_id => ["AIS", 3, 0, "Universal Service ID"],
	start_date_time => ["AIS", 4, 0, "Start Date/Time"],
	);

  # Compare the values from HL7 messages
  foreach my $key (keys %segment) {
    my ($ret1, $val1) = mesa::getHL7Field (4, "$msgDIR/$s12HL7FILE", $segment{$key}[0], $segment{$key}[1], $segment{$key}[2], $segment{$key}[3] );
    my ($ret2, $val2) = mesa::getHL7Field (4, "$msgDIR/$s12HL7FILE", $segment{$key}[0], $segment{$key}[1], $segment{$key}[2], $segment{$key}[3] );
    unless ($key=~ m/event_reason|filler_contact_person|start_date_time/){
       print LOG "CTX: Comparing values in $segment{$key}[0]: $segment{$key}[3]\n";
       print LOG "Value on HL7 message as in MESA runtime dir: $val1\n";
       print LOG "Value on HL7 message as in Order Placer: $val2\n\n";
       $diff += 1 if (!($val1 eq $val2));
    }elsif ($key =~ m/event_reason|filler_contact_person/){
       print LOG "CTX: Checking to see if value exist in segment $segment{$key}[0]: $segment{$key}[3]\n";
       print LOG "Value on HL7 message as in MESA runtime dir: $val1\n";
       print LOG "Value on HL7 message as in Order Placer: $val2\n\n";
       $diff += 1 if (!$val1 || !$val2);
    }elsif ($key =~ m/start_date_time/) {
       print LOG "CTX: Checking to see if value exist in segment $segment{$key}[0]: $segment{$key}[3]\n";
       print LOG "Value on HL7 message as in MESA runtime dir: $val1\n";
       print LOG "Value on HL7 message as in Order Placer: $val2\n\n";
       $diff += 1 if (!$val1 || !$val2);
    }    
  }
  print LOG "\n";
 }

### Main starts here


open LOG, ">152/grade_152.txt" or die "Could not open output file: 152/grade_152.txt";

my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    152\n";
print LOG "CTX: Actor:   OF\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;
die "Usage: perl 152/eval_152.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

x_152_1;
x_152_2;

close LOG;

mesa_evaluate::copyLogWithXML("152/grade_152.txt", "152/mir_mesa_152.xml",
        $logLevel, "152", "OF", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "Test completed with zero errors means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 152/grade_152.txt and 152/mir_mesa_152.xml\n";
}

print "If you are submitting a result file to Kudu, submit 152/mir_mesa_152.xml\n\n";

