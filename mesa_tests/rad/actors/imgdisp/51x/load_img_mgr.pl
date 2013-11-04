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

# Key Image Note goes with CRTHREE^PAUL
imgdisp::cstore_file("../../msgs/sr/511/sr_511_cr.dcm", "", "MESA_IMG_MGR",
			"localhost", "2350");

# Key Image Note goes with CTFIVE^JIM
imgdisp::cstore_file("../../msgs/sr/512/sr_512_ct.dcm", "", "MESA_IMG_MGR",
			"localhost", "2350");

# Key Image Note goes with MRTHREE^STEVE
imgdisp::cstore_file("../../msgs/sr/513/sr_513_mr.dcm", "", "MESA_IMG_MGR",
			"localhost", "2350");

goodbye;
