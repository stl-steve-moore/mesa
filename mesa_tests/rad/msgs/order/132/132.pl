#!/usr/local/bin/perl -w
use Env;
use File::Copy;

use lib "../../common";
require mesa_msgs;

# Generate HL7 Order messages for Case 132
# This directory is for order messages and does not
# include scheduling messages.


  if (scalar(@ARGV) == 0) {
    copy("132.104.o01.var",  "132.104.o01.xxx");
    copy("132.110.o01x.var", "132.110.o01x.xxx");
    copy("132.116.o01.var",  "132.116.o01.xxx");
    copy("132.118.o02.var",  "132.118.o02.xxx");
    copy("132.119.o01.var",  "132.119.o01.xxx");
  } else {
  # .xxx files provided in an external step
  }

  mesa_msgs::create_text_file_2_var_files(
	"132.104.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/132/wisteria.txt",	# Demographics, PV1 information
	"132.104.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("132.104.o01");


  mesa_msgs::create_text_file_2_var_files(
	"132.110.o01x.txt",		# This is the output
	"../templates/o01x.tpl",	# Template for an O01 cancel
        "../../adt/132/wisteria.txt",	# Demographics, PV1 information
	"132.110.o01x.xxx");		# Input with order information
  mesa_msgs::create_hl7("132.110.o01x");

  mesa_msgs::create_text_file_2_var_files(
	"132.116.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/132/wisteria.txt",	# Demographics, PV1 information
	"132.116.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("132.116.o01");

  mesa_msgs::create_text_file_2_var_files(
	"132.118.o02.txt",		# This is the output
	"../templates/o02.tpl",		# Template for an O02 message
        "../../adt/132/wisteria.var",	# Demographics, PV1 information
	"132.118.o02.xxx");		# Input with order information
  mesa_msgs::create_hl7("132.118.o02");

  mesa_msgs::create_text_file_2_var_files(
	"132.119.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/132/wisteria.txt",	# Demographics, PV1 information
	"132.119.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("132.119.o01");

