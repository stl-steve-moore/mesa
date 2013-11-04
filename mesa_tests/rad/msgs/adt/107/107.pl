#!/usr/local/bin/perl -w

# Generate HL7 messages for Case 132

use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;


  if (scalar(@ARGV) == 0) {
    copy("rose.var", "rose.txt");
  } else {
  # The file rose.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"107.102.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"rose.txt",		# PID, PV1 data
	"107.102.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("107.102.a04");

  mesa_msgs::create_text_file_2_var_files(
	"107.103.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"rose.txt",		# PID, PV1 data
	"107.103.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("107.103.a04");

