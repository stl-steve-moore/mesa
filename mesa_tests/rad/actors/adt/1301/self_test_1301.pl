#!/usr/local/bin/perl -w

# Sends BAR messages to MESA servers as a self-test.
use Env;
use lib "scripts";
use lib "../common/scripts";
require adt;
require mesa;

$SIG{INT} = \&goodbye;

sub goodbye () {
  print "Exiting...\n";

  exit 0;
}

#($ofPort, $ofHost, $opPort, $opHost) = adt::read_config_params();

unlink "$MESA_TARGET/logs/cp_hl7ps.log";
unlink "$MESA_TARGET/logs/of_hl7ps.log";
unlink "$MESA_TARGET/logs/op_hl7ps.log";

print `$MESA_TARGET/bin/kill_hl7 -e RST localhost 2100`;
print `$MESA_TARGET/bin/kill_hl7 -e RST localhost 2150`;
print `$MESA_TARGET/bin/kill_hl7 -e RST localhost 2200`;

@msgs = ("1301.102.p01.hl7");

foreach $msg (@msgs) {
  $x = mesa::send_hl7("../../msgs/chg/1301", $msg, "localhost", "2150");
  mesa::xmit_error($msg) if ($x != 0);
}

goodbye;
