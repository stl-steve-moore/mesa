#!/usr/local/bin/perl -w
use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 Order messages for Case 133
# This directory is for order messages and does not
# include scheduling messages.

  if (scalar(@ARGV) == 0) {
    copy("133.144.o01.var", "133.144.o01.xxx");
    copy("133.146.o02.var", "133.146.o02.xxx");
    copy("133.147.o01.var", "133.147.o01.xxx");
  } else {
  }


  mesa_msgs::create_text_file_2_var_files(
	"133.144.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/133/doe.txt",	# Demographics, PV1 information
	"133.144.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("133.144.o01");

  mesa_msgs::create_text_file_2_var_files(
	"133.146.o02.txt",		# This is the output
	"../templates/o02.tpl",		# Template for an O01 message
	"../../adt/133/doe.txt",	# Demographics, PV1 information
	"133.146.o02.xxx");		# Input with order information
  mesa_msgs::create_hl7("133.146.o02");

  mesa_msgs::create_text_file_2_var_files(
	"133.147.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/133/doe.txt",	# Demographics, PV1 information
	"133.147.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("133.147.o01");
