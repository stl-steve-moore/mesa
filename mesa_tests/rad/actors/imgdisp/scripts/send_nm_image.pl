#!/usr/local/bin/perl -w

# This script sends a NM pattern image to an Image Display

use Env;
use Cwd;
use lib "scripts";
use lib "../common/scripts";
require imgdisp;
require mesa;

$SIG{INT} = \&goodbye;

sub goodbye () {
  exit 0;
}

 if (scalar(@ARGV) != 4) {
  print "Usage: send_nm_image.pl name title host port\n".
	" name     Image name (2420, 2421, 2422, ...)\n".
	" title    AE title of Image Display\n".
	" host     Host name or IP address of Image Display\n".
	" port     Port number of DICOM Storage SCP\n";
  exit 1;
 }

 $name = $ARGV[0];
 $title = $ARGV[1];
 $host  = $ARGV[2];
 $port  = $ARGV[3];

 $fileName = "$MESA_STORAGE/modality/NM/patterns/$name.dcm";
 $x = mesa::cstore_file($fileName, "", $title, $host, $port);
 die "Could not transmit $fileName\n" if ($x != 0);

 exit 0;
