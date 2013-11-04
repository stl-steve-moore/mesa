#!/usr/local/bin/perl -w
use Env;
use File::Copy;
use lib "../../../../rad/msgs/common";
require mesa_msgs;

# Generate HL7 Order messages for Case 20204
# This directory is for order messages and does not
# include scheduling messages.

  if (scalar(@ARGV) == 0) {
    copy("20204.140.o01.var", "20204.140.o01.xxx");
    copy("20204.150.o02.var", "20204.150.o02.xxx");
  } else {
  }


  mesa_msgs::create_text_file_2_var_files(
	"20204.140.o01.txt",		# This is the output
	"../../../../rad/msgs/order/templates/o01.tpl",		# Template for an O01 message
	"../../adt/20204/stromberg.txt",	# Demographics, PV1 information
	"20204.140.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("20204.140.o01");

  mesa_msgs::create_text_file_2_var_files(
	"20204.150.o02.txt",		# This is the output
	"../../../../rad/msgs/order/templates/o02.tpl",		# Template for an O01 message
	"../../adt/20204/stromberg.txt",	# Demographics, PV1 information
	"20204.150.o02.xxx");		# Input with order information
  mesa_msgs::create_hl7("20204.150.o02");

