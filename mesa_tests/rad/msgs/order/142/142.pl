#!/usr/local/bin/perl -w
use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;

# Generate HL7 Order messages for Case 142
# This directory is for order messages and does not
# include scheduling messages.


  if (scalar(@ARGV) == 0) {
    copy("142.106.o01.var",  "142.106.o01.xxx");
    copy("142.110.o01x.var", "142.110.o01x.xxx");
    copy("142.116.o01.var",  "142.116.o01.xxx");
    copy("142.118.o02.var",  "142.118.o02.xxx");
    copy("142.119.o01.var",  "142.119.o01.xxx");
  } else {
  # .xxx files provided in an external step
  }

  mesa_msgs::create_text_file_2_var_files(
	"142.106.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/142/142.demog.1.txt",# Demographics, PV1 information
	"142.106.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("142.106.o01");

  mesa_msgs::create_text_file_2_var_files(
	"142.110.o01x.txt",		# This is the output
	"../templates/o01x.tpl",	# Template for an O01 message (cancel)
	"../../adt/142/142.demog.1.txt",# Demographics, PV1 information
	"142.110.o01x.xxx");		# Input with order information
  mesa_msgs::create_hl7("142.110.o01x");

  mesa_msgs::create_text_file_2_var_files(
	"142.116.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/142/142.demog.1.txt",# Demographics, PV1 information
	"142.116.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("142.116.o01");

  mesa_msgs::create_text_file_2_var_files(
	"142.118.o02.txt",		# This is the output
	"../templates/o02.tpl",		# Template for an O01 message
	"../../adt/142/142.demog.1.txt",# Demographics, PV1 information
	"142.118.o02.xxx");		# Input with order information
  mesa_msgs::create_hl7("142.118.o02");

  mesa_msgs::create_text_file_2_var_files(
	"142.119.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/142/142.demog.1.txt",# Demographics, PV1 information
	"142.119.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("142.119.o01");

