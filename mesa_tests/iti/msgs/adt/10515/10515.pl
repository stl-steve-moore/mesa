#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;


# Generate HL7 messages for Case 10512

if (scalar(@ARGV) == 0) {
  copy("washington_domain1.var", "washington_domain1.txt");
  copy("lincoln_domain1.var",   "lincoln_domain1.txt");
  copy("washington_domain2.var",   "washington_domain2.txt");
  copy("merge_domain1.var",	"merge_domain1.txt");
} else {
# The files would have been produced externally
#  washington_domain1.txt
#  lincoln_domain1.txt
#  lincoln_domain2.txt
}

  mesa_msgs::create_text_file_2_var_files (
	"10515.102.a04.txt",	# The output file
	"../templates/a04_iti8.tpl",	# Template for an A04: ITI-8
	"washington_domain1.txt",	# PID, PV1 data
	"10515.102.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("10515.102.a04");

  mesa_msgs::create_text_file_2_var_files (
	"10515.104.a04.txt",	# The output file
	"../templates/a04_iti8.tpl",	# Template for an A04: ITI-8
	"lincoln_domain1.txt",	# PID, PV1 data
	"10515.104.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("10515.104.a04");

  mesa_msgs::create_text_file_2_var_files (
	"10515.106.a04.txt",	# The output file
	"../templates/a04_iti8.tpl",	# Template for an A04: ITI-8
	"washington_domain2.txt",	# PID, PV1 data
	"10515.106.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("10515.106.a04");

  mesa_msgs::create_text_file_2_var_files (
	"10515.108.a40.txt",	# The output file
	"../templates/a40_iti8.tpl",	# Template for an A40: ITI-8
	"merge_domain1.txt",	# PID, PV1 data
	"10515.108.a40.var"	# A40 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("10515.108.a40");

