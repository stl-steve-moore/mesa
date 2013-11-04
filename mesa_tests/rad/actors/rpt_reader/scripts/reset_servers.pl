#!/usr/local/bin/perl -w

# Reset MESA servers for Report Reader tests.

use Env;
use Cwd;
use lib "scripts";
require rpt_reader;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

$dir = cwd();

chdir ("$MESA_TARGET/db");
print "Clearing Image Manager database \n";
print `perl ClearImgMgrTables.pl imgmgr`;
print `perl load_apps.pl imgmgr`;

print "Clearing Report Repository database \n";
print `perl ClearImgMgrTables.pl rpt_repos`;
print `perl load_apps.pl rpt_repos`;

chdir ($dir);

rpt_reader::delete_directory("$MESA_STORAGE/imgmgr/instances");
rpt_reader::create_directory("$MESA_STORAGE/imgmgr/instances");

rpt_reader::delete_directory("$MESA_STORAGE/imgmgr/queries");
rpt_reader::create_directory("$MESA_STORAGE/imgmgr/queries");

rpt_reader::delete_directory("$MESA_STORAGE/rpt_repos/instances");
rpt_reader::create_directory("$MESA_STORAGE/rpt_repos/instances");

rpt_reader::delete_directory("$MESA_STORAGE/rpt_repos/queries");
rpt_reader::create_directory("$MESA_STORAGE/rpt_repos/queries");

goodbye;

