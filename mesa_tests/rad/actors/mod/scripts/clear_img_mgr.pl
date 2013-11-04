#!/usr/local/bin/perl -w

# Clears MESA Image Manager for Modality tests.

use Env;
use Cwd;
use lib "scripts";
require mod;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

$dir = cwd();
chdir ("$MESA_TARGET/db");

print "Clearing Image Manager database \n";
print `perl ClearImgMgrTables.pl imgmgr`;


chdir ($dir);

mod::delete_directory("$MESA_STORAGE/imgmgr/mpps");
mod::create_directory("$MESA_STORAGE/imgmgr/mpps");

mod::delete_directory("$MESA_STORAGE/imgmgr/instances");
mod::create_directory("$MESA_STORAGE/imgmgr/instances");

mod::delete_directory("$MESA_STORAGE/imgmgr/commit");
mod::create_directory("$MESA_STORAGE/imgmgr/commit");

mod::delete_directory("$MESA_STORAGE/imgmgr/queries");
mod::create_directory("$MESA_STORAGE/imgmgr/queries");

mod::delete_directory("$MESA_STORAGE/ordfil/mpps");
mod::create_directory("$MESA_STORAGE/ordfil/mpps");

mod::delete_file("$MESA_TARGET/logs/imgmgr.log");
mod::delete_file("$MESA_TARGET/logs/im_hl7ps.log");

exit 0;

