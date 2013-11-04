#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require imgdisp;

$SIG{INT} = \&goodbye;

sub goodbye () {
  #Kill the MESA servers and exit

  print "Exiting...\n";

  exit 1;
}

# End of subroutines, beginning of the main code

$x = $ENV{'MESA_OS'};
die "Env variable MESA_OS is not set; please read Installation Guide \n" if $x eq "";


#/opt/mesa_storage/modality/NM/patterns/2400.dcm
#/opt/mesa_storage/modality/NM/patterns/2402.dcm
#/opt/mesa_storage/modality/NM/patterns/2405.dcm
#/opt/mesa_storage/modality/NM/patterns/2420.dcm
#/opt/mesa_storage/modality/NM/patterns/2422.dcm
#/opt/mesa_storage/modality/NM/patterns/2423.dcm
#/opt/mesa_storage/modality/NM/patterns/2424.dcm

@ images = ("2400.dcm", "2402.dcm", "2405.dcm", "2420.dcm", "2422.dcm",
 "2423.dcm", "2424.dcm");

foreach $im(@images) {
  my $p = "$MESA_STORAGE/modality/NM/patterns/$im";
  print "$p\n";
  imgdisp::cstore_file($p, "", "MESA_IMG_MGR", "localhost", "2350");
}

