#!/usr/local/bin/perl -w

# Script takes one optional argument. If the argument
# is present (any character), this means that the .txt
# files we need have already been created.
# If the user includes 0 arguments, we copy the demographics
# from the original .var demographic files.

use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 messages for Case 103

  if (scalar(@ARGV) == 0) {
    copy("doej1.var", "doej1.txt");
    copy("silverheels.var", "silverheels.txt");
  } else {
  }

  mesa_msgs::create_text_file_2_var_files(
	"103.102.a04.txt",		# This is the output
	"../templates/a04.tpl",		# Template for an A04 message
	"../../adt/103/doej1.txt",	# Demographics, PV1 information
	"103.102.a04.var");		# Input with ADT information
  mesa_msgs::create_hl7("103.102.a04");

  mesa_msgs::create_text_file_2_var_files(
	"103.103.a04.txt",		# This is the output
	"../templates/a04.tpl",		# Template for an A04 message
	"../../adt/103/doej1.txt",	# Demographics, PV1 information
	"103.103.a04.var");		# Input with ADT information
  mesa_msgs::create_hl7("103.103.a04");

  mesa_msgs::create_text_file_2_var_files(
	"103.130.a08.txt",		# This is the output
	"../templates/a08.tpl",		# Template for an A04 message
	"../../adt/103/silverheels.txt",# Demographics, PV1 information
	"103.130.a08.var");		# Input with ADT information
  mesa_msgs::create_hl7("103.130.a08");

  mesa_msgs::create_text_file_2_var_files(
	"103.132.a08.txt",		# This is the output
	"../templates/a08.tpl",		# Template for an A04 message
	"../../adt/103/silverheels.txt",# Demographics, PV1 information
	"103.132.a08.var");		# Input with ADT information
  mesa_msgs::create_hl7("103.132.a08");

