#!/usr/bin/perl -w

# allow the script to be started from the scripts directory,
# but "cd .." if it is.
use Cwd;
$dir = cwd;
if ($dir =~ /scripts$/) {
  chdir "..";
}


use Env;
use lib "scripts";
require imgmgr;
use File::Copy;

sub goodbye { }

$loglevel = 1;

$configFile = "imgmgr_test.cfg";
%params = mesa::get_config_params($configFile);

# We make a copy of the configuration file.  This will be used to later kill
# the servers (even if ports, etc. changed in configuration file).
#copy($configFile, "runningServer.cfg");


if ($#ARGV >= 0) {
  $loglevel = $ARGV[0]; 
}

# Add the configuration variables to the environment variables
%ENV = (%ENV, %params);

$ENV{LOGLEVEL} = $loglevel;

if ($MESA_OS eq "WINDOWS_NT") {
  exec ("scripts\\start_mesa_servers.bat");
} else {
  exec ("scripts/start_mesa_servers.csh");
}
