#!/usr/local/bin/perl -w

# Self test for Order Placer exam 1503.  Sends Order Placer messages
# to Order Filler in proper order.

use Env;
use lib "scripts";
use lib "../common/scripts";
require ordplc;
require mesa;

$host = `hostname`; chomp $host;

$SIG{INT} = \&goodbye;

sub goodbye () {
  print "Exiting...\n";

  exit 0;
}

($ofPort, $opHost, $opPort) = ordplc::read_config_params("ordplc_test_secure.cfg");
print ("Bad placer host, port $opHost $ofPort \n") if ($opPort == 0);
$syslogPortMESA = 4000;

print `perl scripts/reset_servers_secure.pl`;

$x = ordplc::send_hl7_secure("../../msgs/order/103", "103.104.o01.hl7", "localhost", $ofPort,
	"randoms.dat", "test_sys_1.key.pem", "test_sys_1.cert.pem", "mesa_list.cert", "NULL-SHA");
ordplc::xmit_error("103.104.o01.hl7") if ($x == 0);


# Two messages from Order Placer system (Order P1)
mesa::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1503/1503.008", "PATIENT_RECORD");

mesa::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1503/1503.010", "PATIENT_RECORD");

goodbye;
