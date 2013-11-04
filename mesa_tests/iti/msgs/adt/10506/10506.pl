#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;


# Generate HL7 messages for Case 10506

if (scalar(@ARGV) == 0) {
  copy("tau_domain1.var",   "tau_domain1.txt");
  copy("tau_domain2.var",   "tau_domain2.txt");
  copy("tau_domain2_update.var",   "tau_domain2_update.txt");
} else {
# The files would have been produced externally
#  tau_domain1.txt
#  tau_domain2.txt
#  tau_domain2_update.txt
}

  mesa_msgs::create_text_file_2_var_files (
	"10506.102.a04.txt",	# The output file
	"../templates/a04_iti8.tpl",	# Template for an A04
	"tau_domain1.txt",	# PID, PV1 data
	"10506.102.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("10506.102.a04");

  mesa_msgs::create_text_file_2_var_files (
	"10506.104.a04.txt",	# The output file
	"../templates/a04_iti8.tpl",	# Template for an A04
	"tau_domain2.txt",	# PID, PV1 data
	"10506.104.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("10506.104.a04");

  mesa_msgs::create_text_file_2_var_files (
	"10506.108.a08.txt",	# The output file
	"../templates/a08_iti8.tpl",	# Template for an A04
	"tau_domain2_update.txt",	# PID, PV1 data
	"10506.108.a08.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("10506.108.a08");
