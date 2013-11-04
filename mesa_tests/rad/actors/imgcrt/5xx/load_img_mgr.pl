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

print `perl scripts/reset_servers.pl`;
die "Could not reset Image Manager \n" if ($?);

# MR Knee exam
imgcrt::send_images("MR/MR3/MR3S1", "5xx/mr3_1.del", "MESA_IMG_MGR",
			"localhost", "2350");

imgcrt::send_images("MR/MR3/MR3S2", "5xx/mr3_2.del", "MESA_IMG_MGR",
			"localhost", "2350");


# CT Sprial Angio Thorax
imgcrt::send_images("CT/CT5/CT5S1", "5xx/ct5_1.del", "MESA_IMG_MGR",
			"localhost", "2350");

# CR Chest PA
imgcrt::send_images("CR/CR3/CR3S1", "5xx/cr3_1.del", "MESA_IMG_MGR",
			"localhost", "2350");

# Multimodality study
# CR Tibia: AP
imgcrt::send_images("CR/CR2/CR2S1", "5xx/mm1_1.del", "MESA_IMG_MGR",
			"localhost", "2350");

# MR Knee
imgcrt::send_images("MR/MR9/MR9S1", "5xx/mm1_2.del", "MESA_IMG_MGR",
			"localhost", "2350");

#
#$deltaFile = "40x/e.del";
#send_images("disp_cons");

goodbye;
