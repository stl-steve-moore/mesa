#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 Order messages for 107 series tests
# This directory is for order messages and does not
# include scheduling messages.

if (scalar(@ARGV) == 0) {
  copy("107.104.o01.var", "107.104.o01.xxx");
} else {
# .xxx files provided in an external step
}


  mesa_msgs::create_text_file_2_var_files(
	"107.104.o01.txt",	# The output file
	"../templates/o01.tpl",	# Template for an O01
	"../../adt/107/rose.txt",# PID, PV1 data
	"107.104.o01.xxx"	# O01 variables not in PID, PV1
  );
  mesa_msgs::create_hl7("107.104.o01");


