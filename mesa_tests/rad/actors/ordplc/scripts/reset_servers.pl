#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use lib "scripts";
require ordplc;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

print "$MESA_TARGET/bin/kill_hl7 -e RST localhost 2100 \n";
print `$MESA_TARGET/bin/kill_hl7 -e RST localhost 2100`;

print "$MESA_TARGET/bin/kill_hl7 -e RST localhost 2200 \n";
print `$MESA_TARGET/bin/kill_hl7 -e RST localhost 2200`;

goodbye;


