#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;

# Generate HL7 messages for Case 3740

  mesa_msgs::create_text_file_2_var_files(
	"3740.120.o01.txt",	# The output file
	"../templates/o01.tpl",	# Template for an ORM
	"../../adt/3740/coral.txt",		# PID, PV1 data
	"3740.120.o01.var"	# ORM variables not in PID, PV1
  );
  mesa_msgs::create_hl7("3740.120.o01");


