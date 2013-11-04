#!/usr/local/bin/perl -w
use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;

# Generate HL7 Order messages for Case 50001
# This directory is for order messages and does not
# include scheduling messages.


  if (scalar(@ARGV) == 0) {
    copy("50001.130.o01.var",  "50001.130.o01.xxx");
    copy("50001.131.o01.var",  "50001.131.o01.xxx");
    copy("50001.140.o02.var",  "50001.140.o02.xxx");
  } else {
  # .xxx files provided in an external step
  }

  mesa_msgs::create_text_file_2_var_files(
	"50001.130.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/50001/richmond.txt",	# Demographics, PV1 information
	"50001.130.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("50001.130.o01");

  mesa_msgs::create_text_file_2_var_files(
	"50001.131.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/50001/richmond.txt",	# Demographics, PV1 information
	"50001.131.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("50001.131.o01");

  mesa_msgs::create_text_file_2_var_files(
	"50001.140.o02.txt",		# This is the output
	"../templates/o02.tpl",		# Template for an O02 message
        "../../adt/50001/richmond.var",# Demographics, PV1 information
	"50001.140.o02.xxx");		# Input with order information
  mesa_msgs::create_hl7("50001.140.o02");

