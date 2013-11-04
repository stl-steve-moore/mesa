#!/usr/local/bin/perl -w

# Test script for test 1201: Audit Record Repository

use Env;
use File::Copy;
use lib "scripts";
require audit;

$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

sub announce_end {
  print "This is the end of Audit Record Repository Test 1201. \n";
  print " Answer the questions for this test in the file audit_questions.txt \n";
  print " and email that file with your responses to the Project Manager. \n";
}


($syslogPortMESA,
 $syslogHostTest, $syslogPortTest) = audit::read_config_params();

print "Illegal MESA Syslog Port: $syslogPortMESA \n" if ($syslogPortMESA == 0);
print "Illegal Test Syslog Host: $syslogHostTest \n" if ($syslogHostTest eq "");
print "Illegal Test Syslog Port: $syslogPortTest \n" if ($syslogPortTest == 0);

$x = "$MESA_TARGET/bin/ihe_audit_message -t STARTUP 1201/startup.txt 1201/startup.xml ";
print "$x \n";
print `$x`;

audit::audit_message_error("1201 STARTUP") if ($? != 0);

$x = "$MESA_TARGET/bin/syslog_client -f 10 -s 0 $syslogHostTest $syslogPortTest 1201/startup.xml";

print "$x \n";
print `$x`;

audit::transmit_error("1201/startup.xml", $syslogHostTest, $syslogPortTest) if ($? != 0);

announce_end();

goodbye;

