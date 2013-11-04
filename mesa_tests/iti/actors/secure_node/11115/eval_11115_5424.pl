#!/usr/local/bin/perl -w

# Script evaluates one file under 11115 for compliance with RFC 5424.

use Env;

#use lib "scripts";
use lib "../../../common/scripts";
#require secure;
require mesa_common;
require mesa_evaluate;

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


if (scalar(@ARGV) != 1) {
  die "Usage: FILE";
  exit 1;
}
my $auditFileTxt = $ARGV[0];

open LOG, ">11115/grade_11115_5424.txt" or die "Could not create grade file: 11115/grade_11115_5424.txt";
my $diff = 0;
my $mesaVersion = mesa_get::getMESAVersion();
print LOG "CTX: $mesaVersion \n";


print LOG "CTX: Secure Node test 11115 5424\n";

$outputLevel = 4;
$diff += x_11115_1($outputLevel, $auditFileTxt);

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 11115/grade_11115_5424.txt \n";

exit $diff;
