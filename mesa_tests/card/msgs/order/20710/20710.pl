#!/usr/local/bin/perl -w

use Env;
use File::Copy;

use lib "../../../../rad/msgs/common";
require mesa_msgs;

# Generate HL7 messages for Case 20710

  mesa_msgs::create_text_file_2_var_files(
	"20710.120.o01.txt",	# The output file
	"../../../../rad/msgs/order/templates/o01.tpl",	# Template for an O01
	"../../adt/20710/anna.txt",		# PID, PV1 data
	"20710.120.o01.var"	# O01 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("20710.120.o01");


