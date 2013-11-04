#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;
use lib "scripts";
require expsel;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

$dir = cwd();
chdir ("$MESA_TARGET/db");

print "Clearing Export Manager database \n";
`perl ClearImgMgrTables.pl expmgr`;
`perl ./load_apps.pl expmgr`;

chdir ($dir);

mesa::delete_directory(1, "$MESA_STORAGE/expmgr/mpps");
mesa::create_directory(1, "$MESA_STORAGE/expmgr/mpps");

mesa::delete_directory(1, "$MESA_STORAGE/expmgr/instances");
mesa::create_directory(1, "$MESA_STORAGE/expmgr/instances");

mesa::delete_directory(1, "$MESA_STORAGE/expmgr/commit");
mesa::create_directory(1, "$MESA_STORAGE/expmgr/commit");

mesa::delete_directory(1, "$MESA_STORAGE/expmgr/queries");
mesa::create_directory(1, "$MESA_STORAGE/expmgr/queries");

goodbye;
