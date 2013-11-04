#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;
use lib "scripts";
use lib "../common/scripts";
require rpt_crt;
require mesa;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

$dir = cwd();

chdir ("$MESA_TARGET/db");
print "Clearing Image Manager database \n";
print `perl ClearImgMgrTables.pl imgmgr`;
print `perl load_apps.pl imgmgr`;

chdir ($dir);

if ($MESA_OS eq "WINDOWS_NT") {
 mesa::delete_directory(1, "$MESA_STORAGE\\imgmgr\\mpps");
 mesa::create_directory(1, "$MESA_STORAGE\\imgmgr\\mpps");

 mesa::delete_directory(1, "$MESA_STORAGE\\imgmgr\\instances");
 mesa::create_directory(1, "$MESA_STORAGE\\imgmgr\\instances");

 mesa::delete_directory(1, "$MESA_STORAGE\\imgmgr\\commit");
 mesa::create_directory(1, "$MESA_STORAGE\\imgmgr\\commit");

 mesa::delete_directory(1, "$MESA_STORAGE\\imgmgr\\queries");
 mesa::create_directory(1, "$MESA_STORAGE\\imgmgr\\queries");

} else {

 mesa::delete_directory(1, "$MESA_STORAGE/imgmgr/mpps");
 mesa::create_directory(1, "$MESA_STORAGE/imgmgr/mpps");

 mesa::delete_directory(1, "$MESA_STORAGE/imgmgr/instances");
 mesa::create_directory(1, "$MESA_STORAGE/imgmgr/instances");

 mesa::delete_directory(1, "$MESA_STORAGE/imgmgr/commit");
 mesa::create_directory(1, "$MESA_STORAGE/imgmgr/commit");

 mesa::delete_directory(1, "$MESA_STORAGE/imgmgr/queries");
 mesa::create_directory(1, "$MESA_STORAGE/imgmgr/queries");

}
goodbye;

