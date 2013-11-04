#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;


# Generate HL7 messages for Case 12101

if (scalar(@ARGV) == 0) {
  copy("frost.var", "frost.txt");
} else {
# The file frost.txt would have been produced externally
}

  mesa_msgs::create_text_file_2_var_files (
	"12101.102.a28.txt",	# The output file
	"../templates/a28.tpl",	# Template for an A04
	"frost.txt",		# PID, PV1 data
	"12101.102.a28.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("12101.102.a28");
