#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;

# Generate HL7 messages for Case 3742

  mesa_msgs::create_text_file_2_var_files(
	"3742.135.o01.txt",	# The output file
	"../templates/o01.tpl",	# Template for an A04
	"../../adt/3742/ivory.txt",		# PID, PV1 data
	"3742.135.o01.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("3742.135.o01");
  
  mesa_msgs::create_text_file_2_var_files(
	"3742.130.o01.txt",	# The output file
	"../templates/o01.tpl",	# Template for an A04
	"../../adt/3742/aquamarine.txt",		# PID, PV1 data
	"3742.130.o01.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("3742.130.o01");


