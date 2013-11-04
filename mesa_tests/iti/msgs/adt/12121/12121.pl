#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;


# Generate HL7 messages for Case 12120

if (scalar(@ARGV) == 0) {
  copy("smith.var", "smith.txt");
} else {
  # The file smith.txt would have been produced externally
}

  mesa_msgs::create_text_file_2_var_files (
	"12121.100.a28.txt",	# The output file
	"../templates/a28.tpl",	# Template for an A28
	"smith.txt",		# PID, PV1 data
	"12121.100.a28.var"	# A28 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("12121.100.a28");

  mesa_msgs::create_text_file_2_var_files (
	"12121.110.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"smith.txt",		# PID, PV1 data
	"12121.110.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("12121.110.a04");
