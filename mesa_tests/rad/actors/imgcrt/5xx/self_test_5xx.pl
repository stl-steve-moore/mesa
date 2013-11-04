#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require imgcrt;

$SIG{INT} = \&goodbye;

sub goodbye () {
  #Kill the MESA servers and exit

  print "Exiting...\n";

  exit 1;
}

# End of subroutines, beginning of the main code

$x = $ENV{'MESA_OS'};
die "Env variable MESA_OS is not set; please read Installation Guide \n" if $x eq "";

# 511 note
imgcrt::cstore("../../msgs/sr/511/sr_511_cr.dcm", "", "MESA_IMG_MGR",
			"localhost", "2350");

# 512 note
imgcrt::cstore("../../msgs/sr/512/sr_512_ct.dcm", "", "MESA_IMG_MGR",
			"localhost", "2350");

# 513 note
imgcrt::cstore("../../msgs/sr/513/sr_513_mr.dcm", "", "MESA_IMG_MGR",
			"localhost", "2350");

goodbye;
