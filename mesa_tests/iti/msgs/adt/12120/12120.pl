#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;


# Generate HL7 messages for Case 12120

if (scalar(@ARGV) == 0) {
  copy("yates.var", "yates.txt");
} else {
  # The file yates.txt would have been produced externally
}

  mesa_msgs::create_text_file_2_var_files (
	"12120.100.a28.txt",	# The output file
	"../templates/a28.tpl",	# Template for an A28
	"yates.txt",		# PID, PV1 data
	"12120.100.a28.var"	# A28 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("12120.100.a28");

  mesa_msgs::create_text_file_2_var_files (
	"12120.110.a01.txt",	# The output file
	"../templates/a01.tpl",	# Template for an A01
	"yates.txt",		# PID, PV1 data
	"12120.110.a01.var"	# A01 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("12120.110.a01");

  mesa_msgs::create_text_file_2_var_files (
	"12120.120.a03.txt",	# The output file
	"../templates/a03.tpl",	# Template for an A03
	"yates.txt",		# PID, PV1 data
	"12120.120.a03.var"	# A03 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("12120.120.a03");
