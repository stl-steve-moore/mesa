#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;


# Generate HL7 messages for Case 10512

if (scalar(@ARGV) == 0) {
  copy("epsilon.var", "epsilon.txt");
  copy("epsilon_iso.var", "epsilon_iso.txt");
  copy("epsilon_iso_only.var", "epsilon_iso_only.txt");
} else {
# The file epsilon.txt would have been produced externally
}

  mesa_msgs::create_text_file_2_var_files (
	"10512.102.a04.txt",	# The output file
	"../templates/a04_iti8.tpl",	# Template for an A04
	"epsilon.txt",		# PID, PV1 data
	"10512.102.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("10512.102.a04");

  mesa_msgs::create_text_file_2_var_files (
	"10512.104.a04.txt",	# The output file
	"../templates/a04_iti8.tpl",	# Template for an A04
	"epsilon_iso.txt",		# PID, PV1 data
	"10512.102.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("10512.104.a04");

  mesa_msgs::create_text_file_2_var_files (
	"10512.106.a04.txt",	# The output file
	"../templates/a04_iti8.tpl",	# Template for an A04
	"epsilon_iso_only.txt",		# PID, PV1 data
	"10512.102.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("10512.106.a04");
