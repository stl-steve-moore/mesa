#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 Order messages for Case 152
# This directory is for order messages and does not
# include scheduling messages.

  if (scalar(@ARGV) == 0) {
    copy("152.104.o01.var", "152.104.o01.xxx");
  } else {
  }

  mesa_msgs::create_text_file_2_var_files(
	"152.104.o01.txt",		# This is the output
	"../templates/o01.tpl",		# Template for an O01 message
	"../../adt/152/magenta.txt",	# Demographics, PV1 information
	"152.104.o01.xxx");		# Input with order information
  mesa_msgs::create_hl7("152.104.o01");
