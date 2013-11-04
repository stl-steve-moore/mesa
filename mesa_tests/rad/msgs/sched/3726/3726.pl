#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;

# Generate HL7 messages for Case 3726

  mesa_msgs::create_text_file_2_var_files(
	"3726.130.o01.txt",	# The output file
	"../templates/o01.tpl",	# Template for an A04
	"../../adt/3726/lavender.txt",		# PID, PV1 data
	"3726.130.o01.var"	# A04 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("3726.130.o01");


