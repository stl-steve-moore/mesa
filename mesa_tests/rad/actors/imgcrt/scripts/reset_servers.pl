#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;
use lib "scripts";
require imgcrt;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

print `$MESA_TARGET/bin/kill_hl7 -e RST "localhost" 2300`;

$dir = cwd();

chdir ("$MESA_TARGET/db");
print "Clearing Image Manager database \n";
print `perl ClearImgMgrTables.pl imgmgr`;
print `perl load_apps.pl imgmgr`;

chdir ($dir);

imgcrt::delete_directory("$MESA_STORAGE/imgmgr/mpps");
imgcrt::create_directory("$MESA_STORAGE/imgmgr/mpps");

imgcrt::delete_directory("$MESA_STORAGE/imgmgr/instances");
imgcrt::create_directory("$MESA_STORAGE/imgmgr/instances");

imgcrt::delete_directory("$MESA_STORAGE/imgmgr/commit");
imgcrt::create_directory("$MESA_STORAGE/imgmgr/commit");

imgcrt::delete_directory("$MESA_STORAGE/imgmgr/queries");
imgcrt::create_directory("$MESA_STORAGE/imgmgr/queries");

goodbye;

