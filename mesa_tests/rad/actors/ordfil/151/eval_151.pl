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
# x_151_1: 
sub x_151_1 {
  print LOG "CTX: Appointment Notification test 151.1 \n";
  $diff += mesa::evaluate_APPOINT(
        $logLevel,
        "../../msgs/appoint/151/151.106.s12.hl7",
        "$MESA_STORAGE/ordplc/1001.hl7");
  print LOG "\n";
}

### Main starts here

if ($MESA_OS eq "WINDOWS_NT") {
  if (! exists $ENV{"TZ"}) {
    print "Please set the environment variable TZ to your timezone for this script\n";
    print " For example in the US, set TZ=CST or set TZ=EST\n";
    exit 1;
  }
}

open LOG, ">151/grade_151.txt" or die "Could not open output file: 151/grade_151.txt";

open LOG, ">151/grade_151.txt" or die "Could not open output file 151/grade_151.txt";

my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    151\n";
print LOG "CTX: Actor:   OF\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;
die "Usage: perl 151/eval_151.pl <log level (1-4)>\n" if (scalar(@ARGV) < 1);
$logLevel = $ARGV[0];

x_151_1;

close LOG;

mesa_evaluate::copyLogWithXML("151/grade_151.txt", "151/mir_mesa_151.xml",
        $logLevel, "151", "OF", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "Test completed with zero errors means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 151/grade_151.txt and 151/mir_mesa_151.xml\n";
}

print "If you are submitting a result file to Kudu, submit 151/mir_mesa_151.xml\n\n";

