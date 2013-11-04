#!/usr/local/bin/perl -w

use Env;

use lib "../../scripts";
require mesa_common;
require mesa_evaluate;

sub dummy {}

# 

sub x_1_1 {
  print LOG "\nCTX: MESA Instalation test 1.1 \n";
  print LOG "\n";

  mesa_utility::testMESAEnvironment($logLevel);
  open H, "<mesa_environment.log";
  while ($l = <H>) {
    print LOG $l;
  }
  print LOG "\n";
}

sub x_1_2 {
  print LOG "\nCTX: MESA Instalation test 1.2 \n";
  print LOG "\n";

  mesa_utility::delete_file(1, "mesa_db_test.log");
  my $x = "$MESA_TARGET/bin/mesa_db_test -l 4";
  `$x`;
  open H, "<mesa_db_test.log";
  while ($l = <H>) {
    print LOG $l;
  }
  print LOG "\n";
}

# These are the tests for Storage Commitment

#die "Usage <log level: 1-4>" if (scalar(@ARGV) < 1);

my $diff = 0;

$logLevel     = 4;
open LOG, ">1/grade_1.txt" or die "Could not open output file: 1/grade_1.txt";

my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    1\n";
print LOG "CTX: Actor:   All\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

x_1_1;
x_1_2;

close LOG;

mesa_evaluate::copyLogWithXML("1/grade_1.txt", "1/mir_mesa_1.xml",
        $logLevel, "1", "All", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "Test completed with zero errors means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 1/grade_1.txt and 1/mir_mesa_1.xml\n";
}

print "If you are submitting a result file to Kudu, submit 1/mir_mesa_1.xml\n\n";

