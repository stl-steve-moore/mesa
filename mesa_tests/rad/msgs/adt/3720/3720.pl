#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;

# Generate HL7 messages for Case 3720

  if (scalar(@ARGV) == 0) {
    copy("goldenrod.var", "goldenrod.txt");
      } else {
  # The file goldenrod.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"3720.102.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"goldenrod.txt",		# PID, PV1 data
	"3721.102.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("3720.102.a04");



