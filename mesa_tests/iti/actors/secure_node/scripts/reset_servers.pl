#!/usr/local/bin/perl -w

# Clear files from SN servers
use Env;
use lib "scripts";
use lib "../../../common/scripts";
require mesa_common;
require mesa_utility;


$SIG{INT} = \&goodbye;

sub goodbye () {
  print "Exiting...\n";

  exit 0;
}


mesa_utility::delete_file(4, "$MESA_TARGET/logs/syslog/last_log.xml");
mesa_utility::delete_file(4, "$MESA_TARGET/logs/syslog/last_log.txt");

