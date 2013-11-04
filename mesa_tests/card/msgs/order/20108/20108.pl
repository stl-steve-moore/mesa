#!/usr/local/bin/perl -w
use Env;
use File::Copy;
use lib "../../../../rad/msgs/common";
require mesa_msgs;

# Generate HL7 Order messages for Case 20108
# This directory is for order messages and does not
# include scheduling messages.

  if (scalar(@ARGV) == 0) {
    copy("20108.106.o01.var", "20108.106.o01.xxx");
  } else {
  }


  mesa_msgs::create_text_file_2_var_files(
	"20108.106.o01.txt",		# This is the output
	"../../../../rad/msgs/order/templates/o01.tpl",		# Template for an O01 message
	"../../adt/20108/perry.txt",	# Demographics, PV1 information
	"20108.106.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("20108.106.o01");

