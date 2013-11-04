#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 Order messages for Case 152
# This directory is for order messages and does not
# include scheduling messages.

  if (scalar(@ARGV) == 0) {
    copy("152.106.s12.var", "152.106.s12.xxx");
    copy("152.110.s13.var", "152.110.s13.xxx");
  } else {
  }

  mesa_msgs::create_text_file_2_var_files(
	"152.106.s12.txt",		# This is the output
	"../templates/s12.tpl",		# Template for an s12 message
	"../../adt/152/magenta.txt",	# Demographics, PV1 information
	"152.106.s12.xxx");		# Input with appoint information
  mesa_msgs::create_hl7("152.106.s12");

  mesa_msgs::create_text_file_2_var_files(
	"152.110.s13.txt",		# This is the output
	"../templates/s13.tpl",		# Template for an s13 message
	"../../adt/152/magenta.txt",	# Demographics, PV1 information
	"152.110.s13.xxx");		# Input with appoint information
  mesa_msgs::create_hl7("152.110.s13");
