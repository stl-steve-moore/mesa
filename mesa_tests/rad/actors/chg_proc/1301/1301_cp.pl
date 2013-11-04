#!/usr/local/bin/perl -w

# Runs Charge Processor exam 1301 interactively.

use Env;
use File::Copy;
use lib "scripts";
use lib "../common/scripts";
require chgp;
require mesa;

# Find hostname of this machine
$host = `hostname`; chomp $host;

$SIG{INT} = \&goodbye;

sub goodbye () {
  #Kill the MESA servers and exit
  print "Exiting...\n";

  exit 0;
}

sub clear_MESA {
  print `perl scripts/reset_servers.pl`;
}

sub announce_test {
 print "\n" .
"This is Charge Processor test 1301. You will receive 3 HL7 \n" .
" messages from the MESA actors and then be asked to answer \n" .
" some questions.\n";
}


sub announce_end {
  print "\n" .
"This marks the end of Charge Processor test 1301.\n" .
" Please complete the question in charge_questions.txt \n" .
" and send the response to the project manager.\n";
}


# ===================================
# Main starts here

print "\n";

# Set Machine names and port numbers

print "This script is now deprecated. Test 1301 has changed \n" .
      " and the test mechanism is different. Please refer to \n" .
      " the Charge Processor test documentation.\n";
exit 1;

($chgPortHL7, $chgHostHL7)
 = chgp::read_config_params("chgp_test.cfg");

die "Empty Charge Processor Port" if ($chgPortHL7 eq "");

clear_MESA;

announce_test;

mesa::announce_p01("ALABAMA");
$x = mesa::send_hl7("../../msgs/chg/1301", "1301.102.p01.hl7", $chgHostHL7, $chgPortHL7);
mesa::xmit_error("1301.102.p01.hl7") if ($x != 0);

mesa::announce_p03("ALABAMA", "Technical");
$x = mesa::send_hl7("../../msgs/chg/1301", "1301.126.p03.hl7", $chgHostHL7, $chgPortHL7);
mesa::xmit_error("1301.126.p03.hl7") if ($x != 0);

mesa::announce_p03("ALABAMA", "Professional");
$x = mesa::send_hl7("../../msgs/chg/1301", "1301.128.p03.hl7", $chgHostHL7, $chgPortHL7);
mesa::xmit_error("1301.128.p03.hl7") if ($x != 0);

announce_end;

goodbye;

