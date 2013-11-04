#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 Order messages for Case 105
# This directory is for order messages and does not
# include scheduling messages.

  if (scalar(@ARGV) == 0) {
    copy("105.114.o01.var", "105.114.o01.xxx");
    copy("105.116.o02.var", "105.116.o02.xxx");
    copy("105.117.o01.var", "105.117.o01.xxx");
  } else {
  }

  mesa_msgs::create_text_file_2_var_files(
	"105.114.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/105/doe.txt",	# Demographics, PV1 information
	"105.114.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("105.114.o01");

  mesa_msgs::create_text_file_2_var_files(
        "105.116.o02.txt",              # This is the output
        "../templates/o02.tpl",         # Template for an O01 message
        "../../adt/105/doe.txt",        # Demographics, PV1 information
        "105.116.o02.xxx");             # Input with order information
  mesa_msgs::create_hl7("105.116.o02");

  mesa_msgs::create_text_file_2_var_files(
        "105.117.o01.txt",              # This is the output
        "../templates/o01.tpl",         # Template for an O01 message
        "../../adt/105/doe.txt",        # Demographics, PV1 information
        "105.117.o01.xxx");             # Input with order information
  mesa_msgs::create_hl7("105.117.o01");


