#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;
use lib "scripts";
require imgmgr;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

($mesaOFPortDICOM, $mesaOFPortHL7, $mesaImgMgrPortDICOM, $mesaImgMgrPortHL7, $mesaModPortDICOM,
 $mppsHost, $mppsPort, $mppsAE,
 $imCStoreHost, $imCStorePort, $imCStoreAE,
 $imCFindHost, $imCFindPort, $imCFindAE,
 $imCommitHost, $imCommitPort, $imCommitAE,
 $imHL7Host, $imHL7Port) = imgmgr::read_config_params("imgmgr_test.cfg");

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

print "Clearing Workstation database \n";
`perl ClearImgMgrTables.pl wkstation`;
`perl ./load_apps.pl wkstation`;

print "Clearing Syslog database \n";
`perl ClearSyslogTables.pl syslog`;


chdir ($dir);

mesa::rm_files("$MESA_TARGET/logs/send_hl7.log") if (-e "$MESA_TARGET/logs/send_hl7.log");
mesa::rm_files("hl7stream.xxx") if (-e "hl7stream.xxx");

if ($MESA_OS eq "WINDOWS_NT") {
 mesa::delete_directory(1, "$MESA_STORAGE\\imgmgr\\ian");
 mesa::create_directory(1, "$MESA_STORAGE\\imgmgr\\ian");

 mesa::delete_directory(1, "$MESA_STORAGE\\imgmgr\\mpps");
 mesa::create_directory(1, "$MESA_STORAGE\\imgmgr\\mpps");

 mesa::delete_directory(1, "$MESA_STORAGE\\imgmgr\\instances");
 mesa::create_directory(1, "$MESA_STORAGE\\imgmgr\\instances");

 mesa::delete_directory(1, "$MESA_STORAGE\\imgmgr\\commit");
 mesa::create_directory(1, "$MESA_STORAGE\\imgmgr\\commit");

 mesa::delete_directory(1, "$MESA_STORAGE\\imgmgr\\queries");
 mesa::create_directory(1, "$MESA_STORAGE\\imgmgr\\queries");

 mesa::delete_directory(1, "$MESA_STORAGE\\ordfil\\ian");
 mesa::create_directory(1, "$MESA_STORAGE\\ordfil\\ian");

 mesa::delete_directory(1, "$MESA_STORAGE\\ordfil\\mpps");
 mesa::create_directory(1, "$MESA_STORAGE\\ordfil\\mpps");

 mesa::delete_directory(1, "$MESA_STORAGE\\modality\\st_comm");
 mesa::create_directory(1, "$MESA_STORAGE\\modality\\st_comm");

 mesa::delete_directory(1, "$MESA_STORAGE\\wkstation\\ian");
 mesa::create_directory(1, "$MESA_STORAGE\\wkstation\\ian");

 mesa::delete_directory(1, "$MESA_STORAGE\\wkstation\\mpps");
 mesa::create_directory(1, "$MESA_STORAGE\\wkstation\\mpps");

 mesa::delete_directory(1, "$MESA_STORAGE\\wkstation\\instances");
 mesa::create_directory(1, "$MESA_STORAGE\\wkstation\\instances");

 mesa::delete_directory(1, "$MESA_STORAGE\\wkstation\\commit");
 mesa::create_directory(1, "$MESA_STORAGE\\wkstation\\commit");

 mesa::delete_directory(1, "$MESA_STORAGE\\wkstation\\queries");
 mesa::create_directory(1, "$MESA_STORAGE\\wkstation\\queries");

 mesa::delete_directory(1, "$MESA_STORAGE\\tmp") if (-e "$MESA_STORAGE\\tmp");
 mesa::create_directory(1, "$MESA_STORAGE\\tmp");

} else {

 mesa::delete_directory(1, "$MESA_STORAGE/imgmgr/ian");
 mesa::create_directory(1, "$MESA_STORAGE/imgmgr/ian");

 mesa::delete_directory(1, "$MESA_STORAGE/imgmgr/mpps");
 mesa::create_directory(1, "$MESA_STORAGE/imgmgr/mpps");

 mesa::delete_directory(1, "$MESA_STORAGE/imgmgr/instances");
 mesa::create_directory(1, "$MESA_STORAGE/imgmgr/instances");

 mesa::delete_directory(1, "$MESA_STORAGE/imgmgr/commit");
 mesa::create_directory(1, "$MESA_STORAGE/imgmgr/commit");

 mesa::delete_directory(1, "$MESA_STORAGE/imgmgr/queries");
 mesa::create_directory(1, "$MESA_STORAGE/imgmgr/queries");

 mesa::delete_directory(1, "$MESA_STORAGE/ordfil/ian");
 mesa::create_directory(1, "$MESA_STORAGE/ordfil/ian");

 mesa::delete_directory(1, "$MESA_STORAGE/ordfil/mpps");
 mesa::create_directory(1, "$MESA_STORAGE/ordfil/mpps");

 mesa::delete_directory(1, "$MESA_STORAGE/modality/st_comm");
 mesa::create_directory(1, "$MESA_STORAGE/modality/st_comm");

 mesa::delete_directory(1, "$MESA_STORAGE/wkstation/ian");
 mesa::create_directory(1, "$MESA_STORAGE/wkstation/ian");

 mesa::delete_directory(1, "$MESA_STORAGE/wkstation/mpps");
 mesa::create_directory(1, "$MESA_STORAGE/wkstation/mpps");

 mesa::delete_directory(1, "$MESA_STORAGE/wkstation/instances");
 mesa::create_directory(1, "$MESA_STORAGE/wkstation/instances");

 mesa::delete_directory(1, "$MESA_STORAGE/wkstation/commit");
 mesa::create_directory(1, "$MESA_STORAGE/wkstation/commit");

 mesa::delete_directory(1, "$MESA_STORAGE/wkstation/queries");
 mesa::create_directory(1, "$MESA_STORAGE/wkstation/queries");

 mesa::delete_directory(1, "$MESA_STORAGE/tmp") if (-e "$MESA_STORAGE/tmp");
 mesa::create_directory(1, "$MESA_STORAGE/tmp");
}
goodbye;

