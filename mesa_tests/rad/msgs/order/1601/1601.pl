#!/usr/local/bin/perl -w
use Env;
use File::Copy;
use lib "../../common";
require mesa_msgs;

# Generate HL7 Order messages for Case 1601
# This directory is for order messages and does not
# include scheduling messages.

  if (scalar(@ARGV) == 0) {
    copy("1601.106.o01.var", "1601.106.o01.xxx");
  } else {
  # .xxx files provided in an external step
  }

  mesa_msgs::create_text_file_2_var_files(
	"1601.106.o01.txt",              # This is the output
	"../templates/o01.tpl",         # Template for an O01 message
	"../../adt/1601/washington.txt",        # Demographics, PV1 information
	"1601.106.o01.xxx");             # Input with order information
  mesa_msgs::create_hl7("1601.106.o01");

