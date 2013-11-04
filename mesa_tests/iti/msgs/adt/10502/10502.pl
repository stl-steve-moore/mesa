#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;


# Generate HL7 messages for Case 10512

if (scalar(@ARGV) == 0) {
  copy("beta_domain1.var",  "beta_domain1.txt");
  copy("cross_domain1.var", "cross_domain1.txt");
} else {
# The files would have been produced externally
#  beta_domain1.txt
#  cross_domain1.txt
}

  mesa_msgs::create_text_file_2_var_files (
	"10502.102.a04.txt",	# The output file
	"../templates/a04_iti8.tpl",	# Template for an A04: ITI-8
	"beta_domain1.txt",	# PID, PV1 data
	"10502.102.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("10502.102.a04");

  mesa_msgs::create_text_file_2_var_files (
	"10502.104.a04.txt",	# The output file
	"../templates/a04_iti8.tpl",	# Template for an A04: ITI-8
	"cross_domain1.txt",	# PID, PV1 data
	"10502.104.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("10502.104.a04");

