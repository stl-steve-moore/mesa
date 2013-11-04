#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;
use lib "scripts";
require rpt_repos;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

$dir = cwd();

chdir ("$MESA_TARGET/db");
print "Clearing Report Repository database \n";
print `perl ClearImgMgrTables.pl rpt_repos`;
print `perl load_apps.pl rpt_repos`;

chdir ($dir);

if ($MESA_OS eq "WINDOWS_NT") {
 rpt_repos::delete_directory("$MESA_STORAGE\\rpt_repos\\instances");
 rpt_repos::create_directory("$MESA_STORAGE\\rpt_repos\\instances");
} else {
 rpt_repos::delete_directory("$MESA_STORAGE/rpt_repos/instances");
 rpt_repos::create_directory("$MESA_STORAGE/rpt_repos/instances");
}
goodbye;

