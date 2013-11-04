#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;
use lib "scripts";
require imgcrt;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

($mesaOFPortDICOM, $mesaOFPortHL7, $mesaImgMgrPortDICOM, $mesaImgMgrPortHL7, $mesaModPortDICOM,
 $mppsHost, $mppsPort, $mppsAE,
 $imCStoreHost, $imCStorePort, $imCStoreAE,
 $imCFindHost, $imCFindPort, $imCFindAE,
 $imCommitHost, $imCommitPort, $imCommitAE,
 $imHL7Host, $imHL7Port) = imgcrt::read_config_params("imgcrt_test.cfg");

print "Bad MESA Filler params $mesaOFPortDICOM $mesaOFPortHL7 \n" if ($mesaOFPortDICOM == 0);
print "Bad MESA Image Mgr params $mesaImgMgrPortDICOM $mesaImgMgrPortHL7\n" if ($mesaImgMgrPortDICOM == 0);
print "Bad MESA Modality params $mesaModPortDICOM \n" if ($mesaModPortDICOM == 0);

print "Bad MPPS parameters ($mppsHost $mppsPort $mppsAE)\n" if ($mppsPort == 0);
print "Bad C-Store parameters ($imCStoreHost $imCStorePort $imCStoreAE)\n" if ($imCStorePort == 0);
print "Bad C-Find parameters ($imCFindHost $imCFindPort $imCFindAE)\n" if ($imCFindPort == 0);
print "Bad Storage Commitment parameters ($imCommitHost $imCommitPort $imCommitAE)\n" if ($imCommitPort == 0);
print "Bad Image Mgr HL7 parameters ($imHL7Host $imHL7Port)\n" if ($imHL7Port == 0);


print `$MESA_TARGET/bin/kill_hl7 -e RST "localhost" $mesaOFPortHL7`;
print `$MESA_TARGET/bin/kill_hl7 -e RST "localhost" $mesaImgMgrPortHL7`;

$dir = cwd();
chdir ("$MESA_TARGET/db");
print "Clearing Order Filler database \n";
`perl ClearOrdFilContent.pl ordfil`;

print "Clearing Post Processing database \n";
`perl ClearPostProcContent.pl imgmgr`;

print "Clearing Image Manager database \n";
`perl ClearImgMgrTables.pl imgmgr`;
`perl ./load_apps.pl imgmgr`;

print "Clearing Syslog database \n";
`perl ClearSyslogTables.pl syslog`;


chdir ($dir);

if ($MESA_OS eq "WINDOWS_NT") {
 imgcrt::delete_directory("$MESA_STORAGE\\imgmgr\\mpps");
 imgcrt::create_directory("$MESA_STORAGE\\imgmgr\\mpps");

 imgcrt::delete_directory("$MESA_STORAGE\\imgmgr\\instances");
 imgcrt::create_directory("$MESA_STORAGE\\imgmgr\\instances");

 imgcrt::delete_directory("$MESA_STORAGE\\imgmgr\\commit");
 imgcrt::create_directory("$MESA_STORAGE\\imgmgr\\commit");

 imgcrt::delete_directory("$MESA_STORAGE\\imgmgr\\queries");
 imgcrt::create_directory("$MESA_STORAGE\\imgmgr\\queries");

 imgcrt::delete_directory("$MESA_STORAGE\\ordfil\\mpps");
 imgcrt::create_directory("$MESA_STORAGE\\ordfil\\mpps");

 imgcrt::delete_directory("$MESA_STORAGE\\modality\\st_comm");
 imgcrt::create_directory("$MESA_STORAGE\\modality\\st_comm");

} else {

 imgcrt::delete_directory("$MESA_STORAGE/imgmgr/mpps");
 imgcrt::create_directory("$MESA_STORAGE/imgmgr/mpps");

 imgcrt::delete_directory("$MESA_STORAGE/imgmgr/instances");
 imgcrt::create_directory("$MESA_STORAGE/imgmgr/instances");

 imgcrt::delete_directory("$MESA_STORAGE/imgmgr/commit");
 imgcrt::create_directory("$MESA_STORAGE/imgmgr/commit");

 imgcrt::delete_directory("$MESA_STORAGE/imgmgr/queries");
 imgcrt::create_directory("$MESA_STORAGE/imgmgr/queries");

 imgcrt::delete_directory("$MESA_STORAGE/ordfil/mpps");
 imgcrt::create_directory("$MESA_STORAGE/ordfil/mpps");

 imgcrt::delete_directory("$MESA_STORAGE/modality/st_comm");
 imgcrt::create_directory("$MESA_STORAGE/modality/st_comm");
}
goodbye;

