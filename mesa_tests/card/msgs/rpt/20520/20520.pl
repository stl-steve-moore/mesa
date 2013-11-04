#!/usr/local/bin/perl -w

# Script takes one optional argument. If the argument
# is present (any character), this means that the .txt
# files we need have already been created.
# If the user includes 0 arguments, we copy the demographics
# from the original .var demographic files.

use Env;
use File::Copy;
use lib "../../../../rad/msgs/common";
require mesa_msgs;

# Generate HL7 messages for Case 20520

  if (scalar(@ARGV) == 0) {
    copy("doej1.var", "doej1.txt");
  }

  mesa_msgs::create_text_file_2_var_files(
	"20520.102.r01.txt",		# This is the output
	"../templates/r01.tpl",		# Template for an R01 message
	"doej1.txt",			# Demographics, PV1 information
	"20520.102.r01.var");		# Input with ADT information
  
  
  mesa_msgs::create_hl7("20520.102.r01");
  
  1;

  
