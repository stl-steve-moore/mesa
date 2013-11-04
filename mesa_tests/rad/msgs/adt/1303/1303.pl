#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;

# Generate HL7 messages for Case 1303

  if (scalar(@ARGV) == 0) {
    copy("arizona.var", "arizona.txt");
  } else {
  # The file arizona.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"1303.106.a01.txt", 	# The output file
	"../templates/a01.tpl",	# Template for an A01
	"arizona.txt",		# PID, PV1 data
	"1303.106.a01.var"	# A01 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("1303.106.a01");

  mesa_msgs::create_text_file_2_var_files(
	"1303.108.a01.txt", 	# The output file
	"../templates/a01.tpl",	# Template for an A01
	"arizona.txt",		# PID, PV1 data
	"1303.108.a01.var"	# A01 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("1303.108.a01");

