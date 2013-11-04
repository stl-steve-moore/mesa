#!/usr/local/bin/perl -w
use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 Order Charge Posting messages for Case 1301

#  if (scalar(@ARGV) == 0) {
#    copy("1301.102.p01.var", "1301.102.p01.xxx");
#    copy("1301.104.p01.var", "1301.104.p01.xxx");
#  } else {
#  }
  mesa_msgs::create_text_file_2_var_files(
	"1301.102.p01.txt",		# This is the output
	"../templates/p01_dg1_gt1_in1.tpl",	# Template for an P01 message
	"../../adt/1301/alabama.txt",	# Demographics, PV1 information
	"1301.102.p01.var");		# Input with order information
  mesa_msgs::create_hl7("1301.102.p01");

# This message is now retired; we do not send it to the Order Filler
#  mesa_msgs::create_text_file_2_var_files(
#	"1301.104.p01.txt",		# This is the output
#	"../templates/p01_dg1_gt1_in1.tpl",		# Template for an P01 message
#	"../../adt/1301/alabama.txt",	# Demographics, PV1 information
#	"1301.104.p01.var");		# Input with order information
#  mesa_msgs::create_hl7("1301.104.p01");

