#!/usr/local/bin/perl -w
use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;


# Generate ADT messages for case 1301.
  if (scalar(@ARGV) == 0) {
    copy("alabama.var", "alabama.txt");
  } else {
  # The file alabama.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"1301.106.a01.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"alabama.txt",		# PID, PV1 data
	"1301.106.a01.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("1301.106.a01");

