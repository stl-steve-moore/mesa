#!/usr/local/bin/perl -w

# Sends reset messages to MESA Workstation servers.
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
print "Clearing Workstation database \n";
print `perl ClearImgMgrTables.pl wkstation`;
print `perl load_apps.pl wkstation`;

chdir ($dir);

rpt_repos::delete_directory("$MESA_STORAGE/wkstation/instances");
rpt_repos::create_directory("$MESA_STORAGE/wkstation/instances");

goodbye;

