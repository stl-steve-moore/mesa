#!/usr/local/bin/perl -w
use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 Order Charge Posting messages for Case 1302

#  if (scalar(@ARGV) == 0) {
#    copy("1302.102.p01.var", "1302.102.p01.xxx");
#    copy("1302.104.p01.var", "1302.104.p01.xxx");
#    copy("1302.110.p05.var", "1302.110.p05.xxx");
#    copy("1302.112.p05.var", "1302.112.p05.xxx");
#  } else {
#  }
  mesa_msgs::create_text_file_2_var_files(
	"1302.102.p01.txt",		# This is the output
	"../templates/p01_dg1_gt1_in1.tpl",	# Template for an P01 message
	"../../adt/1302/alaska.txt",	# Demographics, PV1 information
	"1302.102.p01.var");		# Input with order information
  mesa_msgs::create_hl7("1302.102.p01");

# Message 1302.104.p01.hl7 is retired. We no longer send
# this to the Order Filler actor.
#  mesa_msgs::create_text_file_2_var_files(
#	"1302.104.p01.txt",		# This is the output
#	"../templates/p01_dg1_gt1_in1.tpl",		# Template for an P01 message
#	"../../adt/1302/alaska.txt",	# Demographics, PV1 information
#	"1302.104.p01.var");		# Input with order information
#  mesa_msgs::create_hl7("1302.104.p01");

  mesa_msgs::create_text_file_2_var_files(
	"1302.110.p05.txt",		# This is the output
	"../templates/p05_dg1_gt1_in1.tpl",	# Template for an P01 message
	"../../adt/1302/alaska.txt",	# Demographics, PV1 information
	"1302.110.p05.var");		# Input with order information
  mesa_msgs::create_hl7("1302.110.p05");

# Message 1302.112.p01.hl7 is retired. We no longer send
# this to the Order Filler actor.
#  mesa_msgs::create_text_file_2_var_files(
#	"1302.112.p05.txt",		# This is the output
#	"../templates/p05_dg1_gt1_in1.tpl",	# Template for an P01 message
#	"../../adt/1302/alaska.txt",	# Demographics, PV1 information
#	"1302.112.p05.var");		# Input with order information
#  mesa_msgs::create_hl7("1302.112.p05");

