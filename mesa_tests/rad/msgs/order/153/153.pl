#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 Order messages for Case 153
# This directory is for order messages and does not
# include scheduling messages.

  if (scalar(@ARGV) == 0) {
    copy("153.104.o01.var", "153.104.o01.xxx");
  } else {
  }

  mesa_msgs::create_text_file_2_var_files(
	"153.104.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/153/periwinkle.txt",	# Demographics, PV1 information
	"153.104.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("153.104.o01");
