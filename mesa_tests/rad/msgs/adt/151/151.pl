#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;

# Generate HL7 messages for Case 151

  if (scalar(@ARGV) == 0) {
    copy("periwinkle.var", "periwinkle.txt");
  } else {
  # The files periwinkle.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"151.102.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"periwinkle.txt",		# PID, PV1 data
	"151.102.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("151.102.a04");

  mesa_msgs::create_text_file_2_var_files(
	"151.103.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"periwinkle.txt",		# PID, PV1 data
	"151.103.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("151.103.a04");
