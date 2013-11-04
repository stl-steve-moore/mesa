#!/usr/local/bin/perl -w

# This script sends one Encapsulated PDF document to an Image Display

use Env;
use Cwd;
#use lib "scripts";
use lib "../common/scripts";
use lib "../../../common/scripts";
#require imgdisp;
#require mesa;
require mesa_common;

 $x = "perl scripts/reset_servers.pl";
 `$x`;
 die "Could not rest servers ($x)\n" if ($?);

 $title = "MESA_IM";
 $host  = "localhost";
 $port  = 2350;

 $path = "$MESA_STORAGE/EYECARE/PDF1/pdf1.dcm";
 $deltaFile = "";
 $x = mesa_xmit::sendCStoreDirectory(4, $deltaFile, $path, "MESA",
	$title, $host, $port, 0);
 die "Could not transmit $path\n" if ($x != 0);

 $path = "$MESA_STORAGE/modality/OP/OP1/OP1S1";
 $deltaFile = "";
 $x = mesa_xmit::sendCStoreDirectory(4, $deltaFile, $path, "MESA",
	$title, $host, $port, 0);
 die "Could not transmit $path\n" if ($x != 0);

 exit 0;
