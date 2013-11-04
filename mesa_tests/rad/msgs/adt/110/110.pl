#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;

# Generate ADT HL7 messages for Case 110

  if (scalar(@ARGV) == 0) {
    copy("gold.var", "gold.txt");
  } else {
  # The file gold.txt would have been produced externally
  }

  mesa_msgs::create_text_file_2_var_files(
	"110.102.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"gold.txt",		# PID, PV1 data
	"110.102.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("110.102.a04");

  mesa_msgs::create_text_file_2_var_files(
	"110.104.a04.txt",	# The output file
	"../templates/a04.tpl",	# Template for an A04
	"gold.txt",		# PID, PV1 data
	"110.104.a04.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("110.104.a04");

