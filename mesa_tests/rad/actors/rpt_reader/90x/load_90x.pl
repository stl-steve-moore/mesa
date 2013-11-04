#!/usr/local/bin/perl -w

# Script sends initial report to Report Manager for 8xx tests.

use Env;
use Cwd;
use lib "scripts";
require rpt_reader;

print `perl scripts/reset_servers.pl`;

rpt_reader::cstore("../../msgs/sr/601/sr_601cr.dcm", "",  "MESA_RPT_REPOS",
	"localhost", "2800");

rpt_reader::cstore("../../msgs/sr/602/sr_602ct.dcm", "",  "MESA_RPT_REPOS",
	"localhost", "2800");

rpt_reader::cstore("../../msgs/sr/603/sr_603mr.dcm", "",  "MESA_RPT_REPOS",
	"localhost", "2800");

rpt_reader::cstore("../../msgs/sr/611/sr_611.dcm", "",  "MESA_RPT_REPOS",
	"localhost", "2800");

# CR Chest PA
rpt_reader::send_images("CR/CR3/CR3S1", "../rpt_crt/60x/cr3_1.del",
		"MESA_IMG_MGR", "localhost", "2350");

# MR Knee exam
rpt_reader::send_images("MR/MR3/MR3S1", "../rpt_crt/60x/mr3_1.del",
		"MESA_IMG_MGR", "localhost", "2350");

rpt_reader::send_images("MR/MR3/MR3S2", "../rpt_crt/60x/mr3_2.del",
		"MESA_IMG_MGR", "localhost", "2350");

# CT Sprial Angio Thorax
rpt_reader::send_images("CT/CT5/CT5S1", "../rpt_crt/60x/ct5_1.del",
		"MESA_IMG_MGR", "localhost", "2350");

exit 0;

#`perl 90x/make_sr_90x.pl`;
#
#rpt_reader::cstore("90x/sr_901cr.dcm", "",   "MESA_RPT_REPOS", "localhost",
#	"2800");
#rpt_reader::cstore("90x/sr_901cr_v.dcm", "", "MESA_RPT_REPOS", "localhost",
#	"2800");
#rpt_reader::cstore("90x/sr_901ct.dcm", "",   "MESA_RPT_REPOS", "localhost",
#	"2800");
#rpt_reader::cstore("90x/sr_901mr.dcm", "",   "MESA_RPT_REPOS", "localhost",
#	"2800");


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

