#!/usr/local/bin/perl -w

# Script to clear MESA database entries

use Env;
use File::Copy;
use lib "scripts";
require audit;

sub goodbye {
  exit 0;
}

chdir "$MESA_TARGET/db";
`perl ./ClearSyslogTables.pl syslog`;

