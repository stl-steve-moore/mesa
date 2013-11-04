#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;
use lib "scripts";
require rpt_mgr;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

$dir = cwd();

chdir ("$MESA_TARGET/db");
print "Clearing Report Repository database \n";
print `perl ClearImgMgrTables.pl rpt_repos`;
print `perl load_apps.pl rpt_repos`;

print "Clearing Report Manager database \n";
print `perl ClearImgMgrTables.pl rpt_manager`;
print `perl load_apps.pl rpt_manager`;

chdir ($dir);

if ($MESA_OS eq "WINDOWS_NT") {
 rpt_mgr::delete_directory("$MESA_STORAGE\\rpt_repos\\instances");
 rpt_mgr::create_directory("$MESA_STORAGE\\rpt_repos\\instances");

 rpt_mgr::delete_directory("$MESA_STORAGE\\rpt_manager\\instances");
 rpt_mgr::create_directory("$MESA_STORAGE\\rpt_manager\\instances");

} else {
 rpt_mgr::delete_directory("$MESA_STORAGE/rpt_repos/instances");
 rpt_mgr::create_directory("$MESA_STORAGE/rpt_repos/instances");

 rpt_mgr::delete_directory("$MESA_STORAGE/rpt_manager/instances");
 rpt_mgr::create_directory("$MESA_STORAGE/rpt_manager/instances");

}
goodbye;

