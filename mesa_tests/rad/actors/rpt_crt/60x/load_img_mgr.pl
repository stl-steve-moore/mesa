#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require rpt_crt;

$SIG{INT} = \&goodbye;

sub goodbye () {
  #Kill the MESA servers and exit

  print "Exiting...\n";

  exit 1;
}

# End of subroutines, beginning of the main code

print `perl scripts/reset_img_mgr.pl`;

# MR Knee exam
rpt_crt::send_images("MR/MR3/MR3S1", "60x/mr3_1.del", "MESA_IMG_MGR",
			"localhost", "2350");

rpt_crt::send_images("MR/MR3/MR3S2", "60x/mr3_2.del", "MESA_IMG_MGR",
			"localhost", "2350");


# CT Sprial Angio Thorax
rpt_crt::send_images("CT/CT5/CT5S1", "60x/ct5_1.del", "MESA_IMG_MGR",
			"localhost", "2350");

# CR Chest PA
rpt_crt::send_images("CR/CR3/CR3S1", "60x/cr3_1.del", "MESA_IMG_MGR",
			"localhost", "2350");
rpt_crt::mask_left("CR/CR3/CR3S1/CR3S1IM1.dcm", "60x/cr3_left.dcm", "1023");
rpt_crt::mask_right("CR/CR3/CR3S1/CR3S1IM1.dcm", "60x/cr3_right.dcm", "1023");
rpt_crt::send_images("60x/cr3_left.dcm", "60x/cr3_left.del", "MESA_IMG_MGR",
			"localhost", "2350");
rpt_crt::send_images("60x/cr3_right.dcm", "60x/cr3_right.del", "MESA_IMG_MGR",
			"localhost", "2350");

# Multimodality study
# CR Tibia: AP
rpt_crt::send_images("CR/CR2/CR2S1", "60x/mm1_1.del", "MESA_IMG_MGR",
			"localhost", "2350");

# MR Knee
rpt_crt::send_images("MR/MR9/MR9S1", "60x/mm1_2.del", "MESA_IMG_MGR",
			"localhost", "2350");

#
#$deltaFile = "40x/e.del";
#send_images("disp_cons");

goodbye;
