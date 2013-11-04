#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;


# Generate HL7 messages for Case 12103

if (scalar(@ARGV) == 0) {
} else {
}

  mesa_msgs::create_text_file_2_var_files (
	"12103.110.a28.txt",	# The output file
	"../templates/a28.tpl",	# Template for an A04
	"../113aa/abel_6011.txt",		# PID, PV1 data
	"12103.110.a28.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("12103.110.a28");

  mesa_msgs::create_text_file_2_var_files (
	"12103.120.a28.txt",	# The output file
	"../templates/a28.tpl",	# Template for an A04
	"../113aa/david_6012.txt",		# PID, PV1 data
	"12103.120.a28.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("12103.120.a28");

  mesa_msgs::create_text_file_2_var_files (
	"12103.130.a28.txt",	# The output file
	"../templates/a28.tpl",	# Template for an A04
	"../113aa/frank_6013.txt",		# PID, PV1 data
	"12103.130.a28.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("12103.130.a28");

  mesa_msgs::create_text_file_2_var_files (
	"12103.140.a28.txt",	# The output file
	"../templates/a28.tpl",	# Template for an A04
	"../113aa/harriet_6014.txt",		# PID, PV1 data
	"12103.140.a28.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("12103.140.a28");

  mesa_msgs::create_text_file_2_var_files (
	"12103.150.a28.txt",	# The output file
	"../templates/a28.tpl",	# Template for an A04
	"../113aa/francis_6015.txt",		# PID, PV1 data
	"12103.150.a28.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("12103.150.a28");

