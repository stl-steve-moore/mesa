#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../../../rad/msgs/common";
require mesa_msgs;

# Generate HL7 messages for Case 20712

  if (scalar(@ARGV) == 0) {
    copy("flora.var", "flora.txt");
      } else {
  # The file violet.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"20712.110.a04.txt",	# The output file
	"../../../../rad/msgs/adt/templates/a04.tpl",	# Template for an A04
	"flora.txt",		# PID, PV1 data
	"20712.110.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("20712.110.a04");



