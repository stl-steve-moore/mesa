#!/usr/local/bin/perl -w
use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 Order Charge Posting messages for Case 1305

#  if (scalar(@ARGV) == 0) {
#    copy("1305.102.p01.var", "1305.102.p01.xxx");
#    copy("1305.104.p01.var", "1305.104.p01.xxx");
#    copy("1305.126.p03.var", "1305.126.p03.xxx");
#    copy("1305.128.p03.var", "1305.128.p03.xxx");
#  } else {
#  }
  mesa_msgs::create_text_file_2_var_files(
	"1305.102.p01.txt",		# This is the output
	"../templates/p01_dg1_gt1_in1.tpl",	# Template for an P01 message
	"../../adt/1305/california.txt",	# Demographics, PV1 information
	"1305.102.p01.var");		# Input with order information
  mesa_msgs::create_hl7("1305.102.p01");

  mesa_msgs::create_text_file_2_var_files(
	"1305.104.p01.txt",		# This is the output
	"../templates/p01_dg1_gt1_in1.tpl",		# Template for an P01 message
	"../../adt/1305/california.txt",	# Demographics, PV1 information
	"1305.104.p01.var");		# Input with order information
  mesa_msgs::create_hl7("1305.104.p01");

  mesa_msgs::create_text_file_2_var_files(
	"1305.126.p03.txt",		# This is the output
	"../templates/p03.tpl",		# Template for an P01 message
	"../../adt/1305/california.txt",# Demographics, PV1 information
	"1305.126.p03.var");		# Input with order information
  mesa_msgs::create_hl7("1305.126.p03");

  mesa_msgs::create_text_file_2_var_files(
	"1305.128.p03.txt",		# This is the output
	"../templates/p03.tpl",		# Template for an P01 message
	"../../adt/1305/california.txt",# Demographics, PV1 information
	"1305.128.p03.var");		# Input with order information
  mesa_msgs::create_hl7("1305.128.p03");
