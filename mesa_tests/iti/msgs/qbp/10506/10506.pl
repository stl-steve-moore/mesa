#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;


# Generate HL7 messages for Case 10506

if (scalar(@ARGV) == 0) {
} else {
# The files would have been produced externally
}

  mesa_msgs::create_text_file_2_var_files (
	"10506.106.q23.txt",	# The output file
	"../templates/q23.tpl",	# Template for a Q23
	"null.txt",	# 
	"10506.106.q23.var"	# 
  );
  mesa_msgs::create_hl7("10506.106.q23");

  mesa_msgs::create_text_file_2_var_files (
	"10506.110.q23.txt",	# The output file
	"../templates/q23.tpl",	# Template for a Q23
	"null.txt",	# 
	"10506.110.q23.var"	# 
  );
  mesa_msgs::create_hl7("10506.110.q23");
