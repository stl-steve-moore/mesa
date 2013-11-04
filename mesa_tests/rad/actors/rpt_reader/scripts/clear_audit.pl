#!/usr/local/bin/perl -w

# Script clears the Audit Record Repository of its DB entries.

use Env;
use Cwd;
use lib "scripts";
require rpt_reader;

$SIG{INT} = \&goodbye;

sub goodbye {
  exit 0;
}

$dir = cwd();
chdir "$MESA_TARGET/db";
`perl ./ClearSyslogTables.pl syslog`;
chdir $dir;

