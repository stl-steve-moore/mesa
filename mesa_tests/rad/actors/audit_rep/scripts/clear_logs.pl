#!/usr/local/bin/perl -w

# Script to clear MESA log files for Audit Record repository tests

use Env;
use File::Copy;
use lib "scripts";
require audit;

sub goodbye {
  exit 0;
}

audit::rm_file("$MESA_TARGET/logs/tls_server.log");

audit::rm_file("$MESA_TARGET/logs/tls_client.log");

audit::rm_file("$MESA_TARGET/logs/syslog/last_log.txt");

audit::rm_file("$MESA_TARGET/logs/syslog/*.xml");
