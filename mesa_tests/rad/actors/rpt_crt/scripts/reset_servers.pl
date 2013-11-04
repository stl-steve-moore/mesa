#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;
use lib "scripts";
require rpt_crt;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

$dir = cwd();

chdir ("$MESA_TARGET/db");
print "Clearing Image Manager database \n";
print `perl ClearImgMgrTables.pl imgmgr`;
print `perl load_apps.pl imgmgr`;

print "Clearing Report Manager database \n";
`perl ClearImgMgrTables.pl rpt_manager`;

chdir ($dir);

 mesa::delete_directory("0", "$MESA_STORAGE/postproc/gppps");
 mesa::create_directory("0", "$MESA_STORAGE/postproc/gppps");

 mesa::delete_directory("0", "$MESA_STORAGE/imgmgr/mpps");
 mesa::create_directory("0", "$MESA_STORAGE/imgmgr/mpps");

 mesa::delete_directory("0", "$MESA_STORAGE/imgmgr/gppps");
 mesa::create_directory("0", "$MESA_STORAGE/imgmgr/gppps");

 mesa::delete_directory("0", "$MESA_STORAGE/imgmgr/instances");
 mesa::create_directory("0", "$MESA_STORAGE/imgmgr/instances");

 mesa::delete_directory("0", "$MESA_STORAGE/imgmgr/commit");
 mesa::create_directory("0", "$MESA_STORAGE/imgmgr/commit");

 mesa::delete_directory("0", "$MESA_STORAGE/imgmgr/queries");
 mesa::create_directory("0", "$MESA_STORAGE/imgmgr/queries");

goodbye;
