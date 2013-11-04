#!/usr/local/bin/perl -w

# Self test for Order Placer exam 105.  Sends Order Placer messages
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

$x = ordplc::send_hl7("../../msgs/order/105", "105.116.o02.hl7", "localhost", $ofPort);
ordplc::xmit_error("105.116.o02.hl7") if ($x == 0);

goodbye;
