#!/usr/local/bin/perl -w

# Sends ADT messages to MESA servers as a self-test.
use Env;
use lib "scripts";
require adt;

$SIG{INT} = \&goodbye;

sub goodbye () {
  print "Exiting...\n";

  exit 0;
}

($ofPort, $ofHost, $opPort, $opHost) = adt::read_config_params();

unlink "$MESA_TARGET/logs/of_hl7ps.log";
unlink "$MESA_TARGET/logs/op_hl7ps.log";

print `$MESA_TARGET/bin/kill_hl7 -e RST localhost $opPort`;
print `$MESA_TARGET/bin/kill_hl7 -e RST localhost $ofPort`;

@msgs = ("105.102.a04.hl7",
	"105.120.a08.hl7");

foreach $msg (@msgs) {
  $x = adt::send_adt("../../msgs/adt/105", $msg, $opHost, $opPort);
  adt::xmit_error($msg) if ($x == 0);

  $x = adt::send_adt("../../msgs/adt/105", $msg, $ofHost, $ofPort);
  adt::xmit_error($msg) if ($x == 0);
}

goodbye;
