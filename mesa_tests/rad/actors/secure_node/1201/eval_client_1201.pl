#!/usr/local/bin/perl -w

# Script evaluates client test 1201.
# This is the test for generating an audit STARTUP message.

use Env;

use lib "scripts";
use lib "../../../common/scripts";
require secure;
require mesa_common;

sub goodbye() {
  exit 1;
}

sub eval_1201_1 {
  print LOG "CTX: 1201.1 Evaluating schema for $testType\n";

  my $rtnValue = 0;

  if ($testType eq "INTERIM") {
    $rtnValue = secure::validate_xml_schema($outputLevel, "$MESA_TARGET/logs/syslog/last_log.xml");
  } elsif ($testType eq "IETF") {
    $rtnValue = secure::validate_atna_xml_schema($outputLevel, "$MESA_TARGET/logs/syslog/last_log.xml");
  } else {
    print LOG "ERR: Unrecognized test type: $testType\n";
    print LOG "ERR: Should be INTERIM or IETF\n";
    $rtnValue = 1;
  }
  print LOG "\n";
  return $rtnValue;
}

sub eval_1201_2 {
  print LOG "CTX: 1201.2 Examining length of syslog message\n";
  my $rtnValue = 0;
  my ($status, $count) = mesa_utility::fileSize($outputLevel,
	"$MESA_TARGET/logs/syslog/last_log.xml");
  print LOG "CTX: Size of syslog message: $count\n" if ($outputLevel >= 3);

  if ($count >= 1024) {
    print LOG "WARN: Counted $count characters in syslog message.\n";
    print LOG "WARN: Messages > 1024 characters using BSD Syslog transport risk \n";
    print LOG "WARN:  truncation at the server; you might want to trim your message\n";

    print "WARN: Counted $count characters in syslog message.\n";
    print "WARN: Messages > 1024 characters using BSD Syslog transport risk \n";
    print "WARN:  truncation at the server; you might want to trim your message\n";
  }
  print LOG "\n";
  return $rtnValue;
}

if (scalar(@ARGV) != 2) {
  print "Usage: <output level (1-4)> <INTERIM or IETF> \n";
  exit 1;
}
$outputLevel = $ARGV[0];
$testType    = $ARGV[1];

open LOG, ">1201/grade_client_1201.txt" or die "?!";

my $diff = 0;

$diff += eval_1201_1;
$diff += eval_1201_2;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1201/grade_client_1201.txt \n";

exit $diff;
