#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;


# Generate HL7 messages for Case 10515

if (scalar(@ARGV) == 0) {
#  copy("alpha_domain1.var",   "alpha_domain1.txt");
} else {
# The files would have been produced externally
#  alpha_domain1.txt
}

  mesa_msgs::create_text_file_2_var_files (
	"10515.120.q23.txt",	# The output file
	"../templates/q23.tpl",	# Template for a Q23
	"null.txt",	# 
	"10515.120.q23.var"	# 
  );
  mesa_msgs::create_hl7("10515.120.q23");

  mesa_msgs::create_text_file_2_var_files (
	"10515.120.q23.txt",	# The output file
	"../templates/q23.tpl",	# Template for a Q23
	"null.txt",	# 
	"10515.120.q23.var"	# 
  );
  mesa_msgs::create_hl7("10515.120.q23");
