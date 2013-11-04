#!/usr/local/bin/perl -w

# Evaluation script for server test 1222.
# MESA client offers an unregistered certificate
# to server system under test.

use Env;

use lib "scripts";
use lib "../common/scripts";
require secure;
require mesa_xml;

sub goodbye() {
  exit 1;
}

sub evaluate_candidate_file_IETF {
  my ($level,$auditFile) = @_;

  $rtnValueEval = 1;


  $outFile = "1222/1222-authentication-error.html";
  $inXSL = "$MESA_TARGET/runtime/MESA-ATNA.xsl";

  $rtnValueEval = mesa_xml::performXSLTransform($level, $outFile, $auditFile, $inXSL,
"");

  $diff += $rtnValueEval;
}


sub evaluate_candidate_file {
  my $level = shift(@_);
  my $auditFile = shift(@_);

  $rtnValueEval = 1;

  print "\nEvaluating $auditFile\n";
  print LOG "\nEvaluating $auditFile\n";
  my $x = "$MESA_TARGET/bin/mesa_audit_eval -t NODE_AUTHENTICATION_FAILURE ";
  $x .= " -l $level ";
  $x .= " $auditFile";

  print LOG "$x \n";
  print LOG `$x`;
  if ($? == 0) {
    $rtnValueEval = 0;
  } else {
    print LOG "Audit Record (NODE_AUTHENTICATION_FAILURE) $auditFile does not pass evaluation.\n";
  }

  $diff += $rtnValueEval;
}

if (scalar(@ARGV) != 2) {
  die "Usage: <log level> <IETF or INTERIM>";
  exit 1;
}
$outputLevel = $ARGV[0];
$logSchema   = $ARGV[1];

open LOG, ">1222/grade_server_1222.txt" or die "?!";
$diff = 0;

if ($logSchema eq "INTERIM") {
 evaluate_candidate_file($outputLevel, "$MESA_TARGET/logs/syslog/last_log.txt");
} elsif ($logSchema eq "IETF") {
 evaluate_candidate_file_IETF($outputLevel, "$MESA_TARGET/logs/syslog/last_log.txt");
 print LOG "As part of evaluation, submit 1222/1222-authentication-error.html\n";
 print "As part of evaluation, submit 1222/1222-authentication-error.html\n";
} else {
 print "Log schema specified is $logSchema\n";
 print " Should be INTERIM or IETF\n";
 $diff = 1;
}


print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1222/grade_server_1222.txt \n";

exit $diff;
