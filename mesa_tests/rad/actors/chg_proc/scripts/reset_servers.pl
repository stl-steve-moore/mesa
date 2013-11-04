#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}


# Charge Processor
print `$MESA_TARGET/bin/kill_hl7 -e RST "localhost" 2150`;

# Charge Processor
print `$MESA_TARGET/bin/kill_hl7 -e RST "localhost" 2200`;

goodbye;


