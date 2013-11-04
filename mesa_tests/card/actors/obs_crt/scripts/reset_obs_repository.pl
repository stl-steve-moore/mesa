#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;
use lib "../../../common/scripts";
require mesa_utility;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

#$dir = cwd();

#chdir ("$MESA_TARGET/db");
#print "Clearing Observation Repository database \n";
#print `perl ClearImgMgrTables.pl imgmgr`;
#print `perl load_apps.pl imgmgr`;

#print "Clearing Syslog database \n";
#`perl ClearSyslogTables.pl syslog`;

#chdir ($dir);

if ($MESA_OS eq "WINDOWS_NT") {
 #mesa_utility::delete_directory("$MESA_STORAGE\\imgmgr\\mpps");
 #mesa_utility::create_directory("$MESA_STORAGE\\imgmgr\\mpps");

 #mesa_utility::delete_directory("$MESA_STORAGE\\imgmgr\\instances");
 #mesa_utility::create_directory("$MESA_STORAGE\\imgmgr\\instances");

 #mesa_utility::delete_directory("$MESA_STORAGE\\imgmgr\\commit");
 #mesa_utility::create_directory("$MESA_STORAGE\\imgmgr\\commit");

 #mesa_utility::delete_directory("$MESA_STORAGE\\imgmgr\\queries");
 #mesa_utility::create_directory("$MESA_STORAGE\\imgmgr\\queries");
 
 mesa_utility::delete_directory(1, "$MESA_STORAGE\\imgmgr\\hl7");
 mesa_utility::create_directory(1, "$MESA_STORAGE\\imgmgr\\hl7");

} else {
 #mesa_utility::delete_directory("$MESA_STORAGE/imgmgr/mpps");
 #mesa_utility::create_directory("$MESA_STORAGE/imgmgr/mpps");

 #mesa_utility::delete_directory("$MESA_STORAGE/imgmgr/instances");
 #mesa_utility::create_directory("$MESA_STORAGE/imgmgr/instances");

 #mesa_utility::delete_directory("$MESA_STORAGE/imgmgr/commit");
 #mesa_utility::create_directory("$MESA_STORAGE/imgmgr/commit");

 #mesa_utility::delete_directory("$MESA_STORAGE/imgmgr/queries");
 #mesa_utility::create_directory("$MESA_STORAGE/imgmgr/queries");
 
 mesa_utility::delete_directory(1, "$MESA_STORAGE/imgmgr/hl7");
 mesa_utility::create_directory(1, "$MESA_STORAGE/imgmgr/hl7");
 
}

#reset the hl7 server counter
`$MESA_TARGET/bin/kill_hl7 -e RST localhost 2750`;
#`$MESA_TARGET/bin/kill_hl7 -e RST localhost 2800`;

goodbye;

