#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 Order messages for Case 100
# This directory is for order messages and does not
# include scheduling messages.

  if (scalar(@ARGV) == 0) {
    copy("100.106.o01.var", "100.106.o01.xxx");
    copy("100.108.o01.var", "100.108.o01.xxx");
    copy("100.110.o01.var", "100.110.o01.xxx");
    copy("100.112.o01.var", "100.112.o01.xxx");
  } else {
  }

  mesa_msgs::create_text_file_2_var_files(
	"100.106.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/100/king.txt",	# Demographics, PV1 information
	"100.106.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("100.106.o01");

  mesa_msgs::create_text_file_2_var_files(
	"100.108.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/100/king.txt",	# Demographics, PV1 information
	"100.108.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("100.108.o01");

  mesa_msgs::create_text_file_2_var_files(
	"100.110.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/100/queen.txt",	# Demographics, PV1 information
	"100.110.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("100.110.o01");

  mesa_msgs::create_text_file_2_var_files(
	"100.112.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/100/queen.txt",	# Demographics, PV1 information
	"100.112.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("100.112.o01");

