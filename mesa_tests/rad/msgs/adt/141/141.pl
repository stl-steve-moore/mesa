#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;


# Generate HL7 messages for Case 141

  if (scalar(@ARGV) == 0) {
    copy("141.demog.1.var", "141.demog.1.txt");
  } else {
  # The file 141.demog.1.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"141.102.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"141.demog.1.txt",	# PID, PV1 data
	"141.102.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("141.102.a04");

  mesa_msgs::create_text_file_2_var_files(
	"141.104.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"141.demog.1.txt",	# PID, PV1 data
	"141.104.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("141.104.a04");

