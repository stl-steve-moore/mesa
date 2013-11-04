#!/usr/local/bin/perl -w

# Script evaluates test 11115.
# This is the test for generating an audit STARTUP message.

use Env;

#use lib "scripts";
use lib "../../../common/scripts";
#require secure;
require mesa_common;
require mesa_evaluate;
use File::stat;
use Time::localtime;


sub goodbye() {
  exit 1;
}

sub x_11115_1 {
  print LOG "\nCTX: 11115.1\n";
  print LOG "CTX: Evaluation of ATNA Audit Message, checking for RFC5424 compliance\n";

  my ($logLevel, $file) = @_;
  print LOG "CTX: Evaluating file: $file\n";

  my $x = "$MESA_TARGET/bin/syslog_server -f $file";
  print LOG `$x`;

  if ($?) {
    print LOG "ERR: Failed parsing according to RFC 5424\n";
    return 1;
  }

  return 0;
}

sub checkFileDates {

  my $logXML = "$MESA_TARGET/logs/syslog/last_log.xml";
  if (! -e $logXML) {
    print LOG "ERR: $logXML does not exist\n";
    print LOG "ERR: That means the MESA syslog server did not receiver your audit message.\n";
    print LOG "ERR: Please check: syslog server running? syslog server files for clues.\n";

    print "ERR: $logXML does not exist\n";
    print "ERR: That means the MESA syslog server did not receiver your audit message.\n";
    print "ERR: Please check: syslog server running? syslog server files for clues.\n";
    exit 1;
  }
  my $dateString = ctime(stat($logXML)->mtime);
  print "Time stamp on $logXML: $dateString\n";
  print " Does this match the time you sent your last message?\n";
  print LOG "Time stamp on $logXML: $dateString\n";
}

if (scalar(@ARGV) != 2) {
  die "Usage: <output level> <schema: INTERIM or IETF>";
  exit 1;
}
$outputLevel = $ARGV[0];
$testType = $ARGV[1];

open LOG, ">11115/grade_11115.txt" or die "Could not create grade file: 11115/grade_11115.txt";
my $diff = 0;
my $mesaVersion = mesa_get::getMESAVersion();
print LOG "CTX: $mesaVersion \n";


print LOG "CTX: Secure Node test 11115\n";
print LOG "CTX: Test type: $testType\n";

checkFileDates();

if (! -e "$MESA_TARGET/logs/syslog/last_log.xml") {
  print LOG "ERR: $MESA_TARGET/logs/syslog/last_log.xml does not exist\n";
  print LOG "ERR: That means the MESA syslog server did not receiver your audit message.\n";
  print LOG "ERR: Please check: syslog server running? syslog server files for clues.\n";

  print "ERR: $MESA_TARGET/logs/syslog/last_log.xml does not exist\n";
  print "ERR: That means the MESA syslog server did not receiver your audit message.\n";
  print "ERR: Please check: syslog server running? syslog server files for clues.\n";
  exit 1;
}

  my $auditFileXML = "$MESA_TARGET/logs/syslog/last_log.xml";
  my $auditFileTxt = "$MESA_TARGET/logs/syslog/last_log.txt";
  $diff += x_11115_1($outputLevel, $auditFileTxt);
  my $diffSchema = 0;
if ($testType eq "INTERIM") {
  $diffSchema += mesa_evaluate::validate_xml_schema($outputLevel, "$MESA_TARGET/runtime/IHE-syslog-audit-message-4.xsd", $auditFileXML);
} elsif ($testType eq "IETF") {
  $diffSchema += mesa_evaluate::validate_xml_schema($outputLevel, "$MESA_TARGET/runtime/IHE-ATNA-syslog-audit-message.xsd", $auditFileXML);
} else {
  print LOG "ERR: Unrecognized test type: $testType\n";
  print LOG "ERR: Should be INTERIM or IETF\n";
  print LOG "ERR: Interim refers to the IHE YR4 interim schema; IETF refers to RFC 3881\n";
  print "ERR: Interim refers to the IHE YR4 interim schema; IETF refers to RFC 3881\n";
  print "ERR: Test type should be INTERIM or IETF. Please insert another quarter.\n";
  $diffSchema = 1;
}

$diff += $diffSchema;
print LOG "CTX: Pass schema tests\n" if ($diffSchema == 0);

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 11115/grade_11115.txt \n";

exit $diff;
