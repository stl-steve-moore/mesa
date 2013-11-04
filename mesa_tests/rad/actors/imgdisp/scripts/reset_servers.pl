#!/usr/local/bin/perl -w

# Sends reset messages to MESA servers.
use Env;
use Cwd;
use lib "scripts";
require imgdisp;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

#($mesaOFPortDICOM, $mesaOFPortHL7, $mesaImgMgrPortDICOM, $mesaImgMgrPortHL7, $mesaModPortDICOM,
# $mppsHost, $mppsPort, $mppsAE,
# $imCStoreHost, $imCStorePort, $imCStoreAE,
# $imCFindHost, $imCFindPort, $imCFindAE,
# $imCommitHost, $imCommitPort, $imCommitAE,
# $imHL7Host, $imHL7Port) = imgmgr::read_config_params();
#
#print "Bad MESA Filler params $mesaOFPortDICOM $mesaOFPortHL7 \n" if ($mesaOFPortDICOM == 0);
#print "Bad MESA Image Mgr params $mesaImgMgrPortDICOM $mesaImgMgrPortHL7\n" if ($mesaImgMgrPortDICOM == 0);
#print "Bad MESA Modality params $mesaModPortDICOM \n" if ($mesaModPortDICOM == 0);
#
#print "Bad MPPS parameters ($mppsHost $mppsPort $mppsAE)\n" if ($mppsPort == 0);
#print "Bad C-Store parameters ($imCStoreHost $imCStorePort $imCStoreAE)\n" if ($imCStorePort == 0);
#print "Bad C-Find parameters ($imCFindHost $imCFindPort $imCFindAE)\n" if ($imCFindPort == 0);
#print "Bad Storage Commitment parameters ($imCommitHost $imCommitPort $imCommitAE)\n" if ($imCommitPort == 0);
#print "Bad Image Mgr HL7 parameters ($imHL7Host $imHL7Port)\n" if ($imHL7Port == 0);

#
#print `$MESA_TARGET/bin/kill_hl7 -e RST "localhost" $mesaOFPortHL7`;
print `$MESA_TARGET/bin/kill_hl7 -e RST "localhost" 2300`;

$dir = cwd();

chdir ("$MESA_TARGET/db");
print "Clearing Image Manager database \n";
print `perl ClearImgMgrTables.pl imgmgr`;
print `perl load_apps.pl imgmgr`;

chdir ($dir);

imgdisp::delete_directory("$MESA_STORAGE/imgmgr/mpps");
imgdisp::create_directory("$MESA_STORAGE/imgmgr/mpps");

imgdisp::delete_directory("$MESA_STORAGE/imgmgr/instances");
imgdisp::create_directory("$MESA_STORAGE/imgmgr/instances");

imgdisp::delete_directory("$MESA_STORAGE/imgmgr/commit");
imgdisp::create_directory("$MESA_STORAGE/imgmgr/commit");

imgdisp::delete_directory("$MESA_STORAGE/imgmgr/queries");
imgdisp::create_directory("$MESA_STORAGE/imgmgr/queries");

goodbye;

