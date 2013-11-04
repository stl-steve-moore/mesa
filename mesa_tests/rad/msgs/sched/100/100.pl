#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 scheduling messages for Case 100

  if (scalar(@ARGV) == 0) {
    copy("100.112.o01.var", "100.112.o01.xxx");
    copy("100.114.o01.var", "100.114.o01.xxx");
    copy("100.116.o01.var", "100.116.o01.xxx");
    copy("100.118.o01.var", "100.118.o01.xxx");
  } else {
  }

  mesa_msgs::create_text_file_2_var_files(
	"100.112.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/100/king.txt",	# Demographics, PV1 information
	"100.112.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("100.112.o01");

  mesa_msgs::create_text_file_2_var_files(
	"100.114.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/100/king.txt",	# Demographics, PV1 information
	"100.114.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("100.114.o01");

  mesa_msgs::create_text_file_2_var_files(
	"100.116.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/100/queen.txt",	# Demographics, PV1 information
	"100.116.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("100.116.o01");

  mesa_msgs::create_text_file_2_var_files(
	"100.118.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/100/queen.txt",	# Demographics, PV1 information
	"100.118.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("100.118.o01");
