#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;
use lib "scripts";
require mod;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

print `$MESA_TARGET/bin/kill_hl7 -e RST "localhost" 2200`;
print `$MESA_TARGET/bin/kill_hl7 -e RST "localhost" 2300`;

$dir = cwd();
chdir ("$MESA_TARGET/db");
print "Clearing Order Filler database \n";
`perl ClearOrdFilContent.pl ordfil`;

print "Clearing Image Manager database \n";
`perl ClearImgMgrTables.pl imgmgr`;

chdir ($dir);

if ($MESA_OS eq "WINDOWS_NT") {
 mod::delete_directory("$MESA_STORAGE\\imgmgr\\mpps");
 mod::create_directory("$MESA_STORAGE\\imgmgr\\mpps");

 mod::delete_directory("$MESA_STORAGE\\imgmgr\\instances");
 mod::create_directory("$MESA_STORAGE\\imgmgr\\instances");

 mod::delete_directory("$MESA_STORAGE\\imgmgr\\commit");
 mod::create_directory("$MESA_STORAGE\\imgmgr\\commit");

 mod::delete_directory("$MESA_STORAGE\\imgmgr\\queries");
 mod::create_directory("$MESA_STORAGE\\imgmgr\\queries");
} else {
 mod::delete_directory("$MESA_STORAGE/imgmgr/mpps");
 mod::create_directory("$MESA_STORAGE/imgmgr/mpps");

 mod::delete_directory("$MESA_STORAGE/imgmgr/instances");
 mod::create_directory("$MESA_STORAGE/imgmgr/instances");

 mod::delete_directory("$MESA_STORAGE/imgmgr/commit");
 mod::create_directory("$MESA_STORAGE/imgmgr/commit");

 mod::delete_directory("$MESA_STORAGE/imgmgr/queries");
 mod::create_directory("$MESA_STORAGE/imgmgr/queries");
}
goodbye;

