#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;


# Generate HL7 messages for Case 11350

  mesa_msgs::create_text_file_2_var_files (
	"11350.110.q22.txt",	# The output file
	"../templates/q22.tpl",	# Template for a Q23
	"../11311/null.txt",	# 
	"11350.110.q22.var"	# 
  );
  mesa_msgs::create_hl7("11350.110.q22");

