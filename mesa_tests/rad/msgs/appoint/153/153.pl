#!/usr/local/bin/perl -w

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 Order messages for Case 153
# This directory is for order messages and does not
# include scheduling messages.

  if (scalar(@ARGV) == 0) {
    copy("153.106.s12.var", "153.106.s12.xxx");
    copy("153.108.s15.var", "153.108.s15.xxx");
  } else {
  }

  mesa_msgs::create_text_file_2_var_files(
	"153.106.s12.txt",		# This is the output
	"../templates/s12.tpl",		# Template for an s12 message
	"../../adt/153/periwinkle.txt",	# Demographics, PV1 information
	"153.106.s12.xxx");		# Input with appoint information
  mesa_msgs::create_hl7("153.106.s12");

  mesa_msgs::create_text_file_2_var_files(
	"153.108.s15.txt",		# This is the output
	"../templates/s15.tpl",		# Template for an s13 message
	"../../adt/153/periwinkle.txt",	# Demographics, PV1 information
	"153.108.s15.xxx");		# Input with appoint information
  mesa_msgs::create_hl7("153.108.s15");
