#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;


# Generate HL7 messages for Case 11312

if (scalar(@ARGV) == 0) {
#  copy("alpha_domain1.var",   "alpha_domain1.txt");
#  copy("alpha_domain2.var",   "alpha_domain2.txt");
#  copy("simpson_domain1.var", "simpson_domain1.txt");
} else {
# The files would have been produced externally
#  alpha_domain1.txt
#  alpha_domain2.txt
#  simpson_domain1.txt
}

  mesa_msgs::create_text_file_2_var_files (
	"11312.102.q22.txt",	# The output file
	"../templates/q22.tpl",	# Template for a Q23
	"null.txt",	# 
	"11312.102.q22.var"	# 
  );
  mesa_msgs::create_hl7("11312.102.q22");

