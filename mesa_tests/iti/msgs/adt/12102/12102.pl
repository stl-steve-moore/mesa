#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;


# Generate HL7 messages for Case 12102

if (scalar(@ARGV) == 0) {
  copy("brown.var", "brown.txt");
  copy("jackson.var", "jackson.txt");
} else {
# The file brown.txt would have been produced externally
}

  mesa_msgs::create_text_file_2_var_files (
	"12102.102.a28.txt",	# The output file
	"../templates/a28.tpl",	# Template for A28
	"brown.txt",		# PID, PV1 data
	"12102.102.a28.var"	# A28 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("12102.102.a28");
  
  mesa_msgs::create_text_file_2_var_files (
	"12102.104.a31.txt",	# The output file
	"../templates/a31.tpl",	# Template for A31
	"jackson.txt",		# updated PID, PV1 data
	"12102.104.a31.var"	# A31 variables not in PID
  );
  mesa_msgs::create_hl7("12102.104.a31");  
