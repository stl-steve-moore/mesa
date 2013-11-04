#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 Order messages for Case 151
# This directory is for order messages and does not
# include scheduling messages.

  if (scalar(@ARGV) == 0) {
    copy("151.104.o01.var", "151.104.o01.xxx");
  } else {
  }

  mesa_msgs::create_text_file_2_var_files(
	"151.104.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/151/periwinkle.txt",	# Demographics, PV1 information
	"151.104.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("151.104.o01");
