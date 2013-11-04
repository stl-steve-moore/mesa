#!/usr/bin/perl -w

# allow the script to be started from the scripts directory,
# but "cd .." if it is.
use Cwd;

sub goodbye {
}

$dir = cwd;
if ($dir =~ /scripts$/) {
  chdir "..";
}

use Env;
use lib "scripts";
require imgmgr;

$loglevel = 1;

# The file "runningServer.cfg" will be used to get the port numbers
# needed to kill the servers.  This is a copy of the configuration file
# used when the servers were started (the configuration file might have
# changed since then).  If this file does not exist, then use the normal
# configuration file.  The "runningServer.cfg" file will be deleted.

if (-e "runningServer.cfg") {
  %params = mesa::get_config_params("runningServer.cfg");
  unlink("runningServer.cfg");
} else {
  warn "File runningServer.cfg not found.\n";
  %params = mesa::get_config_params("imgmgr_test.cfg");
}

if ($#ARGV >= 0) {
  $loglevel = $ARGV[0]; 
}

# Add the configuration variables to the environment variables
%ENV = (%ENV, %params);

$ENV{LOGLEVEL} = $loglevel;

if ($MESA_OS eq "WINDOWS_NT") {
  exec ("scripts\\stop_mesa_servers.bat");
} else {
  exec ("scripts/stop_mesa_servers.csh");
}
