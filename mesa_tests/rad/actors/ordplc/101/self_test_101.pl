#!/usr/local/bin/perl -w

# Self test for Order Placer exam 101.  Sends Order Placer messages
# to Order Filler in proper order.

use Env;
use lib "scripts";
require ordplc;

$host = `hostname`; chomp $host;



$SIG{INT} = \&goodbye;

sub goodbye () {
  print "Exiting...\n";

  exit 0;
}


($ofPort, $opHost, $opPort) = ordplc::read_config_params("ordplc_test.cfg");
print ("Bad placer host, port $opHost $ofPort \n") if ($opPort == 0);

print `perl scripts/reset_servers.pl`;

$x = ordplc::send_hl7("../../msgs/order/101", "101.104.o01.hl7", "localhost", $ofPort);
ordplc::xmit_error("101.104.o01.hl7") if ($x == 0);

$x = ordplc::send_hl7("../../msgs/order/101", "101.164.o02.hl7", "localhost", $ofPort);
ordplc::xmit_error("101.164.o02.hl7") if ($x == 0);

$x = ordplc::send_hl7("../../msgs/order/101", "101.182.o01.hl7", "localhost", $ofPort);
ordplc::xmit_error("101.182.o01.hl7") if ($x == 0);

$x = ordplc::send_hl7("../../msgs/order/101", "101.188.o01x.hl7", "localhost", $ofPort);
ordplc::xmit_error("101.188.o01x.hl7") if ($x == 0);

$x = ordplc::send_hl7("../../msgs/order/101", "101.192.o01.hl7", "localhost", $ofPort);
ordplc::xmit_error("101.192.o01.hl7") if ($x == 0);

goodbye;
