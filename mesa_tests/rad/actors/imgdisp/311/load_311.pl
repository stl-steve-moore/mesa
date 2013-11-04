#!/usr/local/bin/perl -w

# This script sends one Encapsulated PDF document to an Image Display

use Env;
use Cwd;
use lib "scripts";
use lib "../common/scripts";
use lib "../../../common/scripts";
require imgdisp;
require mesa;
require mesa_common;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

 if (scalar(@ARGV) != 3) {
  print "Usage: 311/load_311.pl.pl title host port\n".
	" title    AE title of Image Display\n".
	" host     Host name or IP address of Image Display\n".
	" port     Port number of DICOM Storage SCP\n";
  exit 1;
 }

 $title = $ARGV[0];
 $host  = $ARGV[1];
 $port  = $ARGV[2];

 $path = "$MESA_STORAGE/EYECARE/PDF1/pdf1.dcm";
# $x = mesa::cstore_file($fileName, "", $title, $host, $port);
 $deltaFile = "";
 $x = mesa_xmit::sendCStoreDirectory(4, $deltaFile, $path, "MESA",
	$title, $host, $port, 0);
 die "Could not transmit $path\n" if ($x != 0);

 exit 0;
