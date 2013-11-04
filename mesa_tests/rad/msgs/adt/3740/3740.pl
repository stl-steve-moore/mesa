#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;

# Generate HL7 messages for Case 3740

  if (scalar(@ARGV) == 0) {
    copy("coral.var", "coral.txt");
  } else {
  # The file coral.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"3740.110.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"coral.txt",		# PID, PV1 data
	"3740.110.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("3740.110.a04");


