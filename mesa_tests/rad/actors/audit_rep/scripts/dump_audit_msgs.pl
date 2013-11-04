#!/usr/local/bin/perl -w

# Script evaluates all audit XML files found in the log directory.

use Env;

use lib "scripts";
require audit;

sub goodbye() {
  exit 1;
}

sub extract_syslog_messages() {
 $x = "$MESA_TARGET/bin/syslog_extract";
 print "$x \n";
 print `$x`;
 if ($?) {
  die "Could not extract syslog messages from database";
 }
}

sub read_syslog_directory() {
 my $syslogDir = "$MESA_TARGET/logs/syslog";
 opendir SYSLOGDIR, $syslogDir or die "Could not open directory $syslogDir";
 @allFiles = readdir SYSLOGDIR;
 closedir SYSLOGDIR;
}


sub evaluate_candidate_file {
  my $level = shift(@_);
  my $auditFile = shift(@_);

  $rtnValueEval = 1;

  print "\nEvaluating $auditFile\n";
  print LOG "\nEvaluating $auditFile\n";
  my $x = "$MESA_TARGET/bin/mesa_xml_eval ";
  $x .= " -l $level ";
  $x .= " $auditFile";

  print LOG "$x \n";
  print LOG `$x`;
  if ($? == 0) {
    $rtnValueEval = 0;
  } else {
    print LOG "Audit Record $auditFile does not pass evaluation.\n";
  }

  $diff += $rtnValueEval;
}

if (scalar(@ARGV) != 1) {
  print "This script requires one argument: <output level (1-4)> \n";
  exit 1;
}
$outputLevel = $ARGV[0];

open LOG, ">dump_all_audit_msgs.txt" or die "?!";
$diff = 0;

audit::rm_file("$MESA_TARGET/logs/syslog/*.xml");

extract_syslog_messages();

read_syslog_directory();

foreach $candidateFile(@allFiles) {
  if ($candidateFile =~ /.xml/) {
    print "$candidateFile \n";
    evaluate_candidate_file($outputLevel, "$MESA_TARGET/logs/syslog/$candidateFile");
  }
}


print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in dump_all_audit_msgs.txt \n";

exit $diff;
