#!/usr/local/bin/perl -w

# Evaluation script for client test 1222.
# Client has connected to a system that offers an unregistered certificate.

use Env;

use lib "scripts";
use lib "../common/scripts";
require secure;
require mesa;
require mesa_xml;

sub goodbye() {
  exit 1;
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

sub evaluate_candidate_file_IETF {
  my ($level,$auditFile) = @_;

  $rtnValueEval = 1;


  $outFile = "1222/1222-authentication-error.html";
  $inXSL = "$MESA_TARGET/runtime/MESA-ATNA.xsl";

  $rtnValueEval = mesa_xml::performXSLTransform($level, $outFile, $auditFile, $inXSL, 
"");

  $diff += $rtnValueEval;
}

if (scalar(@ARGV) != 3) {
  die "Usage: <log> <IETF or INTERIM> FILE";
  exit 1;
}
$outputLevel = $ARGV[0];
$logSchema   = $ARGV[1];
$logFile     = $ARGV[2];

open LOG, ">1222/grade_client_1222.txt" or die "?!";
$diff = 0;
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";
print LOG "CTX: Test 1222\n";
print LOG "CTX: $logSchema $logFile\n";

if ($logSchema eq "INTERIM") {
 evaluate_candidate_file($outputLevel, $logFile);
} elsif ($logSchema eq "IETF") {
 evaluate_candidate_file_IETF($outputLevel, $logFile);
 print LOG "As part of evaluation, submit 1222/1222-authentication-error.html\n";
 print "As part of evaluation, submit 1222/1222-authentication-error.html\n";
} else {
 print "Schema type entered was $logSchema\n";
 print " Should be INTERIM or IETF\n";
 $diff = 1;
}

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 1222/grade_client_1222.txt \n";

exit $diff;
