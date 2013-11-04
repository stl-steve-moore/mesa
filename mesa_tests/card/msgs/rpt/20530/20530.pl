#!/usr/local/bin/perl -w

# Script takes one optional argument. If the argument
# is present (any character), this means that the .txt
# files we need have already been created.
# If the user includes 0 arguments, we copy the demographics
# from the original .var demographic files.

use Env;
use File::Copy;
use Cwd;
use lib "../../../../rad/msgs/common";
require mesa_msgs;

# Generate HL7 messages for Case 20530

  if (scalar(@ARGV) == 0) {
    copy("brown.var", "brown.txt");
  }

  mesa_msgs::create_text_file_2_var_files(
	"20530.102.r01.txt",		# This is the output
	"../templates/r01.tpl",		# Template for an R01 message
	"brown.txt",			# Demographics, PV1 information
	"20530.102.r01.var");		# Input with ADT information
  
  
  mesa_msgs::create_hl7("20530.102.r01");
  
  #my $pwd = `pwd`;
  my $pwd = getcwd();
  chomp $pwd;

  mesa_msgs::addAttachment("20530.102.r01.hl7", 		#file to be modified 
			   "obx_pdf_to_be_attached",		#place holder
			   $pwd,				#directory where the attachment file is
			   "20530.102.r01.pdf"  		#file to be attached
			   );
  1;

  
