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
print "Clearing Report Manager database \n";
print `perl ClearImgMgrTables.pl rpt_manager`;
print `perl load_apps.pl rpt_manager`;

print "Clearing Syslog database \n";
`perl ClearSyslogTables.pl syslog`;

chdir ($dir);

if ($MESA_OS eq "WINDOWS_NT") {
 rpt_crt::delete_directory("$MESA_STORAGE\\rpt_manager\\mpps");
 rpt_crt::create_directory("$MESA_STORAGE\\rpt_manager\\mpps");

 rpt_crt::delete_directory("$MESA_STORAGE\\rpt_manager\\instances");
 rpt_crt::create_directory("$MESA_STORAGE\\rpt_manager\\instances");

 rpt_crt::delete_directory("$MESA_STORAGE\\rpt_manager\\commit");
 rpt_crt::create_directory("$MESA_STORAGE\\rpt_manager\\commit");

 rpt_crt::delete_directory("$MESA_STORAGE\\rpt_manager\\queries");
 rpt_crt::create_directory("$MESA_STORAGE\\rpt_manager\\queries");

} else {

 rpt_crt::delete_directory("$MESA_STORAGE/rpt_manager/mpps");
 rpt_crt::create_directory("$MESA_STORAGE/rpt_manager/mpps");

 rpt_crt::delete_directory("$MESA_STORAGE/rpt_manager/instances");
 rpt_crt::create_directory("$MESA_STORAGE/rpt_manager/instances");

 rpt_crt::delete_directory("$MESA_STORAGE/rpt_manager/commit");
 rpt_crt::create_directory("$MESA_STORAGE/rpt_manager/commit");

 rpt_crt::delete_directory("$MESA_STORAGE/rpt_manager/queries");
 rpt_crt::create_directory("$MESA_STORAGE/rpt_manager/queries");

}
goodbye;

