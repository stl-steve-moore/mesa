#!/usr/local/bin/perl -w

# Script to clear MESA log files for secure node tests

use Env;
use File::Copy;
use lib "../secure_node/scripts";
require secure;

sub goodbye {
  exit 0;
}

secure::rm_file("$MESA_TARGET/logs/tls_client.log");

secure::rm_file("$MESA_TARGET/logs/tls_server.log");

secure::rm_file("$MESA_TARGET/logs/imgmgr.log");
